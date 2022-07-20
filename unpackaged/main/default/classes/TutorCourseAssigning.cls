global class TutorCourseAssigning implements Schedulable {
	//This class sets one tutor course period for each course as the main one, so that we can count number of courses3
    global void execute(SchedulableContext SC){
        system.debug('Start Tutor Course Assign');
        
        List<Tutor_Course__c> TCoursesMain = [SELECT ID, External_UUID__c
                                          	  FROM Tutor_Course__c
                                              WHERE Main_Course__c = TRUE];
        
        List<Tutor_Course__c> TCoursesSub = [SELECT ID, External_UUID__c
                                          	 FROM Tutor_Course__c
                                             WHERE Main_Course__c = FALSE];
        
        List<Tutor_Course__c> TCoursesUp = new List<Tutor_Course__c>();
        List<string> exIDs = new List<string>();
        
        for(Tutor_Course__c TCM: TCoursesMain){
            exIDs.add(TCM.External_UUID__c);
        }
        
        for(Tutor_Course__c TC : TCoursesSub){
            //system.debug('TC '+TC);
                      
            if(!exIDs.contains(TC.External_UUID__c)){
                TC.Main_Course__c = TRUE;
                TC.Skip_Automation__c = TRUE;
                TCoursesUp.add(TC);
                exIDs.add(TC.External_UUID__c);
            }
        }
        //system.debug('TCoursesUp '+TCoursesUp);
        update TCoursesUp;
        system.debug('End Tutor Course Assign');
    }
}