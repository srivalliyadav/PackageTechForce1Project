public with sharing class ProductController {
    @AuraEnabled(cacheable=true)
    public static List<Product2> getAllProducts() {
        return [SELECT Id, Name FROM Product2 WHERE IsActive = TRUE];
    }
    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getPricebookEntries() {
        return [
            SELECT Id, Pricebook2Id, Product2Id, UnitPrice
            FROM PricebookEntry
            WHERE Pricebook2.IsActive = TRUE
            AND IsActive = TRUE
        ];
    }
    @AuraEnabled(cacheable=true)
    public static Product2 getProductDetails(Id productId) {
        return [SELECT Id, Name FROM Product2 WHERE Id = :productId LIMIT 1];
    }
    @AuraEnabled(cacheable=true)
    public static PricebookEntry getPricebookEntry(Id productId) {
        return [
            SELECT Id, UnitPrice
            FROM PricebookEntry
            WHERE Product2Id = :productId
            AND IsActive = TRUE
            LIMIT 1
        ];
    }
}