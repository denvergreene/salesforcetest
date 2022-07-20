global class FileUploader implements Database.Batchable<sObject> //,Schedulable 
{
    //this top section is if we want it to be schedulable, but I don't think we do, but I don't want to delete it 
    /*global static void execute(SchedulableContext SC){
        List<BMG__c> BMGs = [SELECT Book_Name__c, IPED__c, Period__c, Enrollments__c, First_Name__c, Last_Name__c, Email__c, Year__c
                             FROM BMG__c
                             WHERE Needs_Manual_Entry__c = FALSE
                             ORDER BY Year__c
                             LIMIT 350//:batchSize
                            ];
        ReadBMG(BMGs);
}*/
    
    //Creates a query for gathering records
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'SELECT Book_Name__c, IPED__c, Period__c, Enrollments__c, First_Name__c, '
            + 'Last_Name__c, Email__c, Year__c '
            + 'FROM BMG__c '
            + 'WHERE Needs_Manual_Entry__c = FALSE '
            + 'ORDER BY Year__c'
        );
    }
    
    //runs the records from above through some code listed below
    public void execute(Database.BatchableContext bc, List<BMG__c> BMGs){
      //  ReadBMG(BMGs);
    }
    
    @invocableMethod
    public static void ReadBMG(List<BMG__c> BMGs){
    /*    system.debug('Start Method');
        
        //Get and make variables/maps
        //other
        Integer batchSize = Integer.valueOf([SELECT BatchSize__c FROM Batch_Size__mdt WHERE Label = 'BMGBatch' LIMIT 1].BatchSize__c);
        Set<String> SetAccountIPEDs = new Set<String>();
        Set<String> SetEmails		= new Set<String>();
        Set<ID> SetContactIDs		= new Set<ID>();
        Set<String> SetContactName	= new Set<String>();
        
        //BMGs
        List<BMG__c> bmgUpdate = new List<BMG__c>();
        List<BMG__c> bmgDelete = new List<BMG__c>();
        for(BMG__c BMG : BMGs){
            SetAccountIPEDs.add(BMG.IPED__c);
            SetEmails.add('%'+BMG.Email__c+'%');
            SetContactName.add(BMG.First_Name__c+' '+BMG.Last_Name__c);
        }
        
        //Account
        Map<string,Account> schoolMap = new Map<string, Account>();
        Account[] schoolsList = [SELECT ID, IPEDS_ID__c
                 				FROM Account 
                                WHERE IPEDS_ID__c IN :SetAccountIPEDs];
        for(Account a : schoolsList){
            schoolMap.put(a.IPEDS_ID__c,a);
        }
        
        //Contact
        Map<String,Contact> contactEmailMap = new Map<String,Contact>(); //dup check based on email
        Map<String,Contact> contactNameMap	= new Map<String,Contact>(); //dup check based on school name and person name match
        Map<String,Contact> contactsNewMap	= new Map<String,Contact>(); //new contacts to be created
        Map<String,Contact> ContactUpdateMap= new Map<String,Contact>(); //contacts need to be updated
        Map<String,Contact> oppContactMap	= new Map<String,Contact>();
        Contact[] contactList = [SELECT ID, AccountId, All_Emails__c, Email, Name, Subject__c
                 				FROM Contact
                                WHERE All_Emails__c LIKE :SetEmails OR (AccountId IN :schoolsList AND Name IN :SetContactName)];
        for(Contact c : contactList){
            List<String> AllEmails = c.All_Emails__c.split(',');
            for(String email : AllEmails){
                contactEmailMap.put(email.trim(),c);
            }
            IF(!contactEmailMap.containsKey(c.Email)){
                contactEmailMap.put(c.Email,c);
            }
            contactNameMap.put(c.AccountId+c.Name,c);
            SetContactIDs.add(c.id);
        }
        
        //Opportunity
        Map<String,Opportunity> OppMapSort	= new Map<String,Opportunity>(); // for checking exact duplicates
        Map<String,Opportunity> OppMapBSC	= new Map<String,Opportunity>(); // BSC = BookSchoolContact, for checking earlier opps
        Map<String,Opportunity> OppMapDup	= new Map<String,Opportunity>(); //for checking duplicates
        List<Opportunity> OppUpsert 		= new List<Opportunity>(); // for upserting
        String OppRecordTypeID 				= Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Book Opp').getRecordTypeId();
        Opportunity[] OppList = [SELECT ID, Book__c, AccountId, Contact__c, Base_Year__c, Students__c, IsClosed, StageName
                                 FROM Opportunity
                                 WHERE Contact__c IN :SetContactIDs
                                ];
        for(Opportunity o : OppList){ 
            //had to convert to id before string so that it gets the long id insetad of the short one.
            ID Book = o.Book__c;
            ID School = o.AccountId;
            ID Contact = o.Contact__c;
            String BSC = Book+string.valueOf(School) +string.valueOf(Contact);
            OppMapBSC.put(BSC,o);
            
            String oppSort = BSC;
            oppSort += 'FALS';
            oppSort += o.Base_Year__c;
            OppMapSort.put(oppSort, o);
        }
        
        //Books 
        Map<String,Book__c> bookNameMap = new Map<String,Book__c>();
        Book__c[] BookList = [SELECT ID, Name FROM Book__c];
        for(Book__c b: BookList){
            bookNameMap.put(b.Name,b);
        }

        //////loop through rows to check contacts
        try{
            for (BMG__c BMG : BMGs){
                system.debug('New Row.........................................................................................');
                system.debug('BMG: '+BMG);
                
                String Book			= BMG.Book_Name__c;
                String IPED 		= BMG.IPED__c;
                String Period 		= BMG.Period__c;
                integer students 	= Integer.ValueOf(BMG.Enrollments__c);
                String FirstName 	= BMG.First_Name__c;
                String LastName 	= BMG.Last_Name__c;
                String Email 		= BMG.Email__c;
                
                IF(!schoolMap.containsKey(IPED)){
                    //No School
                    BMG.Needs_Manual_Entry__c = TRUE;
                    bmgUpdate.add(BMG);
                    //system.debug('No School, leave for later');
                }
                ELSE IF(ContactUpdateMap.containsKey(Email)){
                    //contact already being updated
                    //system.debug('contact already being updated');
                    List<String> subjects = ContactUpdateMap.get(Email).Subject__c.split(';');
                    IF(!subjects.contains(Book)){
                        ContactUpdateMap.get(Email).Subject__c += '; '+ Book;
                    }
                }
                ELSE IF(contactEmailMap.containsKey(Email) || contactNameMap.containsKey(schoolMap.get(IPED).ID+FirstName+' '+LastName)){
                    //Contact Found, update LIT date
                    //system.debug('Contact Found, update LIT date');
                    Contact con = new Contact();
                    IF(contactEmailMap.containsKey(Email)){ //email match
                        con = contactEmailMap.get(Email);
                        //system.debug('email match');
                    }
                    ELSE IF(contactNameMap.containsKey(schoolMap.get(IPED).ID+FirstName+' '+LastName)){ //name match
                        con = contactNameMap.get(schoolMap.get(IPED).ID+FirstName+' '+LastName);
                        //system.debug('name match');
                    }
                    IF(con != null && !ContactUpdateMap.containsKey(Email)){ //update and add to updateMap
                        system.debug('update contact');
                        con.Last_In_Touch_Date__c = date.newInstance(System.Today().year(), 06, 01);
                        //system.debug('con '+con);
                        IF(con.Subject__c != null){
                            
                            List<String> subjects = con.Subject__c.split(';');
                            IF(!subjects.contains(Book)){
                                con.Subject__c += '; '+ Book;
                            }
                        }
                        ELSE{
                            con.Subject__c = Book;
                        }
                        ContactUpdateMap.put(Email,con);
                        oppContactMap.put(Email,con);
                    }
                }
                ELSE{
                    //No Contact
                    IF(schoolMap.containsKey(IPED)){
                        //School Found
                        IF(contactsNewMap.containsKey(Email)){
                            //Contact already inserted, add subject
                            //system.debug('Contact already inserted, add subject');
                            List<String> subjects = contactsNewMap.get(Email).Subject__c.split(';');
                            IF(!subjects.contains(Book)){
                                contactsNewMap.get(Email).Subject__c += '; '+ Book ;
                            }
                        }
                        ELSE{
                            //New contact will be inserted
                            //system.debug('New contact will be inserted');
                            Contact newContact 		= new Contact();
                            newContact.AccountId 	= schoolMap.get(IPED).id;
                            newContact.FirstName 	= FirstName;
                            newContact.LastName  	= LastName;
                            newContact.Phone		= '0000000000';
                            newContact.Email		= Email;
                            newContact.Subject__c	= Book;
                            newContact.Last_In_Touch_Date__c = date.today();
                            contactsNewMap.put(Email,newContact);
                            oppContactMap.put(Email,newContact);
                        }
                    }
                }
            }
        }
        catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
            //system.debug('error: '+errormsg);
        }
        
        //////////Insert/update Contacts
        try{
            List<Contact> ContactInsert = new List<Contact>(contactsNewMap.values());
            insert ContactInsert;
            for(Contact c : ContactInsert){
                contactEmailMap.put(c.Email,c);
            }
            
            List<Contact> ContactUpdate = new List<Contact>(ContactUpdateMap.values());
            update ContactUpdate;
            for(Contact c: ContactUpdate){
                contactEmailMap.put(c.Email,c);
            }
        }
        catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting/updating contacts'+e.getMessage());
            //system.debug('error: '+errormsg);
        }
        
        
        
        //////loop through rows to check opportunities
        system.debug('...............................................................................................................................................Start Opps');
        try{
            for (BMG__c BMG : BMGs){
                system.debug('New Row.........................................................................................');
                
                String Book			= BMG.Book_Name__c;
                String IPED 		= BMG.IPED__c;
                String Period 		= BMG.Period__c;
                integer students 	= Integer.ValueOf(BMG.Enrollments__c);
                String FirstName 	= BMG.First_Name__c;
                String LastName 	= BMG.Last_Name__c;
                String Email 		= BMG.Email__c;
                
                system.debug('BMG: '+BMG);
                
                IF(oppContactMap.containsKey(Email)){
                    //Get Date related fields
                    String Term 		= Period.left(Period.length()-5);
                    Integer month		= (Term == 'Spring' ? 01 : Term == 'Fall' ? 08 :06);
                    Integer Year		= Integer.ValueOf(Period.right(4));
                    Integer BaseYear	= Year - (Term == 'Spring' ? 1 : 0);
                    
                    // this is how to get the sort field on the opp (for duplicate checking)
                    String oppBSC = bookNameMap.get(Book).Id;
                    oppBSC += schoolMap.get(IPED).ID;
                    oppBSC += oppContactMap.get(Email).ID;
                    String oppSort = oppBSC;
                    oppSort += 'FALS';
                    oppSort += BaseYear;
                    
                    //Search for Opps
                    //system.debug('search for opps');
                    IF(OppMapSort.containsKey(oppSort)){
                        //OppFound
                        //system.debug('opp found');
                        IF(OppMapBSC.containsKey(oppBSC) && !OppMapBSC.get(oppBSC).IsClosed){
                            Opportunity oppUpdate 		= OppMapBSC.get(oppBSC);
                            oppUpdate.StageName 		= 'Confirmed Adoption Won';
                            oppUpdate.Renewal_Status__c = 'Needs Renewal';
                            oppUpdate.Need_Rollup__c	= TRUE;
                            oppUpdate.Students__c		= students; 
                            OppUpsert.add(oppUpdate);
                        }
                        ELSE {system.debug('Opp already closed');}
                        bmgDelete.add(BMG);
                    }
                    ELSE IF(OppMapDup.containsKey(oppSort)){
                        //system.debug('Already updated, do nothing');
                        bmgDelete.add(BMG);
                    }
                    ELSE{
                        //Opp Not Found
                        //system.debug('opp not found');
                        Opportunity newOpp 			= new Opportunity();
                        newOpp.AccountId			= schoolMap.get(IPED).Id;
                        newOpp.Book__c				= bookNameMap.get(Book).Id;
                        newOpp.Class_Start_Date__c	= date.newInstance(year, month , 10); 
                        newOpp.CloseDate			= date.today();
                        newOpp.Closer__c			= UserInfo.getUserId();
                        newOpp.Contact__c			= oppContactMap.get(Email).Id;
                        newOpp.Description			= date.today()+', '+UserInfo.getName()+', BMG Import 2021' ; //make sure the date doesn't have time, which seems to be the default
                        newOpp.First__c				= TRUE;
                        newOpp.LeadSource			= 'BMG Import';
                        newOpp.Name					= 'temp';
                        newOpp.Need_Rollup__c		= TRUE;
                        newOpp.RecordTypeId			= OppRecordTypeId;
                        newOpp.StageName			= 'Confirmed Adoption Won';
                        newOpp.Student_No_Status__c	= 'Reported';
                        newOpp.Renewal_Status__c 	= 'Needs Renewal';
                        newOpp.Students__c			= students;
                        newOpp.Time_Period__c		= 'Year';
                        //newOpp.Skip_Flow__c			= TRUE;
                        newOpp.Type					= (OppMapBSC.containsKey(oppBSC) ? 'Renewal' : 'New Business');
                        OppUpsert.add(newOpp);
                        bmgDelete.add(BMG);
                        
                        //system.debug('newOpp: '+newOpp);
                        //add to OppMapDup, in case their csv has duplicates
                        OppMapDup.put(oppSort, newOpp);
                        OppMapBSC.put(oppBSC, newOpp);
                    }
                }
                ELSE{System.debug('No account, so no opp');}
            }
        }
        catch (Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured processing opportunities '+e.getMessage());
            //system.debug('error: '+errormsg);
        }
        
        try{
            //Upserting opportunities
            upsert OppUpsert;
            update bmgUpdate;
            delete bmgDelete;
        }
        catch (Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured upserting opportunities '+e.getMessage());
            //system.debug('error: '+errormsg);
        }
    
        
        system.debug('end method');
        //return null;
      */
    }
        
    
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}