public class TaskConfigHandlerOne {
    @InvocableMethod(label='Create Tasks for Record' description='Creates tasks based on Task Configuration.')
    public static void createTasksRecord(List<String> recordIds) {
        if (recordIds.isEmpty()) return;

        List<sObject> recordsToProcess = new List<sObject>();

        for (String recordId : recordIds) {
            sObject record = [SELECT Id, RecordTypeId FROM Opportunity WHERE Id = :recordId LIMIT 1];
            recordsToProcess.add(record);
        }

        List<Task> tasksToInsert = new List<Task>();
        Map<String, Task_Configuration__c> taskConfigMap = new Map<String, Task_Configuration__c>();

        for (Task_Configuration__c config : [SELECT Object_Name__c, Record_Type__c FROM Task_Configuration__c]) {
            taskConfigMap.put(config.Object_Name__c + '-' + config.Record_Type__c, config);
        }

        for (sObject record : recordsToProcess) {
            String objectName = record.getSObjectType().getDescribe().getName();
            String recordTypeId = (String) record.get('RecordTypeId');
            String recordTypeName = '';

            if (String.isNotBlank(recordTypeId)) {
                RecordType rt = [SELECT Name FROM RecordType WHERE Id = :recordTypeId LIMIT 1];
                recordTypeName = rt.Name;
            }

            String taskConfigKey = objectName + '-' + recordTypeName;
            Task_Configuration__c taskConfig = taskConfigMap.get(taskConfigKey);

            if (taskConfig != null) {
                List<Task> newTasks = [SELECT Id, Subject, Status, Priority, WhatId 
                                       FROM Task WHERE WhatId = :taskConfig.Id];

                for (Task existingTask : newTasks) {
                    Task newTask = new Task();
                    newTask.Subject = existingTask.Subject;
                    newTask.Status = existingTask.Status;
                    newTask.Priority = existingTask.Priority;
                    newTask.WhatId = record.Id;
                    newTask.Description = 'Task based on Task Configuration: ' + taskConfig.Record_Type__c;
                    tasksToInsert.add(newTask);
                }
            }
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}