public class DescribeDataCategoryGroupStructures {
   public static Map<String, String>  getDescribeDataCategoryGroupStructureResults() {
      
      List<DescribeDataCategoryGroupResult> describeCategoryResult;
      List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;
      Map<String, String> mapCategoryAPILabel = new Map<String, String>();

      try {
         List<String> objType = new List<String>();
         objType.add('KnowledgeArticleVersion');
         describeCategoryResult = Schema.describeDataCategoryGroups(objType);
         
         //Creating a list of pair objects to use as a parameter 
    
         //for the describe call 
    
         List<DataCategoryGroupSobjectTypePair> pairs = 
            new List<DataCategoryGroupSobjectTypePair>();
         
         //Looping throught the first describe result to create 
    
         //the list of pairs for the second describe call 
    
         for(DescribeDataCategoryGroupResult singleResult : 
         describeCategoryResult){
            DataCategoryGroupSobjectTypePair p =
               new DataCategoryGroupSobjectTypePair();
            p.setSobject(singleResult.getSobject());
            p.setDataCategoryGroupName(singleResult.getName());
            pairs.add(p);
         }
         
         //describeDataCategoryGroupStructures() 
    
         describeCategoryStructureResult = 
            Schema.describeDataCategoryGroupStructures(pairs, false);

         //Getting data from the result 
    
         for(DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult){
            
            mapCategoryAPILabel.put(singleResult.getName(), singleResult.getLabel());

            DataCategory [] toplevelCategories = 
               singleResult.getTopCategories();
            
            //Recursively get all the categories 
    
            List<DataCategory> allCategories = 
               getAllCategories(toplevelCategories);

            for(DataCategory category : allCategories) {
               mapCategoryAPILabel.put(category.getName(), category.getLabel());
               DataCategory [] childCategories = category.getChildCategories();
            }
         }
      } catch (Exception e){
      }
      return mapCategoryAPILabel;
    }
    
   private static DataCategory[] getAllCategories(DataCategory [] categories){
      if(categories.isEmpty()){
         return new DataCategory[]{};
      } else {
         DataCategory [] categoriesClone = categories.clone();
         DataCategory category = categoriesClone[0];
         DataCategory[] allCategories = new DataCategory[]{category};
         categoriesClone.remove(0);
         categoriesClone.addAll(category.getChildCategories());
         allCategories.addAll(getAllCategories(categoriesClone));
         return allCategories;
      }
   }
}