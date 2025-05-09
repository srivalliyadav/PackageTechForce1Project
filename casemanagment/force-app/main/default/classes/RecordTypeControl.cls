public with sharing class RecordTypeControl {

    @AuraEnabled(cacheable=true)
    public static List<String> getAllObjectName() {
        List<String> objectNames = new List<String>();
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();

        for (String objectName : globalDescribeMap.keySet()) {
            Schema.SObjectType sObjectType = globalDescribeMap.get(objectName);
            String objectLabel = sObjectType.getDescribe().getLabel();
            objectNames.add(objectLabel);
        }

        return objectNames;
    }

    @AuraEnabled(cacheable=true)
    public static String getObjectApiNameFromLabel(String objectLabel) {
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();

        for (String objectName : globalDescribeMap.keySet()) {
            Schema.SObjectType sObjectType = globalDescribeMap.get(objectName);
            String currentLabel = sObjectType.getDescribe().getLabel();

            if (currentLabel == objectLabel) {
                return objectName;
            }
        }

        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getRecordTypeNames(String objectApiName) {
        List<String> recordTypeNames = new List<String>();

        if (String.isNotBlank(objectApiName)) {
            Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectApiName);
            if (objType != null) {
                Schema.DescribeSObjectResult describeResult = objType.getDescribe();
                List<Schema.RecordTypeInfo> recordTypeInfoList = describeResult.getRecordTypeInfos();

                for (Schema.RecordTypeInfo recordTypeInfo : recordTypeInfoList) {
                    if (recordTypeInfo.isAvailable() && !recordTypeInfo.isMaster()) {
                        recordTypeNames.add(recordTypeInfo.getName());
                    }
                }
            }
        }

        return recordTypeNames;
    }
}