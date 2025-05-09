import { LightningElement, track } from 'lwc';
 
export default class opoPro extends LightningElement {
    @track selectedProduct;
    @track productOptions = [
        { label: 'Consultant', value: 'Consultant' },
        { label: 'Analyst', value: 'Analyst' },
        { label: 'Senior Manager', value: 'Senior_Manager' },
        { label: 'Manager', value: 'Manager' },
        { label: 'Director', value: 'Director' }
    ];
 
    @track totalCost = 0;
    @track totalSalesPrice = 0;
    @track dailyMargin = 0;
    @track monthlyMargin = 0;
    @track perDayCost = 0;
    @track perDaySalesPrice = 0;
 
    handleProductChange(event) {
        this.selectedProduct = event.detail.value;
        this.calculateMetrics();
    }
 
    calculateMetrics() {
        const productDetails = {
            Consultant: { cost: 35000, salesPrice: 55000 },
            Analyst: { cost: 50000, salesPrice: 70000 },
            Senior_Manager: { cost: 70000, salesPrice: 100000 },
            Manager: { cost: 60000, salesPrice: 90000 },
            Director: { cost: 100000, salesPrice: 150000 }
        };
 
        const product = productDetails[this.selectedProduct];
        if (product) {
            this.totalCost = product.cost;
            this.totalSalesPrice = product.salesPrice;
            this.perDayCost = product.cost / 21;
            this.perDaySalesPrice = product.salesPrice / 21;
            this.dailyMargin = this.perDaySalesPrice - this.perDayCost;
            this.monthlyMargin = this.dailyMargin * 21;
        }
    }
}