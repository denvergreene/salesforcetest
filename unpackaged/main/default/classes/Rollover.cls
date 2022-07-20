global class Rollover implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    integer baseyear;
    
    global Rollover(integer passedBaseYear) {
        baseyear = passedBaseYear;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID,Renewal_Status__c '
            + 'FROM Opportunity '
            + 'WHERE Base_Year__c = ' +baseyear
            + ' AND Renewal_Status__c = \'Needs Renewal\' '
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> Opps){
        for(Opportunity opp : Opps){
            Map<String, Object> params = new Map<String, Object>();
            params.put('varOppId',opp.id);
            Flow.Interview.Rollover_Opps_Auto RolloverFlow = new Flow.Interview.Rollover_Opps_Auto(params);
            RolloverFlow.start();
        }
    }
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
        
}