public class GetAllObjects {
    @AuraEnabled(cacheable=true)
    public static List<String> getAllObjectNames() {
        List<String> objectNames = new List<String>();

        // Fetch all global objects in Salesforce
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        
        // Iterate over all available objects
        for (String objectName : globalDescribe.keySet()) {
            if (objectName != null && objectName != 'RecordType') {
                objectNames.add(objectName);
            }
        }

        return objectNames;
    }
}