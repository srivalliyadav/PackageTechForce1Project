trigger TaskCreationEventTrigger on TaskCreationEvent__e (after insert) {
  /*  List<sObject> recordsToProcess = new List<sObject>();

    for (TaskCreationEvent__e event : Trigger.new) {
        String objectType = event.ObjectType__c;
        String recordId = event.RecordId__c;
        String recordTypeId = event.RecordTypeId__c;
        
        String query = 'SELECT Id, RecordTypeId FROM ' + objectType + ' WHERE Id = :recordId LIMIT 1';
        sObject record = Database.query(query);

        recordsToProcess.add(record);
    }

    TaskConfigHandler.createTasksForRecord(recordsToProcess); */
}