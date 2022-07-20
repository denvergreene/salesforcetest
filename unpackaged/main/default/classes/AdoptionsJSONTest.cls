@isTest
public class AdoptionsJSONTest {
    static testMethod void validateAdoptionsJSON(){
        string jsonString = '{"Books":[{"name":"Biology","students":13},{"name":"Introduction to Sociology","students":15}]}'; 
        AdoptionsJSON parsedJSON = new AdoptionsJSON(); 
        
        Type objType = Type.forName('AdoptionsJSON');
		parsedJSON = (AdoptionsJSON) JSON.deserialize(jsonString, objType); 
        
        
        System.assertEquals('Biology', parsedJSON.Books[0].name); 
    }
}