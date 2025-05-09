import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAllObjectName from '@salesforce/apex/RecordTypeControl.getAllObjectName';
import getObjectApiNameFromLabel from '@salesforce/apex/RecordTypeControl.getObjectApiNameFromLabel';
import getRecordTypeNames from '@salesforce/apex/RecordTypeControl.getRecordTypeNames';
import saveTaskConfiguration from '@salesforce/apex/TaskConfigurationController.saveTaskConfiguration';
import createTask from '@salesforce/apex/TaskConfigurationController.createTask';
import getRecentAutoNumber from '@salesforce/apex/TaskConfigurationController.getRecentAutoNumber';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TaskConfig extends NavigationMixin(LightningElement) {
    isModalOpen = false;
    @track recordTypes = [];
    @track value;
    @track error;

    @track selectedObject = '';
    objectOptions = [];

    @track taskConfigName = '';
    @track last4Digits = '';

    @track toggleListView = false;

    @wire(getAllObjectName)
    wiredObjectNames({ error, data }) {
        if (data) {
            this.objectOptions = data.map((objectLabel) => ({
                label: objectLabel,
                value: objectLabel
            }));
        } else if (error) {
            console.error('Error fetching object names', error);
        }
    }

    @wire(getRecentAutoNumber)
    wiredAutoNumber({ error, data }) {
        if (data) {
            this.taskConfigName = data.Name; 

            let last4 = data.Name.slice(-4);
            let incrementedValue = (parseInt(last4, 10) + 1).toString();
            let updatedLast4Digits = incrementedValue.padStart(4, '0');
            this.last4Digits = `Task Configuration - ${updatedLast4Digits}`;
        } else if (error) {
            console.error('Error fetching recently created Task Configuration', error);
        }
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    handleNewClick() {
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.isModalOpen = false;
    }

    handleObjectSelection(event) {
        this.selectedObject = event.detail.value;
        this.fetchObjectApiNameAndRecordTypes(this.selectedObject);
    }

    fetchObjectApiNameAndRecordTypes(objectLabel) {
        getObjectApiNameFromLabel({ objectLabel })
            .then(apiName => {
                if (apiName) {
                    this.fetchRecordTypes(apiName);
                } else {
                    console.warn('No matching object found for the label:', objectLabel);
                    this.recordTypes = [];
                }
            })
            .catch(error => {
                console.error('Error fetching object API name', error);
            });
    }

    fetchRecordTypes(objectApiName) {
        getRecordTypeNames({ objectApiName })
            .then(data => {
                this.recordTypes = data.map(recordType => ({
                    label: recordType,
                    value: recordType
                }));
            })
            .catch(error => {
                console.error('Error fetching record types', error);
            });
    }

    handleToggleChange(event) {
        this.toggleListView = event.detail.checked;
    }

    handleSave() {
        const recordTypeName = this.recordTypes.find(rt => rt.value === this.value).label;
        const objectName = this.selectedObject;

        saveTaskConfiguration({ objectName, recordTypeName })
            .then((taskConfig) => {
                console.log('Task Configuration record created:', taskConfig);
                this.handleCloseModal();

                if (this.toggleListView) {
                    this.navigateToHomePage();
                } else {
                    this.navigateToRecordPage(taskConfig.Id);
                }

                return createTask({ taskConfigId: taskConfig.Id });
            })
            .then((task) => {
                console.log('Task record created:', task);
            })
            .catch((error) => {
                if (error.body.message.includes('A Record with the same Object and Record Type already exists')) {
                    this.showToast('Error', 'A Record with the same Object and Record Type is Found', 'error');
                } else {
                    console.error('Error:', error);
                    this.showToast('Error', error.body.message, 'error');
                }
            });
    }

    navigateToRecordPage(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Task_Configuration__c',
                actionName: 'view'
            }
        });
    }

    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task_Configuration__c',
                actionName: 'home'
            }
        });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}