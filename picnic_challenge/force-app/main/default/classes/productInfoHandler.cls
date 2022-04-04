/*******************************************************************************************
* @Name         productInfoHandler 
* @Author       Apurv Saxena <apurv93@gmail.com>
* @Date         01/04/2022
* @Group        Apex Class
* @Description  This Apex class includes @AuraEnabled methods which is referred productInfo.js
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Apurv           01/04/2022          Initial Creation                                                      
*******************************************************************************************/

public with sharing class productInfoHandler {

    //This method accepts the externalId as parameter and returns the Product2 record with matching ExternalId.
    @AuraEnabled(cacheable=true)
    public static Product2 getRelatedProductInfo(String externalId){
        system.debug('externalId--->'+externalId);
        Product2 product = [SELECT Id, Name, ExternalId, CreatedDate, isActive FROM Product2 where ExternalId =: externalId LIMIT 1];
        system.debug('product--->'+product);
        if(product != null){
            return product;
        }

        return null;
    }
}