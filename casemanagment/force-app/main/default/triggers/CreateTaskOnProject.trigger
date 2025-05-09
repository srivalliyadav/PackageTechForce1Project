trigger CreateTaskOnProject on Project__c (after insert) {
  /*  // List to hold tasks to insert
    List<Task> tasksToInsert = new List<Task>();

    // Loop through the newly inserted Project__c records
    for (Project__c proj : Trigger.new) {
        // Check if the Project has a RecordType
        if (proj.RecordTypeId != null) {
            // Get Object Name and Record Type for Project__c
            String objectName = 'Project__c';
            String recordTypeId = proj.RecordTypeId;

            // Query the Task Configuration Custom Object
            List<Task_Configuration__c> taskConfigRecords = [
                SELECT Id, Object_Name__c, Record_Type__c
                FROM Task_Configuration__c
                WHERE Object_Name__c = :objectName AND Record_Type__c = :recordTypeId
            ];

            // If a matching Task Configuration record is found, create a Task
            if (!taskConfigRecords.isEmpty()) {
                for (Task_Configuration__c taskConfig : taskConfigRecords) {
                    Task newTask = new Task(
                        WhatId = proj.Id,
                        Subject = 'Call the Customer',
                        Status = 'Not Started'
                    );
                    tasksToInsert.add(newTask);
                }
            }
        }
    }

    // Insert all created tasks
    if (!tasksToInsert.isEmpty()) {
        insert tasksToInsert;
    }     */
}