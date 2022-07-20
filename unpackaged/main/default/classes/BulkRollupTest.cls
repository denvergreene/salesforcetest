@isTest
public class BulkRollupTest {
    public static TestMethod void rollovertest(){
        system.assert(true);
        
        Account a 		= new account();
        a.Name			= 'thisisatestuniveristy';
        a.Type			= 'College/University (4)';
        insert a;
        
        Contact c 		= new contact();
        c.FirstName		= 'Denver';
        c.LastName		= 'Test';
        c.AccountId 	= a.id;
        c.Email			= 'denver+test@rice.edu';
        c.Phone			= '0000000000';
        insert c;
        
        Book__c bookPsyc 	= new Book__c();
        bookPsyc.Name						= 'Psychology';
        bookPsyc.Active__c					= true;
        bookPsyc.Annualization_number__c 	= 1.6;
        bookPsyc.Publish_Date__c			= date.newInstance(2015, 03, 04);
        insert bookPsyc;
        
        Opportunity oppPrevious 		= new Opportunity();
        oppPrevious.Name				= 'temp name';
        oppPrevious.StageName			= 'Confirmed Adoption Won';
        oppPrevious.Contact__c			= c.id;
        oppPrevious.AccountId			= a.id;
        oppPrevious.Book__c				= bookPsyc.id;
        oppPrevious.Description			= 'temp';
        oppPrevious.Class_Start_Date__c = date.newInstance(2019, 08, 10);
        oppPrevious.Students__c			= 30;
        oppPrevious.Time_Period__c		= 'Year';
        oppPrevious.CloseDate			= date.today();
        oppPrevious.Renewal_Status__c	= 'Needs Renewal';
        oppPrevious.Need_Rollup__c		= TRUE;
        insert oppPrevious;
                
        
        test.startTest();
        BulkRollup BR = new BulkRollup();
        Database.executeBatch(BR,5);
        test.stopTest();
       
    }
}