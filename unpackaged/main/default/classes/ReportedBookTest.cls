@isTest
public class ReportedBookTest {
    static testMethod void validateReportedbook(){
        Book__c book 					= new Book__c();
        book.Name    					= 'Biology';
        book.Short_Book_Name__c 		= 'Bio';
        book.Annualization_number__c 	= 1.6;
        book.Active__c					= TRUE;
        book.Publish_Date__c			= DATE.TODAY()-5;
        book.Tutor_Subject__c			= TRUE;
        
        insert book; 
        
        ReportedBook rBook = new ReportedBook();
        
        rBook.bookId = book.Id; 
        rBook.name = book.Name; 
        rBook.students = 13; 
        
        System.assertEquals(book.Id, rBook.bookId);
        System.assertEquals(book.name, rBook.name);
        System.assertEquals(13, rBook.students);
       
    }
}