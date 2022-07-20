global class OppRollup implements Database.Batchable<SObject> {
    
    global Iterable<SObject> start(Database.BatchableContext bc) {
        //System.debug('define query');
        Datetime oneWeekAgo = System.today()-7;
        
        List<Opportunity> opps = [SELECT Id, Need_Rollup__c, Trigger_Rollup__c, Contact__c, Yearly_Students__c, Description,
            Yearly_Savings__c, Department_Adoption__c, Department_Opportunity__c, Book_Opportunity__c,
            sort__c, DeptSort__c, AccountId, Fall_Students__c, Spring_Students__c, Summer_Students__c,
            Fall_Dept_Max_Students__c, Spring_Dept_Max_Students__c, Summer_Dept_Max_Students__c
        FROM Opportunity
        WHERE Need_Rollup__c = TRUE
        AND LastModifiedDate > :oneWeekAgo //maybe use DateTime oneWeekAgo = System.Today()-7;
        AND Opportunity_Record_Type_Name__c = 'Book Opp'
        ORDER BY Contact__c
        ];
        //System.debug('Opps: '+opps);
        return opps;
    
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> opps){
        //System.debug('Execute');
        calculateRollup(opps);
    }
    
    @InvocableMethod
    global static void calculateRollup(List<Opportunity> opps){
        //System.debug('Start OppRollup');
        //System.debug('Opps: '+opps);
        
        //Make empty set to collect school IDs. Using a set because it cannot contain duplicates
        Set<Id> setContactID  = new Set<Id>();
        Set<Id> setAccountID = new Set<Id>();
        List<Opportunity> deptsNeedRollup = new List<Opportunity>();
        List<Opportunity> normalOppsUpdate = new List<Opportunity>();
        List<Opportunity> depts = new List<Opportunity>();
        
        //Loop through Opps and add to set
        for(Opportunity opp : opps){
            //system.debug('Opp: '+Opp);
            opp.Need_Rollup__c = false;
            opp.Trigger_Rollup__c = false;
            if(opp.Department_Adoption__c == false && !duplicateDeptOpportunity(opp, deptsNeedRollup)){
                //System.debug('Opp not duplicate: ' + opp);
                if (opp.Contact__c != null) {
                    setContactID.add(opp.Contact__c);
                }
                if (opp.AccountId != null) {
                    setAccountID.add(opp.AccountId);
                }
                if (opp.Department_Opportunity__c != null) {
                    Opportunity oppdept = new Opportunity();
                    oppdept.Id = opp.Department_Opportunity__c;
                    oppdept.Need_Rollup__c = true;
                    deptsNeedRollup.add(oppdept);
                }
                normalOppsUpdate.add(opp);
            }
            else{
                //System.debug('adding to depts: ' + opp);
                depts.add(opp);
            }
        }
        
        
        ///////////////////////////////////////////////////////Contacts
        if(setContactID.size()>0){
            //Get Map of objects, for easy updating
            Map<Id,Contact> mapContacts = new Map<Id,Contact> (
            [SELECT Id, Current_Students__c, Future_Students__c,
                Previous_Students__c, Past_Students__c,
                Fall_Students__c , Spring_Students__c,
                Number_of_Subjects__c, Books_Adopted__c,
                Initial_Adoption_Date__c, Renewal_Date__c,
                Savings_Current_Year__c , Savings_Next_Year__c,
                Savings_Past_Years__c, Savings_Previous_Year__c ,
                Possible_Students_Year__c
            FROM Contact WHERE Id IN :setContactID FOR UPDATE]);
            //System.debug('mapContacts: '+mapContacts);
            
            //Set Students to 0, so we can iterate and add
            for(Id idContact : mapContacts.keySet() ){
                mapContacts.get(idContact).Current_Students__c 		= 0 ;
                mapContacts.get(idContact).Future_Students__c 		= 0 ;
                mapContacts.get(idContact).Previous_Students__c 	= 0 ;
                mapContacts.get(idContact).Past_Students__c 		= 0 ;
                mapContacts.get(idContact).Fall_Students__c 		= 0 ;
                mapContacts.get(idContact).Spring_Students__c 		= 0 ;
                mapContacts.get(idContact).Number_of_Subjects__c	= 0 ;
                mapContacts.get(idContact).Savings_Current_Year__c	= 0 ;
                mapContacts.get(idContact).Savings_Next_Year__c		= 0 ;
                mapContacts.get(idContact).Savings_Past_Years__c	= 0 ;
                mapContacts.get(idContact).Savings_Previous_Year__c	= 0 ;
                mapContacts.get(idContact).Books_Adopted__c 		= null;
                mapContacts.get(idContact).Initial_Adoption_Date__c = null;//date.newInstance(2050,01,01);
                mapContacts.get(idContact).Renewal_Date__c 			= null;//date.newInstance(2000,01,01);
            }
            
            //Get list of Opportunities underneath the Contact OR Dept OR Adoption
            List<Opportunity> allOpps = [SELECT Id, Contact__c, Department_Adoption__c, Yearly_Students__c,
                AccountId , Base_Year__c, Fall_Students__c, Spring_Students__c, Book_Text__c,
                CloseDate , Department_Opportunity__c, Students__c, Class_Start_Date__c, Description,
                Yearly_Savings__c, IsWon, IsClosed, Opportunity_Record_Type_Name__c
            FROM Opportunity
            WHERE Contact__c IN :setContactID AND Department_Adoption__c = false
            LIMIT 10000];
            //System.debug('allOpps: '+ allOpps);
            
            //get current school year/term
            Integer baseyear = Date.today().year() - (Date.today().month() <7 ? 1 : 0);
            //System.debug('baseyear: '+baseyear);
            
            //Loop through allOpps, add student values
            for(Opportunity opp: allOpps){
                //System.debug('opp: '+opp);
                //Contacts
                if(opp.Opportunity_Record_Type_Name__c == 'Book Opp' && opp.IsWon == true){
                    mapContacts.get(opp.Contact__c).Future_Students__c 			+= (opp.Base_Year__c >  baseyear  ? opp.Yearly_Students__c : 0);
                    mapContacts.get(opp.Contact__c).Current_Students__c  		+= (opp.Base_Year__c == baseyear  ? opp.Yearly_Students__c : 0);
                    mapContacts.get(opp.Contact__c).Previous_Students__c 		+= (opp.Base_Year__c == baseyear-1? opp.Yearly_Students__c : 0);
                    mapContacts.get(opp.Contact__c).Past_Students__c  			+= (opp.Base_Year__c <  baseyear-1? opp.Yearly_Students__c : 0);
                    mapContacts.get(opp.Contact__c).Savings_Next_Year__c 		+= (opp.Base_Year__c >  baseyear  ? opp.Yearly_Savings__c  : 0);
                    mapContacts.get(opp.Contact__c).Savings_Current_Year__c 	+= (opp.Base_Year__c == baseyear  ? opp.Yearly_Savings__c  : 0);
                    mapContacts.get(opp.Contact__c).Savings_Previous_Year__c 	+= (opp.Base_Year__c == baseyear-1? opp.Yearly_Savings__c  : 0);
                    mapContacts.get(opp.Contact__c).Savings_Past_Years__c  		+= (opp.Base_Year__c <  baseyear-1? opp.Yearly_Savings__c  : 0);
                    if(opp.Base_Year__c == baseyear ){ // setting books adopted
                        //Change to use String.isBlank()
                        if(mapContacts.get(opp.Contact__c).Books_Adopted__c == null ){
                            mapContacts.get(opp.Contact__c).Books_Adopted__c = opp.Book_Text__c;
                        }
                        //combine statement with if above
                        else if ( !mapContacts.get(opp.Contact__c).Books_Adopted__c.contains(opp.Book_Text__c) ){
                            mapContacts.get(opp.Contact__c).Books_Adopted__c += ', ' + opp.Book_Text__c;
                        }
                    }
                    if(mapContacts.get(opp.Contact__c).Initial_Adoption_Date__c == null){
                        mapContacts.get(opp.Contact__c).Initial_Adoption_Date__c = opp.CloseDate;
                    }
                    else{
                        mapContacts.get(opp.Contact__c).Initial_Adoption_Date__c = (opp.CloseDate < mapContacts.get(opp.Contact__c).Initial_Adoption_Date__c ? opp.CloseDate : mapContacts.get(opp.Contact__c).Initial_Adoption_Date__c);
                    }
                    if(mapContacts.get(opp.Contact__c).Renewal_Date__c == null){
                        mapContacts.get(opp.Contact__c).Renewal_Date__c = opp.CloseDate;
                    }
                    else{
                        mapContacts.get(opp.Contact__c).Renewal_Date__c = (opp.CloseDate > mapContacts.get(opp.Contact__c).Renewal_Date__c ? opp.CloseDate : mapContacts.get(opp.Contact__c).Renewal_Date__c);
                    }
                    if(opp.Fall_Students__c != null){
                        mapContacts.get(opp.Contact__c).Fall_Students__c = mapContacts.get(opp.Contact__c).Fall_Students__c + (opp.Base_Year__c == baseyear  ? opp.Fall_Students__c : 0);
                    }
                    if(opp.Spring_Students__c != null){
                        mapContacts.get(opp.Contact__c).Spring_Students__c = mapContacts.get(opp.Contact__c).Spring_Students__c + (opp.Base_Year__c == baseyear  ? opp.Spring_Students__c : 0);
                    }
                }
                
                /*ELSE IF(Opp.Opportunity_Record_Type_Name__c == 'Tutor Opp'){
                    IF(Opp.IsWon == TRUE){
                        //Won Tutor Opp
                    }
                    ELSE IF(Opp.IsClosed == FALSE){
                        //Open Tutor Opp
                    }
                }*/
            }
            
            //Create list of accounts, then add map to that list
            List<Contact> ListContacts = MapContacts.values();
            IF(SetContactID.size()>0){
                update ListContacts;
            }
        }
        
        ///////////////////////////////////////////////////////Accounts
        if(setAccountID.size()>0){
            Map<Id,Account> mapAccounts = new Map<Id,Account> (
            [SELECT Id, Books_Adopted__c
            FROM Account WHERE Id IN :setAccountID FOR UPDATE]);
            
            //Set account fields to default
            for(Id accountId : mapAccounts.keySet() ){
                mapAccounts.get(accountId).Books_Adopted__c	= '' ;
            }
            //System.debug('mapAccounts: '+mapAccounts);
            
            List<Opportunity> allOpps = [SELECT Id, Book_Text__c, AccountId
            FROM Opportunity
            WHERE AccountId IN :setAccountID AND IsWon = TRUE
            LIMIT 10000];
            //System.debug('allOpps: '+ allOpps);
            
            for(Opportunity opp: allOpps){
                if(mapAccounts.containsKey(opp.AccountId)){
                    mapAccounts.get(opp.AccountId).Books_Adopted__c = mapAccounts.get(opp.AccountId).Books_Adopted__c+(mapAccounts.get(opp.AccountId).Books_Adopted__c.contains(opp.Book_Text__c)?'': (mapAccounts.get(opp.AccountId).Books_Adopted__c == '' ? '': ', ') + opp.Book_Text__c);
                    String booksAdopted = mapAccounts.get(opp.AccountId).Books_Adopted__c;
                    if(booksAdopted.length() > 255 ){
                        mapAccounts.get(opp.AccountId).Books_Adopted__c = booksAdopted.substring(0, 255);
                    }
                }
            }
            
            //List<Account> listAccounts = mapAccounts.values();
            if(mapAccounts.values().size() > 0){
                update mapAccounts.values();
            }
        }
        /////////////////////////////////////////////Department things
        if(depts.size() > 0){
            List<String> deptKeys = new List<String>();
            Map<String,Opportunity> deptMap = new Map<String,Opportunity>();
            
            for(Opportunity dept: depts){
                deptKeys.add(dept.DeptSort__c);
                dept.Fall_Students__c = (dept.Fall_Dept_Max_Students__c   != null? dept.Fall_Dept_Max_Students__c  : 0);
                dept.Fall_Dept_Max_Students__c = (dept.Fall_Dept_Max_Students__c   != null? dept.Fall_Dept_Max_Students__c  : 0);
                dept.Spring_Students__c = (dept.Spring_Dept_Max_Students__c != null? dept.Spring_Dept_Max_Students__c: 0);
                dept.Spring_Dept_Max_Students__c = (dept.Spring_Dept_Max_Students__c   != null? dept.Spring_Dept_Max_Students__c  : 0);
                dept.Summer_Students__c = (dept.Summer_Dept_Max_Students__c != null? dept.Summer_Dept_Max_Students__c: 0);
                deptMap.put(dept.DeptSort__c,dept);
            }
            //System.debug('deptMap: '+deptMap);
            
            List<Opportunity> subOpps = [SELECT Id, sort__c, Fall_Students__c, Spring_Students__c, Summer_Students__c,
                Opportunity_Record_Type_Name__c, DeptSort__c
            FROM Opportunity
            WHERE DeptSort__c IN :deptKeys AND IsWon = TRUE AND Department_Adoption__c = FALSE
            LIMIT 10000];
            //System.debug('SubOpps: '+subOpps);
            
            if(subOpps.size() > 0){
                for(Opportunity opp: subOpps){
                    if(opp.Opportunity_Record_Type_Name__c == 'Book Opp'){
                        //System.debug('Opp loop: '+opp);
                        //System.debug('opp.DeptSort__c.Fall_Dept_Max_Students__c: '+ deptMap.get(opp.DeptSort__c).Fall_Dept_Max_Students__c);
                        deptMap.get(opp.DeptSort__c).Fall_Students__c = Math.max(deptMap.get(opp.DeptSort__c).Fall_Dept_Max_Students__c - (opp.Fall_Students__c   != null ? opp.Fall_Students__c  :0), 0);
                        deptMap.get(opp.DeptSort__c).Spring_Students__c = Math.max(deptMap.get(opp.DeptSort__c).Spring_Dept_Max_Students__c - (opp.Spring_Students__c != null ? opp.Spring_Students__c:0), 0);
                        //DeptMap.get(Opp.DeptSort__c).Summer_Students__c = math.max(DeptMap.get(Opp.DeptSort__c).Summer_Dept_Max_Students__c - (Opp.Summer_Students__c != null ? Opp.Summer_Students__c:0), 0);
                    }
                }
            }
            List<Opportunity> listOpps = deptMap.values();
            //System.debug('ListOpps: '+listOpps);
            update listOpps;
            //update deptMap.values();
        }
        
        if(normalOppsUpdate.size()>0){
            update normalOppsUpdate;
        }
        if(deptsNeedRollup.size()>0){
            update deptsNeedRollup;
        }
        
        //System.debug('End OppRollup');
    }
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    
    }
    
    public static Boolean duplicateDeptOpportunity(Opportunity oppToLookFor, List<Opportunity> deptsToUpdate){
        Boolean dupFound = false;
        for(Opportunity opp: deptsToUpdate){
            if(opp.Id == oppToLookFor.Department_Opportunity__c){
                //System.debug('Duplicate found: ' + opp.Id);
                dupFound = true;
                break;
            }
        }
        return dupFound;
    }
}