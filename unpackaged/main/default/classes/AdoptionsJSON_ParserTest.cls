@IsTest
public class AdoptionsJSON_ParserTest {
    @IsTest
    static void validateAdoptionsJSONUtil () {
        List<Book__c> books = new List<Book__c>{new Book__c(Name = 'Biology'), new Book__c(Name = 'Introduction to Sociology',AKA__c ='Socio')};
        insert books;
        
        String JSONString = '{"Books":[{"name":"Biology","students":13},{"name":"Socio","students":13}]}';
                
        AdoptionsJSON_Parser.ParseInput parser = new AdoptionsJSON_Parser.ParseInput(); 
        System.debug('Empty Parser : ' + parser); 
        
        parser.inputString = JSONString; 
        System.debug('Parser with input variable set : ' + parser); 
        
        List<AdoptionsJSON_Parser.ParseResult> result = AdoptionsJSON_Parser.AdoptionsJSONUtil(new List<AdoptionsJSON_Parser.ParseInput> {parser});
        System.debug('Resulting AdoptionsJSON : ' + result); 
              
        //New tests that actually confirm ID
        System.assertEquals(books[0].Id, result[0].resultAdoptions.Books[0].bookId); //Normal test
        System.assertEquals(books[1].Id, result[0].resultAdoptions.Books[1].bookId); //AKA test    
    }

    @IsTest
    static void testBookNameTrim() {
        List<Book__c> books = new List<Book__c>{new Book__c(Name = 'Introduction to Business'), new Book__c(Name = 'Organizational Behavior')};
        insert books;
        
        String JSONString = '{"Books":[{"name":"Introduction to Business","students":13},{"name":" Organizational Behavior","students":13}]}';
                
        AdoptionsJSON_Parser.ParseInput parser = new AdoptionsJSON_Parser.ParseInput(); 
        System.debug('Empty Parser : ' + parser); 
        
        parser.inputString = JSONString; 
        System.debug('Parser with input variable set : ' + parser); 
        
        List<AdoptionsJSON_Parser.ParseResult> result = AdoptionsJSON_Parser.AdoptionsJSONUtil(new List<AdoptionsJSON_Parser.ParseInput> {parser});
        System.debug('Resulting AdoptionsJSON : ' + result); 
              
        //New tests that actually confirm ID
        System.assertEquals(books[0].Id, result[0].resultAdoptions.Books[0].bookId); //Normal test
        System.assertEquals(books[1].Id, result[0].resultAdoptions.Books[1].bookId); //AKA test    
    }

    @IsTest
    static void testAdoptionsJsonFailureEmail() {
        List<Book__c> books = new List<Book__c>{new Book__c(Name = 'Biology'), new Book__c(Name = 'Introduction to Sociology',AKA__c ='Socio')};
        insert books;
    
        String JSONString = '{"Books":[{"name":"Biology","students":13},{"name":"INVALID","students":0},{"name":"Socio","students":13}]}';
    
        AdoptionsJSON_Parser.ParseInput parser = new AdoptionsJSON_Parser.ParseInput();
        System.debug('Empty Parser : ' + parser);
    
        parser.inputString = JSONString;
        System.debug('Parser with input variable set : ' + parser);
    
        Test.startTest();
        List<AdoptionsJSON_Parser.ParseResult> result = AdoptionsJSON_Parser.AdoptionsJSONUtil(new List<AdoptionsJSON_Parser.ParseInput> {parser});
        System.debug('Resulting AdoptionsJSON : ' + result);
        //check that email was sent
        System.assertEquals(1, Limits.getEmailInvocations());
        Test.stopTest();
    }
}