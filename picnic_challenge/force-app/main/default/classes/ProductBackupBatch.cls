/*******************************************************************************************
* @Name         ProductBackupBatch 
* @Author       Apurv Saxena <apurv93@gmail.com>
* @Date         01/04/2022
* @Group        Batch Class
* @Description  This batch class creates a back-up record for a product and store it into   
*				ProductBackup__c object. 
* @Assumptions  The product should always be active.
                The product should always have an ExternalId.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Apurv           01/04/2022          Initial Creation                                                      
*******************************************************************************************/

global class ProductBackupBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global String errormsgs ='';

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT id,Name,ExternalId FROM Product2 WHERE isActive = true AND ExternalId != null  ORDER BY ExternalId asc';

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Product2> scope){
        
        List<ProductBackup__c> productBackupList = new List<ProductBackup__c>();
        for(Product2 product : scope){
            ProductBackup__c prodBackupRec = new ProductBackup__c();
            prodBackupRec.Name = product.Name;
            prodBackupRec.Product_External_Id__c = product.ExternalId;
            productBackupList.add(prodBackupRec);
        }

        System.debug('productBackupList--->'+productBackupList);

        List<Database.saveResult> saveResult;
        if(productBackupList.size()>0){
            try{
                saveResult = Database.insert(productBackupList,false);
                System.debug('saveResult--->'+saveResult);
                for(Database.SaveResult sr : saveResult){
                    if(!sr.isSuccess()){
                        this.errormsgs += sr.getErrors()[0].getMessage() + '<br/>';
                    }
                }
                System.debug('errormsgs---->'+this.errormsgs);
            }catch(DMLexception ex){
                System.debug('Exception while inserting records--->'+ex.getMessage());
            }
        }     
    }

    global void finish(Database.BatchableContext BC){
        //Can add finish logic here
    }
}