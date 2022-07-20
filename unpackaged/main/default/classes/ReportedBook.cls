public class ReportedBook {
    /*Author: Brent Suggs - Slalom LLC 
     *Description: Object notation for the ReportedBooks list in AdoptoionsJSON object
     *Date: 9/29/2021 
     */
    
    @AuraEnabled public string bookId; 
 	@AuraEnabled public string name;
    @AuraEnabled public integer students;
    public ReportedBook() {}
 }