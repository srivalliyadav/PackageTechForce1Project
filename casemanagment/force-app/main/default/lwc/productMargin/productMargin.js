import { LightningElement, track, wire } from 'lwc';
import getProductById from '@salesforce/apex/ProductMarginController.getProductById';
import calculateMargins from '@salesforce/apex/ProductMarginController.calculateMargins';
    
    export default class ProductMargin extends LightningElement {
        @track productId = ''; // Here Product Id to fetch product details
        @track productName = '';
        @track unitCost = 0;
        @track unitSalesPrice = 0;
        @track quantity = 1; 
        @track perDayCost = 0;
        @track perDaySalesPrice = 0;
        @track totalCost = 0;
        @track totalSalesPrice = 0;
        @track dailyMargin = 0;
        @track monthlyMargin = 0;
    
        handleInputChange(event) {
            const field = event.target.dataset.id;
            this[field] = event.target.value;
        }
    
        // Here iam Fetch product details using product Id
        handleFetchProduct() {
            getProductById({ productId: this.productId })
                .then(result => {
                    this.productName = result.Name;
                    this.unitCost = result.StandardPrice;
                    this.unitSalesPrice = result.StandardPrice; // Here Just Assuming unit cost = unit sales price here
                    this.calculateMargins();
                })
                .catch(error => {
                    console.error('Error fetching product:', error);
                });
        }
    
        // Here iam Calling  Apex method to calculate margins based on product data
        calculateMargins() {
            calculateMargins({
                unitCost: this.unitCost,
                quantity: this.quantity,
                unitSalesPrice: this.unitSalesPrice
            })
                .then(result => {
                    this.perDayCost = result.perDayCost;
                    this.perDaySalesPrice = result.perDaySalesPrice;
                    this.totalCost = result.totalCost;
                    this.totalSalesPrice = result.totalSalesPrice;
                    this.dailyMargin = result.dailyMargin;
                    this.monthlyMargin = result.monthlyMargin;
                })
                .catch(error => {
                    console.error('Error calculating margins:', error);
                });
        }
    }