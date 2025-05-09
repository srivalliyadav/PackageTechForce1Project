public with sharing class TaskConfigClass {
    // Method to fetch all object names dynamically
    @AuraEnabled
    public static List<String> getAllObjectNames() {
        List<String> objectNames = new List<String>();
        
        // Getting all global object descriptions
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        
        for (String objectName : globalDescribeMap.keySet()) {
            objectNames.add(objectName);
        }
        
        return objectNames;
    }
}