public with sharing class TaskConfigurationController {
    @AuraEnabled(cacheable=true)
    public static List<String> getAllObjectNames() {
        List<String> objectNames = new List<String>();
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();

        for (String objectName : globalDescribeMap.keySet()) {
            objectNames.add(objectName);
        }

        return objectNames;
    }

    @AuraEnabled(cacheable=true)
    public static List<RecordTypeWrapper> getRecordTypes(String sObjectName) {
        List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType WHERE SObjectType = :sObjectName];
        List<RecordTypeWrapper> options = new List<RecordTypeWrapper>();
        for (RecordType rt : recordTypeList) {
            options.add(new RecordTypeWrapper(rt.Id, rt.Name));
        }
        return options;
    }

    @AuraEnabled
    public static Task_Configuration__c saveTaskConfiguration(String objectName, String recordTypeName) {
        try {
            List<Task_Configuration__c> existingConfigList = [SELECT Id FROM Task_Configuration__c 
                                                            WHERE Object_Name__c = :objectName 
                                                            AND Record_Type__c = :recordTypeName 
                                                            LIMIT 1];
            if (!existingConfigList.isEmpty()) {
                throw new AuraHandledException('A Record with the same Object and Record Type already exists.');
            }
            Task_Configuration__c taskConfig = new Task_Configuration__c(
                Object_Name__c = objectName,
                Record_Type__c = recordTypeName
            );
            insert taskConfig;
            
            return taskConfig;
        } catch (AuraHandledException e) {
            throw e;
        } catch (Exception e) {
            throw new AuraHandledException('Error saving Task Configuration: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Task_Configuration__c getRecentAutoNumber() {
        Task_Configuration__c taskConfig = [SELECT Name FROM Task_Configuration__c ORDER BY CreatedDate DESC LIMIT 1];
        return taskConfig;
    }

    public class RecordTypeWrapper {
        @AuraEnabled public String recordTypeId { get; set; }
        @AuraEnabled public String recordTypeName { get; set; }

        public RecordTypeWrapper(String recordTypeId, String recordTypeName) {
            this.recordTypeId = recordTypeId;
            this.recordTypeName = recordTypeName;
        }
    }

    @AuraEnabled
    public static Task createTask(String taskConfigId) {
        try {
            Task_Configuration__c taskConfig = [SELECT Id, Object_Name__c, Record_Type__c FROM Task_Configuration__c WHERE Id = :taskConfigId LIMIT 1];
    
            Task task = new Task(
                Subject = 'Call the Customer',
                Status = 'Not Started',
                WhatId = taskConfig.Id
            );
    
            insert task;

            return task;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating Task: ' + e.getMessage());
        }
    }
}