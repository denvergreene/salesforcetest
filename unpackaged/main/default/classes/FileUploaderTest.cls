@IsTest
public class FileUploaderTest {
    static testmethod void testfileupload(){
     /*   system.debug('start test');
        
        //Create test accounts
        List<Account> accounts = new List<Account>();
        for(integer i = 1; i<10; i++){
            Account a 		= new account();
            a.Name			= 'name'+i;
            a.IPEDS_ID__c	= string.valueOf(i);
            a.Type			= 'College/University (4)';
            accounts.add(a);
        }
        
        system.debug('insert accounts');
        insert accounts;
        
        //Create test contacts
        List<Contact> contacts = new List<Contact>();
        for(integer i = 2; i<10;i++){
            Contact c 		= new contact();
            c.FirstName		= 'Denver';
            c.LastName		= 'Test'+i;
            c.AccountId 	= accounts[i-1].id;
            c.Email			= 'denver+test'+i+'@rice.edu';
            c.All_Emails__c	= 'denver+test'+i+'@rice.edu';
            c.Phone			= '0000000000';
            c.Last_In_Touch_Date__c = date.newInstance(2020, 02, 01);
            contacts.add(c);
        }
        contacts[4-2].Subject__c	= 'Biology';
        contacts[8-2].Email 		= 'dumbemail1@gmail.com';
        contacts[8-2].All_Emails__c	= 'dumbemail1@gmail.com';
        contacts[9-2].Email 		= 'dumbemail2@gmail.com';
        contacts[9-2].All_Emails__c	= 'denver+test9@rice.edu, dumbemail2@gmail.com';
        contacts[9-2].LastName 		= 'forgetaboutit';
        
        system.debug('insert contacts');
        insert contacts;
        
        //Create Books
        List<Book__c> Books = new List<Book__c>();
        Book__c bookPsyc 	= new Book__c();
        bookPsyc.Name						= 'Psychology';
        bookPsyc.Active__c					= true;
        bookPsyc.Annualization_number__c 	= 1.6;
        bookPsyc.Publish_Date__c			= date.newInstance(2015, 03, 04);
        Books.add(bookPsyc);
        
        Book__c bookBio 	= new Book__c();
        bookBio.Name						= 'Biology';
        bookBio.Active__c					= true;
        bookBio.Annualization_number__c 	= 1.6;
        bookBio.Publish_Date__c				= date.newInstance(2015, 03, 04);
        Books.add(bookBio);
        
        system.debug('insert books');
        insert Books;
        
        //create test Opportunities
        List<Opportunity> opps = new List<Opportunity>();
        Opportunity oppPrevious 		= new Opportunity();
        oppPrevious.Name				= 'temp name';
        oppPrevious.StageName			= 'Confirmed Adoption Won';
        oppPrevious.Contact__c			= contacts[1].id;
        oppPrevious.AccountId			= accounts[2].id;
        oppPrevious.Book__c				= Books[0].id;
        oppPrevious.Description			= 'temp';
        oppPrevious.Class_Start_Date__c = date.newInstance(2019, 08, 10);
        oppPrevious.Students__c			= 30;
        oppPrevious.Time_Period__c		= 'Year';
        oppPrevious.CloseDate			= date.today();
        opps.add(oppPrevious);
        
        Opportunity oppCurrent 		= new Opportunity();
        oppCurrent.Name					= 'temp name';
        oppCurrent.StageName			= 'Confirmed Interest';
        oppCurrent.Contact__c			= contacts[2].id;
        oppCurrent.AccountId			= accounts[3].id;
        oppCurrent.Book__c				= Books[0].id;
        oppCurrent.Description			= 'temp';
        oppCurrent.Class_Start_Date__c 	= date.newInstance(2020, 08, 10);
        oppCurrent.Students__c			= 30;
        oppCurrent.Time_Period__c		= 'Year';
        oppCurrent.CloseDate			= date.today();
        opps.add(oppCurrent);
        
        system.debug('insert opps');
        insert opps;
        
        // create BMG records
        List<BMG__c> BMGs = new List<BMG__c>();
        for(integer i = 1; i <12; i++){
            BMG__c BMG 			= new BMG__c();
            BMG.Book_Name__c 	= 'Psychology';
            BMG.IPED__c			= String.valueof(i);
            BMG.Period__c		= 'Fall 2020';
            BMG.Enrollments__c	= i*10;
            BMG.First_Name__c	= 'Denver';
            BMG.Last_Name__c	= 'Test'+i;
            BMG.Email__c		= 'denver+test'+i+'@rice.edu';
            BMGs.add(BMG);
        }
        
        BMG__c BMG5 = BMGs[4].clone(false,false,false,false);
        BMGs.add(BMG5);
        
        BMG__c BMG6 = BMGs[5].clone(false,false,false,false);
        BMG6.Book_Name__c = 'Biology';
        BMG6.Enrollments__c = 80;
        BMGs.add(BMG6);
        BMGs[5].Enrollments__c = 70;
        
        BMGs[6].Enrollments__c = 100;
        BMG__c BMG7 = BMGs[6].clone(false,false,false,false);
        BMG7.Enrollments__c = 90;
        BMG7.Period__c = 'Fall 2019';
        BMGs.add(BMG7);
        
        BMGs[10].IPED__c = String.valueOf(3);
        BMG__c BMG11 = BMGs[10].clone(false,false,false,false);
        BMG11.Book_Name__c	= 'Biology';
        BMGs.add(BMG11);
        
        system.debug('insert BMGs');
        insert BMGs;
        system.debug('BMG6: '+BMG6);
        
        
        
        
      */  
        
        BMG__c BMG 			= new BMG__c();
        BMG.Book_Name__c 	= 'Psychology';
        BMG.IPED__c			= '1';
        BMG.Period__c		= 'Fall 2020';
        BMG.Enrollments__c	= 10;
        BMG.First_Name__c	= 'Denver';
        BMG.Last_Name__c	= 'Test1';
        BMG.Email__c		= 'denver+test1@rice.edu';
        insert BMG;
        
        test.startTest();
        
        FileUploader FU = new FileUploader();
        Id batchId = Database.executeBatch(FU);
        FileUploader.ReadBMG(null);

        test.stopTest();
        
        
        
      /*  
        
        //contact tests
        //test cases can be found here https://docs.google.com/document/d/14OP4Yg5gM7YruYL5zOJSaacKt4nmVUg263amDJHxZ1U/edit
        
        List<Contact> contest1List = [SELECT ID, Email
                                      FROM Contact
                                      WHERE Email = 'denver+test1@rice.edu']; 
        system.assert(contest1List.size() == 1);
        
        List<Contact> contest2List = [SELECT ID, Email, Last_In_Touch_Date__c
                            			FROM Contact
                            			WHERE Email = 'denver+test2@rice.edu']; 
        system.assert(contest2List.size() ==1);
        system.debug('contest2: '+contest2List[0]);
        system.assert(contest2List[0].Last_In_Touch_Date__c > (date.today()-366 ));
        
        List<Contact> contest3List = [SELECT ID, Email, Last_In_Touch_Date__c
                            			FROM Contact
                            			WHERE Email = 'denver+test3@rice.edu']; 
        system.assert(contest3List.size() ==1);
        system.assert(contest3List[0].Last_In_Touch_Date__c > (date.today()-366 ));
        
        List<Contact> contest5List = [SELECT ID, EMAIL, Subject__c
                                      FROM Contact
                                      WHERE Email = 'denver+test5@rice.edu'];
        system.assert(contest5List.size() == 1);
        system.assert(contest5List[0].Subject__c == 'Psychology');
        
        List<Contact> contest6List = [SELECT ID, EMAIL, Subject__c
                                      FROM Contact
                                      WHERE Email = 'denver+test6@rice.edu'];
        system.debug('contest6List: '+contest6List);
        system.assert(contest6List.size() == 1);
        system.assert(contest6List[0].Subject__c == 'Psychology;Biology' || contest6List[0].Subject__c == 'Biology;Psychology');
        
        List<Contact> contest7List = [SELECT ID, EMAIL
                                      FROM Contact
                                      WHERE Email = 'denver+test7@rice.edu'];
        system.assert(contest7List.size() == 1);
        
        List<Contact> contest8List = [SELECT ID, EMAIL
                                      FROM Contact
                                      WHERE Email = 'denver+test8@rice.edu'];
        system.debug('contest8List: '+contest8List);
        system.assert(contest8List.size() == 0);
        
        List<Contact> contest9List = [SELECT ID, EMAIL
                                      FROM Contact
                                      WHERE Email = 'denver+test9@rice.edu'];
        system.assert(contest9List.size() == 0);
        
        
        
        //Opportunity tests
        List<Opportunity> opp1List = [SELECT ID, Yearly_Students__c
                                     FROM Opportunity
                                    WHERE Contact_Email__c = 'denver+test1@rice.edu'];
        system.debug('opp1List: '+opp1List);
        system.assert(opp1List.size()==1);
        system.assert(opp1List[0].Yearly_Students__c == 10);
        
        List<Opportunity> opp2List = [SELECT ID, Yearly_Students__c, Type, Fall_Students__c, Spring_Students__c, Summer_Students__c
                                     FROM Opportunity
                                    WHERE Contact_Email__c = 'denver+test2@rice.edu'];
        system.assert(opp2List.size()==1);
        system.assert(opp2List[0].Type == 'New Business');
        system.assert(opp2List[0].Yearly_Students__c == 21);
        
        List<Opportunity> opp3List = [SELECT ID, Yearly_Students__c, Type, Base_Year__c
                                     FROM Opportunity
                                     WHERE Contact_Email__c = 'denver+test3@rice.edu'
                                     ORDER BY Base_Year__c];
        system.assert(opp3List.size()==2);
        system.assert(opp3List[0].Type == 'Renewal' || opp3List[1].Type == 'Renewal');
        system.assert(opp3List[0].Yearly_Students__c == 30 || opp3List[1].Yearly_Students__c == 30);
        
        List<Opportunity> opp4List = [SELECT ID, Yearly_Students__c, Type
                                     FROM Opportunity
                                     WHERE Contact_Email__c = 'denver+test4@rice.edu'];
        system.assert(opp4List.size()==1);
        system.assert(opp4List[0].Yearly_Students__c == 40);
        
        List<Opportunity> opp5List = [SELECT ID, Yearly_Students__c, Type
                                     FROM Opportunity
                                     WHERE Contact_Email__c = 'denver+test5@rice.edu'];
        system.assert(opp5list.size()==1);
        system.assert(opp5list[0].Yearly_Students__c == 50);
        
        List<Opportunity> opp6List = [SELECT ID, Yearly_Students__c, Type, Book__c
                                     FROM Opportunity
                                     WHERE Contact_Email__c = 'denver+test6@rice.edu'
                                     ORDER BY Book__c];
        system.assert(opp6list.size()==2);
        system.assert(opp6list[0].Book__c == Books[0].ID && opp6list[0].Yearly_Students__c == 70);
        system.assert(opp6list[1].Book__c == Books[1].ID && opp6list[1].Yearly_Students__c == 80);
        
        List<Opportunity> opp7List = [SELECT ID, Yearly_Students__c, Type, Base_Year__c
                                     FROM Opportunity
                                     WHERE Contact_Email__c = 'denver+test7@rice.edu'
                                     ORDER BY Base_Year__c ASC
                                     ];
        system.assert(opp7list.size()==2);
        system.assert(opp7list[0].Type == 'New Business' && opp7list[0].Yearly_Students__c == 90);
        system.assert(opp7list[1].Type == 'Renewal'		 && opp7list[1].Yearly_Students__c == 101);
        
        List<Opportunity> opp8List = [SELECT ID, Yearly_Students__c, Type, Base_Year__c
                                     FROM Opportunity
                                     WHERE Contact__c = :contacts[8-2].id
                                     ];
        system.assert(opp8list.size()==1);
        
        List<Opportunity> opp9List = [SELECT ID, Yearly_Students__c, Type, Base_Year__c
                                     FROM Opportunity
                                     WHERE Contact__c = :contacts[9-2].id
                                     ];
        system.assert(opp9list.size()==1);
        
        List<BMG__c> BMGsTest = [SELECT ID, Needs_Manual_Entry__c
                            FROM BMG__c];
        system.assert(BMGsTest.size()==1);
        system.assert(BMGsTest[0].Needs_Manual_Entry__c == TRUE);
*/
    }
}