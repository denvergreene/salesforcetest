global class BulkTaskDelete implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    string OwnerID;
    
    global BulkTaskDelete(ID passedOwnerID) {
        OwnerID = passedOwnerID;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID '
            + 'FROM Task '
            + 'WHERE OwnerId = \'' + OwnerID +'\''
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Task> Tasks){
        delete Tasks;
    }
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}