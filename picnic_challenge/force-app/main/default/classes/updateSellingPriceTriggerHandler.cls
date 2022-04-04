/*******************************************************************************************
* @Name         updateSellingPriceTriggerHandler
* @Author       Apurv Saxena <apurv93@gmail.com>
* @Date         01/04/2022
* @Group        Apex Class
* @Description  This is a trigger handler class for updateSellingPriceTrigger.
                Captures the list price of a product mentioned in its PriceBook Entry record
                and stores it in the Selling_Price__c field of the product backup record.
* @Assumptions  The list price from the Standard pricebook is taken into consideration.  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Apurv           01/04/2022          Initial Creation                                                      
*******************************************************************************************/

public with sharing class updateSellingPriceTriggerHandler {
    
    public void afterInserMethod(List<ProductBackup__c>  prodBackupNewList){
        
        System.debug('Inside trigger--->');
        Set<String> externalIdSet = new Set<String>();
        map<String,Decimal> extIdToUnitPriceMap = new Map<String,Decimal>();
        
        for(ProductBackup__c prdbck : prodBackupNewList){
            if(prdbck.Product_External_Id__c != null){
                externalIdSet.add(prdbck.Product_External_Id__c);   
            }
            
        }

        System.debug('externalIdSet--->'+externalIdSet);
        for(PricebookEntry pbe : [SELECT IsActive, UnitPrice,Pricebook2.IsStandard, Product2Id, Product2.Name, 
                                    Product2.ExternalId, Product2.IsActive FROM PricebookEntry 
                                    WHERE Pricebook2.IsStandard = true AND Product2.ExternalId in : externalIdSet]){

                                        extIdToUnitPriceMap.put(pbe.Product2.ExternalId, pbe.UnitPrice);                            

        }
        system.debug('extIdToUnitPriceMap--->'+extIdToUnitPriceMap);
    
        for(ProductBackup__c p : prodBackupNewList){

            if(p.Product_External_Id__c != null && extIdToUnitPriceMap != null && extIdToUnitPriceMap.containsKey(p.Product_External_Id__c)){
                p.Selling_Price__c = extIdToUnitPriceMap.get(p.Product_External_Id__c);
            }

        }
    }
}