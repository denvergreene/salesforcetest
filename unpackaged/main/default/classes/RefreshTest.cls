@isTest
global class RefreshTest {
    
    @isTest
	static void testMySandboxPrep (){
        
        //SandboxContext context;
        
        //Refresh(); //ApexClass
        
        //Test.startTest();
        
        Test.testSandboxPostCopyScript(
            new Refresh(), UserInfo.getOrganizationId(),
            UserInfo.getOrganizationId(), UserInfo.getUserName().substringAfterLast('.'));
        
        //Test.stopTest();

        
        List<User> UList = [SELECT ID, Email
                  FROM User
                  WHERE profile.name = 'System Administrator' and IsActive = TRUE];
        
        system.debug('Fin');
    }
}