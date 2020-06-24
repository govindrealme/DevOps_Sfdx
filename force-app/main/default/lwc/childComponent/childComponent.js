import { LightningElement, api } from 'lwc';

export default class ChildComponent extends LightningElement {
    @api contact;

    handleEvent(){
        const eventS = new CustomEvent('Sample');
        this.dispatchEvent(eventS);
    }
}