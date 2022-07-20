@isTest
public class TutorCourseAssigning_Test {
    public static String CRON_EXP = '0 0 0 15 3 ? 2027';
    public static TestMethod void testthethings(){
        
        Account a = new Account();
        a.Name = 'test account';
        insert a;
        
        Contact c = new Contact();
        c.LastName = 'test contact';
        c.AccountId = a.id;
        insert c;
        
        Book__c book 					= new Book__c();
        book.Name    					= 'Biology';
        book.Short_Book_Name__c 		= 'Bio';
        book.Annualization_number__c 	= 1.6;
        book.Active__c					= TRUE;
        book.Publish_Date__c			= DATE.TODAY()-5;
        book.Tutor_Subject__c			= TRUE;
        
        insert book; 
        
        Opportunity o = new Opportunity();        
        o.Name					= 'Opp';
        o.Contact__c			= c.Id;
        o.AccountId				= a.Id;
        o.Book__c				= book.Id;
        o.Class_Start_Date__c	= date.newInstance(date.today().year()+(date.today().month() > 6 ? 2:1),01,05);
        o.Students__c			= 10;
        o.StageName				= 'Confirmed Adoption Won';
        o.CloseDate				= Date.Today();
        o.Time_Period__c		= 'Semester';
        insert o;
        
        

        List<Tutor_Course__c> TCUP = new List<Tutor_Course__c>();
        
        Tutor_Course__c TC1 = new Tutor_Course__c();
        TC1.Name 				= 'TC1';
        TC1.External_UUID__c 	= '1';
        TC1.Opportunity__c 		= o.Id;
        TC1.Book__c				= book.Id;
        TC1.Book_Name__c		= book.Name;
        TC1.Contact__c 			= c.id;
        TC1.Main_Course__c 		= TRUE;
        TCUP.add(TC1);
        
        Tutor_Course__c TC2 = new Tutor_Course__c();
        TC2.Name 				= 'TC2';
        TC2.External_UUID__c 	= '2';
        TC2.Opportunity__c 		= o.Id;
        TC2.Book__c				= book.Id;
        TC2.Book_Name__c		= book.Name;
        TC2.Contact__c 			= c.id;
        TC2.Main_Course__c 		= FALSE;
        TCUP.add(TC2);

        Tutor_Course__c TC3 = new Tutor_Course__c();
        TC3.Name 				= 'TC3';
        TC3.External_UUID__c 	= '2';
        TC3.Opportunity__c 		= o.Id;
        TC3.Book__c				= book.Id;
        TC3.Book_Name__c		= book.Name;
        TC3.Contact__c 			= c.id;
        TC3.Main_Course__c 		= FALSE;
        TCUP.add(TC3);
        
        
        insert TCUP;
        
        Test.startTest();
        
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new TutorCourseAssigning());
        
        Test.stopTest();
        //TutorCourseAssigning.SC();
        
        List<Tutor_Course__c> Mains = [SELECT ID, Main_Course__c
                                       FROM Tutor_Course__c
                                       WHERE Main_Course__c = TRUE];
        
        system.debug('Mains '+Mains);
        system.debug('Mains.size ' + Mains.size());
        system.assert(Mains.size() == 2);
        
    }
}