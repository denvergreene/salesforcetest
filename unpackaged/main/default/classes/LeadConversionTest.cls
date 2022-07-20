@isTest 
public class LeadConversionTest {
    //When the lead conversion actually runs, it makes the log so long that it can't be seen in debug mode, 
    //so you need to change log levels in the debug  menu above
    
    
    public static TestMethod void PartnerProductSwapTest(){
        //This test checks that a partner product assigned to a lead gets updated properly
        Lead l = CreateTestRecords('PartnerProduct');
        
        List<Contact> contacts = [SELECT ID, Partner_selected_on_marketplace_form__c FROM Contact];
        system.debug('contacts: '+contacts);
        
        List<Partner_Product__c> PPs = [SELECT ID, Contact__c, Lead__c FROM Partner_Product__c WHERE Contact__c = :contacts[0].ID ];
        system.debug('PPs: '+PPs);
        system.assert(PPs.size()> 0);
        
    }
    
    static Lead CreateTestRecords(String TestType){
        system.debug('TestType: '+TestType);      
        
        Lead l = new Lead();
        l.FirstName 			= 'Denver';
        l.LastName 				= 'Greene519549519';
        l.Email 				= 'denver+test345753683457345@rice.edu';
        l.Company				= 'Test University';
        
		IF(TestType == 'PartnerProduct'){
            Account NewPartner = new Account();
            NewPartner.Name = 'PartnerTest';
            NewPartner.Type = 'Partner';
            NewPartner.RecordTypeId = [SELECT ID FROM RecordType WHERE Name = 'Partner' AND sObjectType = 'Account'].ID;
            insert NewPartner;
            
            CountryContinent__c CC = new CountryContinent__c();
            CC.Name = 'United States';
            CC.Continent__c = 'North America';
            insert CC;
            
            Account NewAccount = new Account();
            NewAccount.Name = 'Find Me A Home';
            NewAccount.Type = 'Other';
            NewAccount.Exclude__c = TRUE;
            NewAccount.BillingCountry = 'United States';
            NewAccount.Continent__c = 'North America';
            insert NewAccount;
            
            l.Partner_selected_on_marketplace_form__c = 'PartnerTest';
            l.School__c = NewAccount.Id;
            l.Instant_Conversion__c = TRUE;
        }

        system.debug('before insert');
        insert l;
        system.debug('after insert');
        
        return l;
        
      
    }
}