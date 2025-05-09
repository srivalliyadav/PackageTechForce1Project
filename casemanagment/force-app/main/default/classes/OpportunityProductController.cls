public with sharing class OpportunityProductController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getOpportunityFields() {
        List<Map<String, Object>> fieldsMetadata = new List<Map<String, Object>>();
        
       
        List<String> fieldApiNames = new List<String>{
            'Amount',
            'ExpectedRevenue',
            'Profit__c',
            'Total_Sales_Price__c',
            'perDayCost__c',
            'perDaySalesPrice__c',
            'Daily_Margin__c',
            'Monthly_Margin__c'
        };
        
        for (String fieldApiName : fieldApiNames) {
            Schema.SObjectField fieldToken = Opportunity.SObjectType.getDescribe().fields.getMap().get(fieldApiName);
            if (fieldToken != null) {
                Schema.DescribeFieldResult fieldDescribe = fieldToken.getDescribe();
                
                Map<String, Object> fieldInfo = new Map<String, Object>();
                fieldInfo.put('label', fieldDescribe.getLabel());
                fieldInfo.put('fieldName', fieldApiName);
                fieldInfo.put('type', fieldDescribe.getType() == Schema.DisplayType.CURRENCY ? 'currency' : 'text');
                
                fieldsMetadata.add(fieldInfo);
            }
        }
        
        return fieldsMetadata;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunity(Id recordId) {
        return [SELECT Amount, ExpectedRevenue, Profit__c, Total_Sales_Price__c, perDayCost__c, 
                perDaySalesPrice__c, Daily_Margin__c, Monthly_Margin__c 
                FROM Opportunity WHERE Id = :recordId];
    }
}