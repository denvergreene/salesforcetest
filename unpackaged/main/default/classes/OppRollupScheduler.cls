global class OppRollupScheduler implements Schedulable{
    global void execute(SchedulableContext SC){
                
        system.debug('Schedule Thing Run');
        OppRollup batch = new OppRollup();
        ID BatchId = Database.executeBatch(new OppRollup(),200);
        
        
/*
Cannot schedule using the UI scheduler because that only allows max 1 run per day and we want every 30 minutes
Execute the below stuff in an anonymous execute window (CTRL+E)

OppRollupScheduler sched = new OppRollupScheduler();
String cronStr = '0 0 * * * ?';
System.schedule('OppRollupSchedulerJob.0', cronStr, sched);

OppRollupScheduler sched = new OppRollupScheduler();
String cronStr = '0 30 * * * ?';
System.schedule('OppRollupSchedulerJob.5', cronStr, sched);

*/
    }
}