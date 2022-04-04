import { LightningElement,api,track,wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getRelatedProductInfo from '@salesforce/apex/productInfoHandler.getRelatedProductInfo';
import NAME_FIELD from '@salesforce/schema/ProductBackup__c.Name';
import PRODUCTEXTERNALID_FIELD from '@salesforce/schema/ProductBackup__c.Product_External_Id__c';
import SELLINGPRICE_FIELD from '@salesforce/schema/ProductBackup__c.Selling_Price__c';

const fields = [NAME_FIELD, PRODUCTEXTERNALID_FIELD, SELLINGPRICE_FIELD];

export default class ProductInfo extends LightningElement {

    @api recordId;
    @track error;
    @track prodData
    name;
    prodExtId;
    sellingPrice;
    isActive;
    createdDate;

    @wire(getRecord, { recordId: '$recordId', fields })
    productBackup({error, data}){
        if(error){
            
        }else if(data){
            console.log('data', JSON.parse(JSON.stringify(data)));
            this.name = getFieldValue(data, NAME_FIELD);
            this.prodExtId = getFieldValue(data, PRODUCTEXTERNALID_FIELD);
            this.sellingPrice = getFieldValue(data, SELLINGPRICE_FIELD);
            console.log('prodExtId'+this.prodExtId);
            this.getProdInfo();
        }
    }
    
    getProdInfo(){
        getRelatedProductInfo({ externalId: this.prodExtId})
        .then(result => {
            this.prodData = result;
            this.createdDate = result.CreatedDate;
            if(result.IsActive === true){
                this.isActive = 'Yes';
            }else{
                this.isActive = 'No';
            }
            console.log('result--->'+JSON.stringify(this.prodData));
            console.log('createdDate--->'+this.createdDate);
            console.log('isActive--->'+this.isActive);
        })
        .catch(error => {
            this.error = error;
            console.log('error--->'+JSON.stringify(this.error));
        })
    }
    
}