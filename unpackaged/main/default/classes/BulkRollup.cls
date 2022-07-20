global class BulkRollup implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID,Renewal_Status__c '
            + 'FROM Opportunity '
            + 'WHERE Need_Rollup__c = TRUE'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> Opps){
        for(Opportunity opp : Opps){
            opp.Trigger_Rollup__c = TRUE;
        }
        update Opps;
    }
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
    
    
}