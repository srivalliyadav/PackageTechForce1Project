import { LightningElement, track, wire } from 'lwc';
import getAllObjectNames from '@salesforce/apex/TaskConfigController.getAllObjectNames';
import createTaskConfig from '@salesforce/apex/TaskConfigController.createTaskConfig';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class TaskConfigForm extends LightningElement {
    @track taskName = ''; 
    @track selectedObject = ''; 
    @track objectOptions = []; 


    @wire(getAllObjectNames)
    wiredObjectNames({ error, data }) {
        if (data) {
            this.objectOptions = data.map(objectName => ({
                label: objectName,
                value: objectName
            }));
        } else if (error) {
            console.error('Error fetching object names:', error);
            this.showToast('Error', 'There was an issue fetching the object names.', 'error');
        }
    }

    handleTaskNameChange(event) {
        this.taskName = event.target.value;
    }

    handleObjectChange(event) {
        this.selectedObject = event.target.value;
    }

    handleSave() {
        if (!this.taskName || !this.selectedObject) {
            this.showToast('Error', 'Please fill in both the Task Name and Object.', 'error');
            return;
        }

        createTaskConfig({ taskName: this.taskName, selectedObject: this.selectedObject })
            .then(result => {
                this.showToast('Success', 'Task Config record created successfully!', 'success');
                this.taskName = '';
                this.selectedObject = '';
            })
            .catch(error => {
                this.showToast('Error', 'There was an error creating the Task Config record: ' + error.body.message, 'error');
                console.error('Error creating Task Config record', error);
            });
    }

    handleCancel() {
        this.taskName = '';
        this.selectedObject = '';
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}