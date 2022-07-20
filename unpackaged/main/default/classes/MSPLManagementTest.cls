@isTest
public class MSPLManagementTest {
    
    public static TestMethod void MSPLManagementTest1(){
        
        List<MSPLManagement.ParseInput> inputs = new List<MSPLManagement.ParseInput>();
        
        MSPLManagement.ParseInput input = new MSPLManagement.ParseInput();
        input.subjects1 = 'Biology; Chemistry';
        input.subjects2 = 'AP Bio; Chemistry';
        inputs.add(input);
        
        
        List<MSPLManagement.ParseResult> outputs = new List<MSPLManagement.ParseResult>();
        
        test.startTest();
        outputs = MSPLManagement.MultipleMSPLManagements(inputs);
        test.stopTest();

        system.debug(outputs);
        system.assert(outputs[0].allSubjects == 'Biology; Chemistry; AP Bio');
        system.assert(outputs[0].subjectList.size() == 3 );
        
    }
    
    public static TestMethod void MSPLManagementTest2(){
        
        List<MSPLManagement.ParseInput> inputs = new List<MSPLManagement.ParseInput>();
        
        MSPLManagement.ParseInput input = new MSPLManagement.ParseInput();
        input.subjects1 = 'Biology; AP Bio';
        input.subjects2 = null;
        inputs.add(input);
        
        
        List<MSPLManagement.ParseResult> outputs = new List<MSPLManagement.ParseResult>();
        
        test.startTest();
        outputs = MSPLManagement.MultipleMSPLManagements(inputs);
        test.stopTest();

        system.debug(outputs);
        system.assert(outputs[0].allSubjects == 'Biology; AP Bio');
        system.assert(outputs[0].subjectList.size() == 2 );
        
    }
    

}