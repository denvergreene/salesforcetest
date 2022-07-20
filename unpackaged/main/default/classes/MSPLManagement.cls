global class MSPLManagement {
    
    //this first part accepts data in a batch friendly way, and then runs through them one at a time
    @InvocableMethod(label='MSPLManagement')
    global static List<ParseResult> MultipleMSPLManagements(List<ParseInput> inputsMultiple) {
        List<ParseResult> results = new List<ParseResult>();
        for (ParseInput input : inputsMultiple) {
            results.add(OneMSPLManagement(input));
        }
        return results;
    }
    
    //this section is the things bring run through one at a time
    public static ParseResult OneMSPLManagement(ParseInput input) {
        ParseResult result = new ParseResult();
        //loop through subjectlist 1
        //system.debug('input.subjects1: '+input.subjects1);
        IF(input.subjects1 != null && input.subjects1.length()>1 ){
            String[] subject1List = input.subjects1.split(';');
            for(string subject : subject1List){
                IF(result.allSubjects == null){
                    result.allSubjects = subject;
                }
                ELSE IF(!result.allSubjects.contains(subject) ){
                    result.allSubjects += ';';
                    result.allSubjects += subject;
                }
                
                IF(!result.subjectList.contains(subject) ){
                    result.subjectList.add(subject);
                }
            }
        }
        
        //loop through subjectlist 2
        //system.debug('input.subjects2: '+input.subjects2);
        IF(input.subjects2 != null && input.subjects2.length()>1 ){
        	String[] subject2List = input.subjects2.split(';');
            for(string subject : subject2List){
                IF(result.allSubjects == null){
                    result.allSubjects = subject;
                }
                ELSE IF(!result.allSubjects.contains(subject) ){
                    result.allSubjects += '; ';
                    result.allSubjects += subject;
                }
                IF(!result.subjectList.contains(subject) ){
                    result.subjectList.add(subject);
                }
            }
        }
        system.debug('MSPL Management');
        return result;
    }
    
    global class ParseInput {
        @InvocableVariable
        global string subjects1; //(required=true)
        
        @InvocableVariable
        global string subjects2; //(required=true)
    }
    
    global class ParseResult {        
        @InvocableVariable
        global string allSubjects;
        
        @InvocableVariable
        global string[] subjectList = new List<string>();
    }

}