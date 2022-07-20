trigger PopulateContinent on Account (before insert, before update)//, after update)
{
    
    List<CountryContinent__c> countryContinentList = [SELECT Name, Continent__c
                                                      FROM CountryContinent__c];
    
    Map<String,String> CountryMap = new Map<String , String>();
    for(CountryContinent__c c : countryContinentList)
    {
        CountryMap.put(c.Name, c.Continent__c);
    } 
    
    for(Account account : Trigger.new){
        IF(account.BillingCountry != null){
            //system.debug('account: '+account);
            account.Continent__c = CountryMap.get(account.BillingCountry);
        }
    }
    
}