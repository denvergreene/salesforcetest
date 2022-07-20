public class LeadConversion { 
    
    public class ConvertInput {
        @InvocableVariable
        public string LeadInput; //(required=true)
    }
    static string leadID;
    
    @InvocableMethod(label='Lead Conversion')
    public static void LeadConversion(List<ConvertInput> inputsMultiple) {
        system.debug('Leads passed in through invoke');
        Set<String> LeadIDs	= new Set<String>();
        for (ConvertInput input : inputsMultiple) {
            LeadIDs.add(input.LeadInput);
        }
        
        List<Lead> LeadList = [SELECT Id, 
                               Name, 
                               Accounts_UUID__c,
                               Role__c, 
                               School__c, 
                               FV_Status__c, 
                               AdoptionsJSON__c,
                               Instant_Conversion__c,
                               Application_Source__c,
                               Company, 
                               Partner_selected_on_marketplace_form__c,
                               Title 
                               FROM Lead 
                               WHERE ID IN :leadIDs AND IsConverted = False ];
        
        //system.debug('LeadList: '+LeadList);
        actualexecute(LeadList, LeadIDs);
    }
    
    public static void actualexecute(List<Lead> Leads, Set<String> LeadIDs){
        system.debug('execute changes - lead conversion');

        //Contact list for updating witah custom values
        List<Contact> ContactList = new List<Contact>();
        
        //get proper date format for description string
        String properDateFormat = String.Valueof(date.today().year()) + '-' + String.Valueof(date.today().month()) + '-' + String.Valueof(date.today().day()) + ', ';
        
        //Get The default school ID for if there is no account found on lead
        List<Account> TheLostSchool = [SELECT ID FROM Account WHERE Name = 'Find Me A Home'];
        String FindMeAHome; 
        IF(TheLostSchool.size() > 0){
            FindMeAHome = TheLostSchool[0].ID;
        }
        ELSE{
            Account NewAccount = new Account();
            NewAccount.Name = 'Find Me A Home';
            NewAccount.Type = 'Other';
            NewAccount.BillingCountry = 'United States';
            NewAccount.Exclude__c = TRUE;
            insert NewAccount;
            FindMeAHome = NewAccount.ID;
        }
        
        List<Partner_Product__c> PPsUpdate = new List<Partner_Product__c>();
        
        for(Lead l : Leads){
            //Set values in the leadConvert method
            String Company;
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.Id);
            lc.setConvertedStatus('Converted');
            lc.setDoNotCreateOpportunity(TRUE); 
            
            IF(l.School__c != null){     //sets account ID so a duplicate isn't created
                lc.accountid = l.School__c;
            }
            ELSE { 
                system.debug('use the  find me a home id: '+FindMeAHome);
                lc.accountid = FindMeAHome;
                Company = l.Company;
            }
            
            //Convert the lead using standard  values
            system.debug('before convert');

            Database.LeadConvertResult lcr = Database.convertLead(lc, true);
            
            Contact c = [SELECT ID, AccountID FROM Contact WHERE ID = :lcr.getContactId()];
            system.debug('contact school: '+c.AccountId);
            Account a = [SELECT ID, ShippingAddress, Continent__c FROM Account WHERE ID = :c.AccountId];
            system.debug('account: '+a);

            system.debug('after convert');
            
            if (lcr.isSuccess()) {
                //Custom fields for lead conversion
                string reason = getReason(l);
                Contact con 				= new Contact();
                con.Id						= lcr.getContactId();
                con.Title					= l.Title;
                con.Description				= properDateFormat + UserInfo.getName() + ' - ' + reason + ' - ' + Company;
                IF(l.FV_Status__c == 'confirmed_faculty'){
                    con.Faculty_Confirmed_Date__c = date.today();
                    con.Last_In_Touch_Date__c	= date.today();
                }
                
                ContactList.add(con);
                
                //Check for partner products related to the lead updated
                
                IF(l.Partner_selected_on_marketplace_form__c != null){
                    List<Partner_Product__c> PPs = [SELECT ID, Lead__c, Contact__c
                                                    FROM Partner_Product__c
                                                    WHERE Lead__c IN :LeadIDs];
                   
                    for(Partner_Product__c PP: PPs){
                        IF(PP.Lead__c == l.ID){
                            PP.Contact__c = con.id;
                            PPsUpdate.add(PP);
                        }
                    }
                }
            }
        }

        //contact update
        system.debug('Converted Contacts: '+ContactList);
        try {
            IF(ContactList.size() >0 ){
                update ContactList;
                
                IF(PPsUpdate.size() >0){
                    update PPsUpdate;
                }
            }
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
    }
    
    public static String getReason(Lead l){
        String reason = 'Converted for the following reason(s): ';
        IF(l.FV_Status__c == 'confirmed_faculty'){
            reason += 'Faculty Confirmed, ';
        }
        IF(l.AdoptionsJSON__c != null){
            reason += 'Adoption Confirmed, ';
        }
        IF(l.Accounts_UUID__c != null && l.Role__c == 'Instructor' && l.Application_Source__c == 'Accounts' && l.FV_Status__c != 'Rejected'){
            reason += 'Account Created';
        }
        IF(l.Instant_Conversion__c == TRUE){
            reason += 'Instant Conversion Checkbox';
        }
        return reason;
    }

}