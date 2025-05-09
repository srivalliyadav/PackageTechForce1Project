trigger ProjectTrigger on Project__c (after insert) {
    List<TaskCreationEvent__e> events = new List<TaskCreationEvent__e>();

    for (Project__c project : Trigger.new) {
        TaskCreationEvent__e event = new TaskCreationEvent__e(
            RecordId__c = project.Id,
            ObjectType__c = 'Project__c',
            RecordTypeId__c = project.RecordTypeId
        );
        events.add(event);
    }

    if (!events.isEmpty()) {
        Database.SaveResult[] results = EventBus.publish(events);
    }
}