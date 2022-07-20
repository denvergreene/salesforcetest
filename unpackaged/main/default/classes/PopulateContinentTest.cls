@IsTest
Public class PopulateContinentTest {
    public static TestMethod void testthecontinents(){

   		//Build CountryContinent custom setting field
        CountryContinent__c cc = new CountryContinent__c ();
        cc.Name = 'Nigeria' ; 
        cc.Continent__c = 'Africa';
        insert cc;
        
        CountryContinent__c ccc = new CountryContinent__c ();
        ccc.Name = 'United States' ; 
        ccc.Continent__c = 'North America';
        insert ccc;
        
        //Create Org   
        Account a1 = new Account();
        a1.Name = 'New School';
        a1.Type ='College/University (4)';
        a1.Phone = '1800939393';
        a1.Website = 'ahhrealmonsters.edu';
        a1.BillingCountry = 'Nigeria';
		insert a1;
 		
        //Run insert test
        Account atest1 = [SELECT Id, Continent__c, BillingCountry FROM Account WHERE Id = :a1.Id];
        system.assert(atest1.Continent__c == 'Africa');
     
        //update record
        atest1.BillingCountry = 'United States';
        update atest1;
        
        //run update test
        Account atest2 = [SELECT Id, Continent__c, BillingCountry FROM Account WHERE Id = :a1.Id];
        system.debug('Test 2 Country: ' + atest2.BillingCountry);
        system.debug('Test 2 Continent: ' + atest2.Continent__c);
        system.assert(atest2.Continent__c == 'North America');
        
        //Create Blank org
        Account a2 = new Account();
        a2.Name = 'New notduplicate test2';
        a2.Type ='College/University (4)';
        a2.Phone = '1234567890';
        a2.Website = 'thisisonlyatest.edu';
		insert a2;
               
    }

}