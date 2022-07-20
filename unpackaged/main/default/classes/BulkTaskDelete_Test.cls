@isTest
public class BulkTaskDelete_Test {
    public static TestMethod void BulkTaskDeletetest(){
        
        Account a 		= new account();
        a.Name			= 'thisisatestuniveristy';
        a.Type			= 'College/University (4)';
        insert a;
        
        id ownerID = [SELECT ID
                      FROM User
                      WHERE Name = 'Denver Greene'].Id;
        
        Task t				= new Task();
        t.OwnerId   		= ownerID;
        insert t;
        
        test.startTest();
        BulkTaskDelete BTD = new BulkTaskDelete(ownerID);
        Database.executeBatch(BTD);
        test.stopTest();
        
    }
}