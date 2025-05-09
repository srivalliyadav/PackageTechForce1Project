trigger TaskConfig on Custom_Opportunity__c (before insert) {
    // Fetch the object names dynamically
    List<String> objectNames = GetAllObjects.getAllObjectNames();

    // Logic to set the first object name as default
    for (Custom_Opportunity__c taskConfig : Trigger.new) {
        if (taskConfig.Select_Object__c == null && !objectNames.isEmpty()) {
            // Set the first object as default
            taskConfig.Select_Object__c = objectNames[0];
        }
    }
}