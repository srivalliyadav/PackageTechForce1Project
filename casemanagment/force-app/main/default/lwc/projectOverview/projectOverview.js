/*import { LightningElement, wire, track } from 'lwc';
import getProjects from '@salesforce/apex/getProjects.ProjectController';
 
export default class ProjectOverview extends LightningElement {
    @track projects;
    @track error;
 
    @wire(getProjects)
    wiredProjects({ error, data }) {
        if (data) {
            this.projects = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.projects = undefined;
        }
    }
 
    get columns() {
        return [
            { label: 'Project Name', fieldName: 'Name' },
            { label: 'Start Date', fieldName: 'Project_Start_Date__c', type: 'date' },
            { label: 'End Date', fieldName: 'Project_End_Date__c', type: 'date' }
           
        ];
    }
}*/
import { LightningElement, track, wire } from 'lwc';
import getProjects from '@salesforce/apex/ProjectController.getProjects';

export default class ProjectList extends LightningElement {
    @track projects;
    @track error;
    @track selectedFilter = 'All'; 
    filterOptions = [
        { label: 'All', value: 'All' },
        { label: 'Billable', value: 'Billable' },
        { label: 'Non-Billable', value: 'Non-Billable' }
    ];

    
    columns = [
        { label: 'Project Name', fieldName: 'Name' },
        { label: 'Account Name', fieldName: 'Account__r.Name' }
  
    ];

    @wire(getProjects, { filterType: '$selectedFilter' })
    wiredProjects({ error, data }) {
        if (data) {
            this.projects = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.projects = undefined;
        }
    }

    
    handleFilterChange(event) {
        this.selectedFilter = event.detail.value; 
    }
}