global class Refresh implements SandboxPostCopy  {
    
    global static void runApexClass(SandboxContext context) { 
            
        ////////////////////Fix email addresses////////////////////////////////
            
        List<User> userEmailList = [SELECT Email FROM User WHERE profile.name = 'System Administrator' and IsActive = TRUE]; 
        List<User> userUpdate = new List<User>();
        
        
        
        for(User uc : userEmailList) { 
            uc.Email = uc.Email.replace('=','@'); 
            String addedPhrase = '.invalid'; 
            uc.Email = uc.Email.remove(addedPhrase); 
            userUpdate.add(uc); 
        } 
        if(userUpdate.size() > 0) { 
            Update userUpdate; 
        } 
        
        //////////////////////Create test records////////////////////////////
        Account a1 	= new Account();
        a1.Name 	= 'Automation';
        a1.Type		= 'College/University (4)';
        a1.Phone	= '0000000000';
        a1.Website	= 'website.com';
        insert a1;
        
        List<Contact> newContacts = new List<Contact>();
        Integer count = 1;
        
        String[] emails1 = new String[]{'osttutor.test+001@gmail.com','osttutor.test+002@gmail.com','osttutor.test+003@gmail.com',
            'osttutor.test+004@gmail.com','osttutor.test+005@gmail.com','osttutor.test+006@gmail.com','osttutor.test+085@gmail.com',
            'osttutor.test+086@gmail.com','osttutor.test+087@gmail.com','osttutor.test+102@gmail.com','osttutor.test+103@gmail.com'};
                
                for (string email : emails1){
                    Contact c = new Contact();
                    c.AccountId = a1.Id;
                    c.FirstName = 'teacher';
                    c.LastName = string.valueOf(count);
                    c.Email = email;
                    c.FV_Status__c = 'confirmed_faculty';
                    newContacts.add(c);
                    count += 1;
                }
        
        Account a2 	= new Account();
        a2.Name 	= 'Test University';
        a2.Type		= 'College/University (4)';
        a2.Phone	= '0000000000';
        a2.Website	= 'website.com';
        insert a2;
        
        String[] emails2 = new String[]{'gmf3+canvas1@rice.edu', 'ash8@rice.edu', 'ash8+1@rice.edu', 'gmf3+demoinstruct@rice.edu', 
            'gmf3+instest@rice.edu', 'gmf3+instructor_new@rice.edu', 'gmf3+instructortest@rice.edu', 'gmf3+lmsteacher@rice.edu', 
            'gmf3+onboard@rice.edu', 'gmf3+teacher01@rice.edu', 'gmf3+teacherb1@rice.edu', 'gmf3+teacherb2@rice.edu', 
            'gmf3+teacherb3@rice.edu', 'gmf3+teacherb4@rice.edu', 'gmf3+teacherb5@rice.edu', 'gmf3+teacherbalt1@rice.edu', 
            'gmf3+teacherbb@rice.edu', 'gmf3+teacherbpilot@rice.edu', 'gmf3+teacherc1@rice.edu', 'gmf3+teacherc2@rice.edu', 
            'gmf3+teacherc3@rice.edu', 'gmf3+teacherc4@rice.edu', 'gmf3+teacherc5@rice.edu', 'gmf3+teachercalt1@rice.edu', 
            'gmf3+teachercanvas@rice.edu', 'gmf3+teachercpilot@rice.edu', 'gmf3+teacherflag1@rice.edu', 'gmf3+teacherflag2@rice.edu', 
            'gmf3+teachernl2@rice.edu', 'gmf3+teachernlms1@rice.edu', 'gmf3+teachernlms2@rice.edu', 'gmf3+teachernlms3@rice.edu', 
            'gmf3+teachernlms4@rice.edu', 'gmf3+teachernlms5@rice.edu', 'gmf3+teachernlmsalt1@rice.edu', 'gmf3+teacherqa@rice.edu', 
            'gmf3+teacherstaging@rice.edu', 'mn45@rice.edu', 'mn45+00215@rice.edu', 'mn45+00216@rice.edu', 'mn45+011@rice.edu', 
            'mn45+022@rice.edu', 'mn45+023@rice.edu', 'mn45+024@rice.edu', 'mn45+025@rice.edu', 'mn45+0451@rice.edu', 
            'mn45+090@rice.edu', 'mn45+091@rice.edu', 'mn45+092@rice.edu', 'mn45+1@rice.edu', 'mn45+124@rice.edu', 
            'mn45+214@rice.edu', 'mn45+219@rice.edu', 'mn45+91@rice.edu', 'mn45+999@rice.edu', 'mn45+9999@rice.edu', 
            'mwharrison@rice.edu', 'mwharrison+test@rice.edu', 'gmf3+5@rice.edu','mn45+6876@rice.edu',
            'gmf3+8@rice.edu', 'osttutor.test+s1@gmail.com', 'gmf3+teacher02@rice.edu', 'gmf3+teacher03@rice.edu', 
            'gmf3+teacher04@rice.edu', 'gmf3+teacher05@rice.edu', 'gmf3+teacher06@rice.edu', 'gmf3+teacher07@rice.edu', 
            'gmf3+teacher08@rice.edu', 'gmf3+teacher09@rice.edu','bf22+15@rice.edu', 'be12+2@rice.edu', 'be12+334@rice.edu'};
        
            for (string email : emails2){
                Contact c = new Contact();
                c.AccountId = a2.id;
                c.FirstName = 'teacher';
                c.LastName = string.valueOf(count);
                c.Email = email;
                c.FV_Status__c = 'confirmed_faculty';
                newContacts.add(c);
                count += 1;
            }
            
        insert newContacts;
    }
}