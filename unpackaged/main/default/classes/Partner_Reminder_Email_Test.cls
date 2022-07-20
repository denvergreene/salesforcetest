@isTest
public class Partner_Reminder_Email_Test {
	public static TestMethod void testthethings(){
    	/*system.debug('Start Partner email Test');
    
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Partner').getRecordTypeId();
        
        //Create Partners
        List<Account> newPartners = new List<Account>();
        Account a1 	= new Account();
        a1.Name 	= 'School Partner test 11111';
        a1.recordTypeId = recordTypeId;
        a1.Type		= 'Adaptive Courseware Partners ';
        a1.Phone	= '0000000000';
        a1.Website	= 'website.com';
        a1.Lead_Email_Frequency__c = 'Once a Day';
        a1.Email_for_Leads__c = 'denver+test1@rice.edu, denver+test4@rice.edu';
        newPartners.add(a1);
        
        Account a2 	= new Account();
        a2.Name 	= 'School Partner test 22222';
        a2.recordTypeId = recordTypeId;
        a2.Type		= 'Adaptive Courseware ';
        a2.Phone	= '0000000000';
        a2.Website	= 'website.com';
        a2.Lead_Email_Frequency__c = 'Once a Week';
        a2.Email_for_Leads__c = 'denver+test2@rice.edu';
        newPartners.add(a2);
        
        Account a3 	= new Account();
        a3.Name 	= 'School Partner test 33333';
        a3.recordTypeId = recordTypeId;
        a3.Type		= 'Adaptive Courseware ';
        a3.Phone	= '0000000000';
        a3.Website	= 'website.com';
        a3.Lead_Email_Frequency__c = 'Once a Month';
        a3.Email_for_Leads__c = 'denver+test3@rice.edu';
        newPartners.add(a3);
        insert newPartners;
        
        
        //Create Contact
        Contact c1 		= new Contact();
        c1.FirstName	= 'Denver';
        c1.LastName		= 'Greene1';
        c1.AccountId 	= a1.Id;
        c1.Phone		= '0000000000';
        c1.Email		= 'denver+test1@rice.edu';
        c1.Subject__c	= 'Biology';
        insert c1;
        
        Contact c4 		= new Contact();
        c4.FirstName	= 'Denver';
        c4.LastName		= 'Greene4';
        c4.AccountId 	= a1.Id;
        c4.Phone		= '0000000000';
        c4.Email		= 'denver+test4@rice.edu';
        c4.Subject__c	= 'Biology';
        insert c4;
        
        Contact c2 		= new Contact();
        c2.FirstName	= 'Denver';
        c2.LastName		= 'Greene2';
        c2.AccountId 	= a2.Id;
        c2.Phone		= '0000000000';
        c2.Email		= 'denver+test2@rice.edu';
        c2.Subject__c	= 'Biology';
        insert c2;
        
        Contact c3 		= new Contact();
        c3.FirstName	= 'Denver';
        c3.LastName		= 'Greene3';
        c3.AccountId 	= a3.Id;
        c3.Phone		= '0000000000';
        c3.Email		= 'denver+test3@rice.edu';
        c3.Subject__c	= 'Biology';
        insert c3;
        
        //Create Partner Product
        List<Partner_Product__c> PPs = new List<Partner_Product__c>();
        Partner_Product__c PP1 = new Partner_Product__c();
        PP1.Partner__c = a1.id;
        PP1.Contact__c = c1.id;
        PP1.Permission_To_Share__c = TRUE;
        PP1.Stage__c = 'Expressed Interest';
        PPs.add(pp1);
        
        Partner_Product__c PP2 = new Partner_Product__c();
        PP2.Partner__c = a2.id;
        PP2.Contact__c = c2.id;
        PP2.Permission_To_Share__c = TRUE;
        PP2.Stage__c = 'Expressed Interest';
        PPs.add(pp2);
        
        Partner_Product__c PP3 = new Partner_Product__c();
        PP3.Partner__c = a3.id;
        PP3.Contact__c = c3.id;
        PP3.Permission_To_Share__c = TRUE;
        PP3.Stage__c = 'Expressed Interest';
        PPs.add(pp3);
        
        insert PPs;
        
        Date ThisDate 	 = Date.newInstance(2019, 10, 1);
        Date OneMonthAgo = ThisDate.addMonths(-1);
        Date OneWeekAgo	 = ThisDate-7;
        Date Yesterday   = ThisDate-1;
        
        Test.setCreatedDate(PP1.Id, yesterday); 
        Test.setCreatedDate(PP2.Id, OneWeekAgo); 
        Test.setCreatedDate(PP3.Id, OneMonthAgo); 
        
        list<Date> inputDateList = new List<date>{ThisDate};
        Partner_Reminder_Email.PartnerEmail(inputDateList);
        Integer invocations = Limits.getEmailInvocations();
        system.debug('Number of emails sent: '+invocations);
        system.assert(invocations == 4);
        
        Test.setCreatedDate(PP1.Id, yesterday+1); 
        
        list<Date> inputDateList2 = new List<date>{ThisDate+1};
        Partner_Reminder_Email.PartnerEmail(inputDateList2);
        invocations = Limits.getEmailInvocations();
        system.debug('Number of emails sent: '+invocations);
        system.assert(invocations == 6);
*/
    }
}