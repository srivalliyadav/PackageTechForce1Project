import { LightningElement, api, wire } from 'lwc';
import getOpportunityProducts from '@salesforce/apex/OpportunityProductController.getOpportunityProducts';

export default class opportunityProduct extends LightningElement {
    @api opportunityId; 
    products = [];

    totalCostPrice = 0;
    totalSalesPrice = 0;
    dailyMargin = 0;
    monthlyMargin = 0;

    @wire(getOpportunityProducts, { opportunityId: '$opportunityId' })
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data;
            this.calculateTotals(); 
        } else if (error) {
            console.error('Error fetching products:', error);
        }
    }

    calculateTotals() {
       
        this.totalCostPrice = 0;
        this.totalSalesPrice = 0;
        this.dailyMargin = 0;
        this.monthlyMargin = 0;

        this.products.forEach(product => {
            const productCost = product.UnitPrice * product.Quantity;
            const productSalesPrice = productCost * 1.2; // Assuming 20%  for sales price
            const productDailyMargin = (productSalesPrice - productCost) / 21; 
            const productMonthlyMargin = productDailyMargin * 21;

            this.totalCostPrice += productCost;
            this.totalSalesPrice += productSalesPrice;
            this.dailyMargin += productDailyMargin;
            this.monthlyMargin += productMonthlyMargin;
        });
    }
}