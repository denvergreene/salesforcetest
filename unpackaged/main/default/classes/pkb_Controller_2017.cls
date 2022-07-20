public with sharing class pkb_Controller_2017 {
    
    //Hey OpenStax, if you create new article types, add their API name to this list
    List<String> articleTypesToInclude = new List<String> {'FAQ__kav'};
        //Alter how many articles you'd like to show per page of featured/search results
        public static Integer pageSize = 20;
    public Integer offSet {
        get { return pageSize * currPage; } }
    
    
    
    //This wrapper stores attributes of Knowledge Articles returned via SOQL queries to display
    // either as Featured Articles or Search Results
    public Class KnowledgeArticleListing implements Comparable {
        public String ArticleId {get; set;}
        public String Title {get; set;}
        public String UrlName {get; set;}
        public DateTime LastPublishedDate {get; set;}
        public Integer FeaturedPosition {get; set;}
        public KnowledgeArticleListing(String varArtId, String varTitle, String varUrlName, DateTime varlastPublishedDate,
                                       Integer varFeaturedPosition) {
                                           ArticleId = varArtId;
                                           Title = varTitle;
                                           UrlName = varUrlName;
                                           LastPublishedDate = varlastPublishedDate;
                                           FeaturedPosition = varFeaturedPosition;
                                       }
        
        public Integer compareTo(Object ObjToCompare) {
            return (FeaturedPosition < ((KnowledgeArticleListing)ObjToCompare).FeaturedPosition?1:0);
        }
    }
    
    //These are templates for SOQL queries
    String articleFieldsToSearch = ' Id, KnowledgeArticleId, LastPublishedDate, Title, UrlName ';
    String articleTypeBaseQuery = 'SELECT Id, KnowledgeArticleId, LastPublishedDate, Title, UrlName, Featured_Position__c ' + 
        'FROM FAQ__kav Where PublishStatus = \'Online\' ' + 
        ' And Language = \'en_US\' And IsDeleted = False And IsLatestVersion = True ' + 
        ' And IsVisibleInPkb = TRUE' +
        ' And Featured_Position__c > 0 Order By Featured_Position__c DESC';
    String articleTypeProductQuery = 'SELECT DataCategoryName,ParentId FROM FAQ__DataCategorySelection ' + 
        ' Where IsDeleted = FALSE';
    String articleSearchQuery = ' FIND :searchPhrase IN ALL FIELDS ' + 
        ' RETURNING KnowledgeArticleVersion ( Fields_To_Query  ' +
        ' WHERE PublishStatus = \'Online\' And language = \'en_US\' And IsLatestVersion = True'  +
        ' And IsVisibleInPkb = TRUE)  UPDATE TRACKING, VIEWSTAT '; //For pagination, replace this line with
    //' And IsVisibleInPkb = TRUE Limit :pageSize Offset :offSet ) UPDATE TRACKING, VIEWSTAT '; //this line
    //WITH DATA CATEGORY Products__c AT Include__c
    //This property queries and stores Featured Articles
    public List<KnowledgeArticleListing> featuredArticles {
        get {
            if(featuredArticles == null) {
                Set<Id> featuredArticleIds = new Set<Id>();
                featuredArticles = new List<KnowledgeArticleListing>();
                //Terminate Query
                System.Debug(articleTypeBaseQuery);
                for(SObject featuredKAVs: Database.query(articleTypeBaseQuery)) {
                    featuredArticleIds.add(featuredKAVs.Id); //Create set of Article IDs to query Products
                    featuredArticles.add(new KnowledgeArticleListing (  (String) featuredKAVs.get('Id'),
                                                                      (String) featuredKAVs.get('Title'),
                                                                      (String) featuredKAVs.get('UrlName'),
                                                                      (DateTime) featuredKAVs.get('LastPublishedDate'),
                                                                      Integer.valueOf(featuredKAVs.get('Featured_Position__c'))
                                                                     )
                                        ); //Store article in Wrapper
                    
                }
                mapArticleProducts.putAll(getProductsForArticles('FAQ', featuredArticleIds));
                mapArticleProducts.putAll(putEmptyProducts(mapArticleProducts.keySet(), featuredArticleIds));
                featuredArticles.sort();
            }
            
            return featuredArticles;
        }
        set; }
    
    //This property queries and stores Search Results based on keyword search
    public List<KnowledgeArticleListing> searchResults {
        get {
            if(searchResults==null) {
                Set<Id> searchResultsIds = new Set<Id>();
                searchResults = new List<KnowledgeArticleListing>();
                
                calculateNumOfResults();
                
                //Terminate Query
                String tempQuery = articleSearchQuery.replace('Fields_To_Query', articleFieldsToSearch);
                List<List<SObject>> searchResultsLists = Search.query(tempQuery);
                System.Debug(searchResultsLists);
                for(SObject searchResult: searchResultsLists[0]) {
                    searchResultsIds.add(searchResult.Id); //Create set of Article IDs to query Products
                    searchResults.add(new KnowledgeArticleListing (  (String) searchResult.get('Id'),
                                                                   (String) searchResult.get('Title'),
                                                                   (String) searchResult.get('UrlName'),
                                                                   (DateTime) searchResult.get('LastPublishedDate'),
                                                                   1
                                                                  )
                                     ); //Store article in Wrapper
                    
                }
                for(String articleType : articleTypesToInclude) 
                    mapArticleProducts.putAll(getProductsForArticles(articleType, searchResultsIds));
                mapArticleProducts.putAll(putEmptyProducts(mapArticleProducts.keySet(), searchResultsIds));
            }
            return searchResults;
        }
        set; }
    public Map<Integer, List<KnowledgeArticleListing>> searchResultsMap {
        get {
            if(searchResultsMap == null) {
                searchResultsMap = new Map<Integer, List<KnowledgeArticleListing>>();
                Integer articleCount = 0;
                Integer pageArticleCount = 0;
                Integer pageNum = 0;
                List<KnowledgeArticleListing> pageArticles = new List<KnowledgeArticleListing>();
                
                while(articleCount<searchResults.size()) {
                    while(pageArticleCount < pageSize && articleCount<searchResults.size()) {
                        pageArticles.add(searchResults[articleCount]);
                        articleCount++;
                        pageArticleCount++;
                    }
                    searchResultsMap.put(pageNum, pageArticles.clone());
                    pageArticleCount = 0;
                    pageNum++;
                    pageArticles.clear();
                }
                if(searchResultsMap.size()==0)
                    searchResultsMap.put(0, pageArticles);
            }
            return searchResultsMap;
        }
        set;
    }
    
    public Integer getNumOfPages() {
        return (Integer) Math.Ceil(Decimal.valueOf(numOfResults)/pageSize);
    }
    public void calculateNumOfResults() {
        String tempQuery = '';
        numOfResults = 0;
        tempQuery = articleSearchQuery.replace('Fields_To_Query', ' Id ');
        tempQuery = tempQuery.replace('Limit :pageSize Offset :offSet ) UPDATE TRACKING, VIEWSTAT', ')');
        
        List<List<SObject>> res = Search.Query(tempQuery);
        numOfResults = (Integer) res[0].size();
        
    }
    public Integer numOfResults { get {
        if(numOfResults == null)
            numOfResults = 0;
        return numOfResults;
    } set; }
    public Integer currPage { get {
        if(currPage == null)
            currPage = 0;
        return currPage;
    } set { featuredArticles = null; currPage = value; } }
    
    //Method that runs when we perform a search
    public PageReference performSearch() {
        searchResults = null;
        searchResultsMap = null;
        numOfResults = 0;
        PageReference homePage = Page.pkb_home_2017;
        homePage.getParameters().put('search', searchTermInput.trim());
        homePage.setRedirect(true);
        return homePage;
    }
    
    //This map stores the product for each article (by KnowledgeArticleId) that is retrieved either
    //as a featured article or search result
    public Map<String, String> mapArticleProducts { get {
        if(mapArticleProducts == null)
            mapArticleProducts = new Map<String, String>();
        return mapArticleProducts;
    }
                                                   set; }
    
    //Helper Variables to store Keyword Searches
    public string searchPhrase {get { if(searchPhrase == null) searchPhrase = ''; return searchPhrase; } set;}
    public string searchTermInput {get { if(searchTermInput == null) searchTermInput = 'Enter your question here.'; 
                                        return searchTermInput; } set;}
    public String feedbackComments {get; set;}
    
    public Map<String, String> getProductsForArticles(String articleType, Set<ID> articleIds) {
        //Query product mapping
        Map<String, String> mapRetArticleProducts = new Map<String, String>();
        String tempProductCategory = articleTypeProductQuery.replace('Article_Type', 
                                                                     articleType.replace('__kav', '__DataCategorySelection'));
        tempProductCategory += ' And ParentId In :articleIds';
        
        Map<String, String> temp = mapProductNameFromAPI;
        
        for(SObject dataCatSelection : Database.query(tempProductCategory))
            mapRetArticleProducts.put ((String) dataCatSelection.get('ParentId'), 
                                       mapProductNameFromAPI.get((String) dataCatSelection.get('DataCategoryName')));
        
        return mapRetArticleProducts;
    }
    
    public Map<String, String> mapProductNameFromAPI {
        
        get {
            if(mapProductNameFromAPI == null) {
                mapProductNameFromAPI = DescribeDataCategoryGroupStructures.getDescribeDataCategoryGroupStructureResults();
            }
            return mapProductNameFromAPI;
        }
        set; }
    
    
    // If an article doesn't have a product associated with it, we need to put a blank value for it in the map
    // or else the page crashes - Visualforce limitation
    public Map<String, String> putEmptyProducts(Set<String> mappedArticles, Set<ID> articleIds) {
        Map<String, String> mapRetArticleProducts = new Map<String, String>();
        for(Id articleId: articleIds)
            if(!mappedArticles.contains(articleId))
            mapRetArticleProducts.put(articleId, '');
        return mapRetArticleProducts;
    }
    
    //For Feedback collection
    public String strFeedback {get; set;}
    public String selectionFeedback {get; set;}
    public boolean displayPopup {get; set;}
    public void closePopup() { displayPopup = false; }     
    public void showPopup() { displayPopup = true; }
    public PageReference saveFeedback() {
        try {
            insert new PKB_Article_Feedback_Deflection__c (
                Comments__c = strFeedback,
                Deflection__c = FALSE,
                Feedback_Source__c = 'RelatedArticle',
                Keyword_Searched__c = searchPhrase);
        }
        catch (Exception e) { System.Debug(e.getMessage()); }
        displayPopup = false;
        return null;    
    }
    
    
    //Constructor Methods - These run when the page is first loaded
    public pkb_Controller_2017() {
        if(ApexPages.CurrentPage().getParameters().get('search') != null) {
            searchPhrase = ApexPages.CurrentPage().getParameters().get('search').trim();
            searchTermInput = ApexPages.CurrentPage().getParameters().get('search').trim();
        }
    }
    public pkb_Controller_2017(ApexPages.KnowledgeArticleVersionStandardController controller) {
        if(ApexPages.CurrentPage().getParameters().get('search') != null) {
            searchPhrase = ApexPages.CurrentPage().getParameters().get('search').trim();
            searchTermInput = ApexPages.CurrentPage().getParameters().get('search').trim();
        }
    }
    
}