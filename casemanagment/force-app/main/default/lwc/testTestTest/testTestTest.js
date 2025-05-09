import { LightningElement} from 'lwc';

export default class TestTestTest extends LightningElement {
    
    close(){
        setTimeout(() => {
            window.history.back();
        }, 1000); // Timeout value is in milliseconds (1000ms = 1 second)
    }
    
}