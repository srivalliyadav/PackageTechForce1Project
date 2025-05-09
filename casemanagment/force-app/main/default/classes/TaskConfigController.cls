public with sharing class TaskConfigController {

    @AuraEnabled(cacheable=true)
    public static List<String> getAllObjectNames() {
        List<String> objectNames = new List<String>();

        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();

        for (String objectName : globalDescribeMap.keySet()) {
            objectNames.add(objectName);
        }

        return objectNames;
    }

    @AuraEnabled
    public static String createTaskConfig(String taskName, String selectedObject) {
        try {
            if (String.isEmpty(taskName) || String.isEmpty(selectedObject)) {
                throw new AuraHandledException('Task Name and Object Name are required.');
            }

            Custom_Opportunity__c newTaskConfig = new Custom_Opportunity__c();
            newTaskConfig.Name = taskName;
            newTaskConfig.Object__c = selectedObject;

            insert newTaskConfig;

            Id relatedRecordId;

            if (selectedObject == 'Account') {
                Account newAccount = new Account();
                newAccount.Name = taskName;
                insert newAccount;

                Task newTask = new Task();
                newTask.Subject = taskName;
                newTask.Status = 'Not Started';
                newTask.WhatId = newAccount.Id;
                insert newTask;

                relatedRecordId = newAccount.Id;

            } else if (selectedObject == 'Contact') {
                Contact newContact = new Contact();
                newContact.LastName = taskName;
                insert newContact;

                Task newTask = new Task();
                newTask.Subject = taskName;
                newTask.Status = 'Not Started';
                newTask.WhoId = newContact.Id;
                insert newTask;

                relatedRecordId = newContact.Id;

            } else if (selectedObject == 'Opportunity') {
                Opportunity newOpportunity = new Opportunity();
                newOpportunity.Name = taskName;
                newOpportunity.Type = 'Existing Customer - Upgrade';
                newOpportunity.Amount = 10000;
                newOpportunity.CloseDate = Date.today().addDays(30);
                newOpportunity.StageName = 'Prospecting';
                insert newOpportunity;

                Task newTask = new Task();
                newTask.Subject = taskName;
                newTask.Status = 'Not Started';
                newTask.WhatId = newOpportunity.Id;
                insert newTask;

                relatedRecordId = newOpportunity.Id;
            }

            return relatedRecordId;
        } catch (Exception e) {
            System.debug('Error in createTaskConfig: ' + e.getMessage());
            throw new AuraHandledException('Error creating records: ' + e.getMessage());
        }
    }
}