public class AdoptionsJSON_Parser {
    /* 
     *Description: Parse the provided JSON string into the AdoptionsJSON object and then pull the Book__c Id for the reported books. Used by the 'Reported Adoptions' Flow. 
     * 
     */
     
    @InvocableMethod(Label='Parse AdoptionsJSON')
    public static List<ParseResult> AdoptionsJSONUtil(List<ParseInput> jsonStringList) {
        //get books, build map
        List<Book__c> Books = [SELECT Id, Name, Tutor_Subject__c, Official_Name__c, AKA__c
                               FROM Book__c];
        Map<String, Book__c> BookMap = new Map<String, Book__c>();
        for(Book__c book: Books){
            BookMap.put(book.Name,book);
            BookMap.put(book.Official_Name__c,book);
            if(book.AKA__c != null){
                List<String> AKAList = book.AKA__c.split(',');
                for(String AKA: AKAList){
                    BookMap.put(AKA,book);
                }
            }
        }
        //System.debug('BookMap: '+BookMap);
        
        List<ParseResult> results = new List<ParseResult>();

        for(ParseInput input : jsonStringList) {
            System.debug('input' + input);
            Type objType = Type.forName('AdoptionsJSON');  //I'm not totally sure what's going on here or next line
            AdoptionsJSON parsedJSON = (AdoptionsJSON) JSON.deserialize(input.inputString, objType);
            
            //System.debug('parsedJSON: ' + parsedJSON);
            //System.debug('parsedJSON.books: ' + parsedJSON.Books);
            
            for(Integer i = 0; i < parsedJSON.Books.size(); i++){
                ReportedBook book = parsedJSON.Books.get(i);
                //System.debug('ResportedBook: ' + book);
                try{
                    book.bookId = BookMap.get(book.name.trim()).Id;
                } catch(Exception ex){
                    String body = '<p>Error while parsing AdoptionJSON. Book: ' + book + '</p><p><pre>' + ex.getMessage() + ' ' + ex.getStackTraceString() + '</pre></p>';
                    System.debug('body: ' + body);
                    parsedJSON.Books.remove(i);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> toEmails = getAdminEmails();
                    mail.setToAddresses(toEmails);
                    mail.setSubject('Salesforce AdoptionJSON_Parser Error');
                    mail.setHtmlBody(body);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                    continue;
                }
            }
            ParseResult r = new ParseResult();
            r.resultAdoptions = parsedJSON;
            results.add(r);
            
        }

        //System.debug('results: '+results);
        return results; 
    }

    public static List<String> getAdminEmails(){
        List<String> adminEmails = new List<String>();
        List<User> adminUsers = [SELECT Email FROM User WHERE Profile.Name = 'System Administrator' AND User.IsActive = TRUE];
        for(User user : adminUsers){
            if(user.Email.indexOf('invalid') == -1){
                adminEmails.add(user.Email);
            }
        }
        return adminEmails;
    }
        
        /*
        System.Debug('Parsing Started -->');
        List<ParseResult> results = new List<ParseResult>(); 
        for(ParseInput input : jsonStringList) {
            system.debug('input' + input);
            Type objType = Type.forName('AdoptionsJSON');
            AdoptionsJSON parsedJSON = (AdoptionsJSON) JSON.deserialize(input.inputString, objType);

            AdoptionsJSON parsedJSONWithIds = GetBookIds(parsedJSON);
            ParseResult r = new ParseResult(); 
            r.resultAdoptions = parsedJSONWithIds; 
            results.add(r);
        }
        System.Debug('Parsing Ended --!');
        return results; 

    }
    
    //Grab and store the Book__c Ids for the reported Books
    public static AdoptionsJSON GetBookIds(AdoptionsJSON parsedAdoptions){
        System.Debug('GetBookIDs Started -->');
        //Find Book__c records with list of reported book names
        List<string> bookNames = new List<string>(); 
        for(ReportedBook b : parsedAdoptions.Books) {
            bookNames.add(b.name); 
        }
        List<Book__c> subjects = [Select Id, Name, Tutor_Subject__c From Book__c Where Name in :bookNames]; 
        System.debug(subjects); 
        
        //If any are returned; store the IDs 
        if(subjects.size() > 0){
        	for(Integer i=0;i<subjects.size();i++){
            	parsedAdoptions.Books[i].bookId = subjects[i].Id; 
        	} 
        }
        System.Debug('GetBookIds Ended --!');
        return parsedAdoptions; 

    }
*/
	//Input Variables
    public class ParseInput {
        @InvocableVariable
        public String inputString; //(required=true)
    }
    //Output Variables 
    public class ParseResult {        
        @InvocableVariable
        public AdoptionsJSON resultAdoptions;
    }

}