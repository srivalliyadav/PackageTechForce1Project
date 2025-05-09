public class ProductMarginController {

        // These Get Product details from the Product2 object based on Id
        @AuraEnabled
        public static Product2 getProductById(Id productId) {
            return [SELECT Id, Name FROM Product2 WHERE Id = :productId LIMIT 1];
        }
    
        // This Method to calculate margins based on unit cost, quantity, and sales price
        @AuraEnabled
        public static Map<String, Decimal> calculateMargins(Decimal unitCost, Integer quantity, Decimal unitSalesPrice) {
            Decimal perDayCost = (unitCost * quantity) / 21;
            Decimal perDaySalesPrice = (unitSalesPrice * quantity) / 21;
            Decimal totalCost = unitCost * quantity;
            Decimal totalSalesPrice = unitSalesPrice * quantity;
            Decimal dailyMargin = perDaySalesPrice - perDayCost;
            Decimal monthlyMargin = dailyMargin * 21;
    
            // in Map here Return the values 
            Map<String, Decimal> marginResults = new Map<String, Decimal>();
            marginResults.put('perDayCost', perDayCost);
            marginResults.put('perDaySalesPrice', perDaySalesPrice);
            marginResults.put('totalCost', totalCost);
            marginResults.put('totalSalesPrice', totalSalesPrice);
            marginResults.put('dailyMargin', dailyMargin);
            marginResults.put('monthlyMargin', monthlyMargin);
    
            return marginResults;
        }
    }