@isTest
private class pkb_Controller_2017_Test {
	
	static void setupData() {
		
		User knowledgeUser = [Select Id From User Where UserPermissionsKnowledgeUser = True And IsActive = True Limit 1];
		System.runAs(knowledgeUser) {
			
			FAQ__kav pkbFAQ = new FAQ__kav(
				Title = 'Test FAQ',
				Summary = 'This is the summary for FAQ',
				UrlName = 'TestFAQ',
                Featured_Position__c = 1, 
				IsVisibleInPkb = True
			);
			insert pkbFAQ;


			pkbFAQ = [SELECT KnowledgeArticleId FROM FAQ__kav WHERE Id = :pkbFAQ.Id];
	    
	        KbManagement.PublishingService.publishArticle(pkbFAQ.KnowledgeArticleId, true);
        }

	}
	
	@isTest static void testKnowledgeMethods() {
		// Implement test code
		setupData();

		pkb_Controller_2017 pkbc = new pkb_Controller_2017();
		System.assertEquals(pkbc.featuredArticles.size(), 1);

		//Test searching methods
		Id [] fixedSearchResults= new Id[1];
		List<FAQ__kav> listResults =  [Select Id, Title, Summary, IsVisibleInPkb, Language, IsLatestVersion, PublishStatus
										FROM FAQ__kav Where Language = 'en_US' AND PublishStatus = 'Online'];
		fixedSearchResults[0] = listResults[0].Id;
		Test.setFixedSearchResults(fixedSearchResults);

		
		pkbc.searchPhrase = 'summary';
		System.Debug(pkbc.searchResults);
		System.assertEquals(pkbc.searchResults.size(), 1);

		pkbc.searchTermInput = 'summary';
		pkbc.performSearch();



	}
	
}