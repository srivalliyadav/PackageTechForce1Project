trigger OpportunityTrigger on Opportunity (after insert) {
    List<TaskCreationEvent__e> events = new List<TaskCreationEvent__e>();

    for (Opportunity opp : Trigger.new) {
        TaskCreationEvent__e event = new TaskCreationEvent__e(
            RecordId__c = opp.Id,
            ObjectType__c = 'Opportunity',
            RecordTypeId__c = opp.RecordTypeId
        );
        events.add(event);
    }

    if (!events.isEmpty()) {
        Database.SaveResult[] results = EventBus.publish(events);
    }
}