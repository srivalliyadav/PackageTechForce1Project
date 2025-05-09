/*public with sharing class ProjectController {
    @AuraEnabled(cacheable=true)

    public static List<Project__c>getProjects () {
       return[SELECT  Id,Name,Project_Start_Date__c,Project_End_Date__c,Project_Status__c FROM Project__c ];

    }
}*/
public with sharing class ProjectController {
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjects(String filterType) {
       
        List<Project__c> projects = new List<Project__c>();

       
        String query = 'SELECT Id, Name, Account__r.Name, RecordType.Name FROM Project__c';

       
        List<Project__c> allProjects = Database.query(query);

        
        for (Project__c project : allProjects) {
            if (filterType == 'All' || 
            (filterType == 'Billable' && project.RecordType.Name == 'Billable_Project') || 
                (filterType == 'Non-Billable' && project.RecordType.Name == 'Non_Billable_Projects')) {
                projects.add(project);
            }
        }
        
        return projects;
    }
}