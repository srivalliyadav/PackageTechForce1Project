import { LightningElement, api, wire } from 'lwc';
import getOpportunityProductTotal from '@salesforce/apex/OpportunityProductController.getOpportunityProductTotal';
import { refreshApex } from '@salesforce/apex';

export default class CalculateMargin extends LightningElement {
    @api opportunityId; // Opportunity Id received as input
    SalesPrice = 0;
    multiplier = 1;
    totalSalesPrice = 0;
    totalCostPrice = 0;
    dailyMargin = 0;
    monthlyMargin = 0;

    // Store the wired Apex method result to refresh on demand
    wiredOpportunityProductsResult;

    // Fetch the total sales price when component is initialized or when opportunityId changes
    @wire(getOpportunityProductTotal, { opportunityId: '$opportunityId' })
    wiredOpportunityProducts(result) {
        this.wiredOpportunityProductsResult = result; // Store result for refresh use
        const { error, data } = result;
        if (data) {
            this.SalesPrice = data;
            this.calculateTotals();
        } else if (error) {
            console.error(error);
        }
    }

    handleProductPriceChange(event) {
        this.SalesPrice = parseFloat(event.target.value) || 0;
        this.calculateTotals();
    }

    handleMultiplierChange(event) {
        this.multiplier = parseFloat(event.target.value) || 1;
        this.calculateTotals();
    }

    // Recalculate totals whenever data changes
    calculateTotals() {
        this.totalCostPrice = this.SalesPrice * this.multiplier;
        this.totalSalesPrice = this.totalCostPrice * 1.2;
        this.dailyMargin = (this.totalSalesPrice - this.totalCostPrice) / 21;
        this.monthlyMargin = this.dailyMargin * 21;
    }

    // Refresh data manually (optional, trigger this on button click or record change)
    refreshProductData() {
        return refreshApex(this.wiredOpportunityProductsResult);
    }
}