global class Partner_Reminder_Email {
    /*implements Schedulable
	global static void execute(SchedulableContext SC){
        list<Date> ThisDate = new list<Date>{Date.Today()};
        PartnerEmail(ThisDate);
    }
    
    @InvocableMethod
    global static void PartnerEmail(list<Date> colDate){
        system.debug('Start PartnerEmail');
        
        /////////Set generic date fields
        Date ThisDate = colDate[0];
        Datetime DT = (Datetime) ThisDate;
        Date OneMonthAgo = ThisDate.addMonths(-1);
        Date OneWeekAgo	 = ThisDate-7;
        Date Yesterday   = ThisDate-1;
        
        system.debug('ThisDate: '+ThisDate);
        
        //grab recordtypeID for partner
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Partner').getRecordTypeId();
        
        
        /////// create list of frequency types, for searching against
        List<String> Ftypes	= new List<String>();
        Ftypes.add('Once a Day');
        Date SearchDate = Yesterday;

        IF(DT.format('E') == 'Mon' ){
            Ftypes.add('Once a Week');
            SearchDate = OneWeekAgo;
        }
        
        IF(ThisDate.Day() == 1 ){
            Ftypes.add('Once a Month');
            SearchDate = OneMonthAgo;
        }
        
        //////////// get list of contacts relevant for today
        Map<string,ID> conMap = new Map<string,ID>();
        List<Contact> PContacts = [SELECT ID, Account.Id, email
                                  FROM Contact
                                  WHERE Contact.Account.RecordType.DeveloperName = 'Partner'];
        system.debug('PContacts '+PContacts);
        for(Contact c : PContacts){
            system.debug('ConMap email: '+c.Email);
            system.debug('ConMap contact: '+c.ID);
            
            conMap.put(c.Email,c.ID);
        }
        
        /////////// get list of partners
        List<Account> partners = [SELECT ID, Account.Lead_Email_Frequency__c , Account.Email_for_Leads__c
                                 FROM Account
                                 WHERE recordTypeID = :recordTypeId AND Lead_Email_Frequency__c IN :Ftypes];
        
        system.debug('partners: '+partners);
        
         
        
        
        
        
        
        
        ////////////Get Partner Products and Maps
        List<Partner_Product__c> PPs = [SELECT Id, CreatedDate, Partner__c 
                                        FROM Partner_Product__c
                                        WHERE CreatedDate >= :SearchDate];
        
        Map<Id,Partner_Product__c> MonthMap = new Map<Id,Partner_Product__c>();
        Map<Id,Partner_Product__c> WeekMap = new Map<Id,Partner_Product__c>();
        Map<Id,Partner_Product__c> DayMap = new Map<Id,Partner_Product__c>();
        
        system.debug('PPs: '+PPs);
        for(Partner_Product__c PP: PPs){
            IF(PP.CreatedDate >= Yesterday){
                DayMap.put(PP.Partner__c,PP);
            }
            IF(PP.CreatedDate >= OneMonthAgo){
                MonthMap.put(PP.Partner__c,PP);
            }
            IF(PP.CreatedDate >= OneWeekAgo){
                WeekMap.put(PP.Partner__c,PP);
            }
            
        }
        
        system.debug('DayMap: '+DayMap);
        system.debug('WeekMap: '+WeekMap);
        system.debug('MonthMap: '+MonthMap);
        
        
        
        
        //////// create send to list
        //List<Account> sendToList = new List<Account>();
        //List<Contact> sendToList = new List<Contact>();

        
     /*   for(Contact c : PContacts){
            system.debug('Contact '+c);
            IF(c.Account.Lead_Email_Frequency__c == 'Once a Day' && DayMap.containsKey(c.AccountID) ){
                sendToList.add(c);
                system.debug('Day');
            }
            ELSE IF(c.Account.Lead_Email_Frequency__c == 'Once a Week' && WeekMap.containsKey(c.AccountID) ){
                sendToList.add(c);
                system.debug('Week');
            }
            ELSE IF(c.Account.Lead_Email_Frequency__c == 'Once a Month' && MonthMap.containsKey(c.AccountID) ){
                sendToList.add(c);
                system.debug('Month');
            }
        }
      */ /*
        
        List<String> sendToList = new List<String>();
        Map<string,ID> sendToMap = new Map<string,ID>();
        
        for(Account a : partners){
            IF(a.Lead_Email_Frequency__c == 'Once a Day' && DayMap.containsKey(a.Id)) {
                String[] emails = a.Email_for_Leads__c.split(',');
                for(string e: emails){
                    sendToList.add(e);
                    sendToMap.put(e,a.Id);
                }
            }
            IF(a.Lead_Email_Frequency__c == 'Once a Week' && WeekMap.containsKey(a.Id)) {
                String[] emails = a.Email_for_Leads__c.split(',');
                for(string e: emails){
                    sendToList.add(e);
                    sendToMap.put(e,a.Id);
                }
            }
            IF(a.Lead_Email_Frequency__c == 'Once a Month' && MonthMap.containsKey(a.Id)) {
                String[] emails = a.Email_for_Leads__c.split(',');
                for(string e: emails){
                    sendToList.add(e);
                    sendToMap.put(e,a.Id);
                }
            }
        }
        
        system.debug('sendToList: '+sendToList);
        system.debug('sendToMap '+sendToMap);
        
        /////////////Send an email
        /*
        Contact c	= [SELECT Id
                          FROM Contact
                          Where Email = 'denver@rice.edu'];
        */  /*

        EmailTemplate et = [SELECT Id, Name 
                            FROM EmailTemplate 
                            WHERE DeveloperName like '%Partner_Lead_Reminder%'];
        
        OrgWideEmailAddress owa = [SELECT Id,DisplayName FROM OrgWideEmailAddress WHERE DisplayName='OpenStax Support' LIMIT 1];
        
        for(String e: sendToList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {e};
                system.debug('toAddresses: '+toAddresses);
                mail.setToAddresses(toAddresses);
            	mail.setTemplateId(et.Id);
                system.debug('conMap: '+conMap.get(e.trim()));
        		mail.setTargetObjectId(conMap.get(e.trim()));
            	mail.setOrgWideEmailAddressId(owa.id);
            	mail.setUseSignature(false);
	            //mail.setwhatid(c.Id); errors when I include it
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
    }*/
}