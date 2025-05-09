import { LightningElement, wire, api, track } from 'lwc';
import getOpportunity from '@salesforce/apex/OpportunityProductController.getOpportunity';
import getOpportunityFields from '@salesforce/apex/OpportunityProductController.getOpportunityFields';


export default class OpportunityProductDisplay extends LightningElement {
    @api recordId;
    @track opportunities;
    @track columns = [];
    error;

    
    @wire(getOpportunityFields)
    wiredFields({ error, data }) {
        if (data) {
            this.columns = data.map(field => ({
                label: field.label,
                fieldName: field.fieldName,
                type: field.type
            }));
        } else if (error) {
            this.error = error;
        }
    }

    
    @wire(getOpportunity, { recordId: '$recordId' })
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunities = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.opportunities = undefined;
        }
    }
}