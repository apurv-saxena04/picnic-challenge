/*******************************************************************************************
* @Name         updateSellingPriceTrigger 
* @Author       Apurv Saxena <apurv93@gmail.com>
* @Date         01/04/2022
* @Group        Trigger
* @Description  This triggers runs on Before Insert context for a ProductBackup record.
                Logic remains in its handler class.   
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Apurv           01/04/2022          Initial Creation                                                      
*******************************************************************************************/
trigger updateSellingPriceTrigger on ProductBackup__c (before insert) {

    updateSellingPriceTriggerHandler handler = new updateSellingPriceTriggerHandler();

    if(Trigger.isInsert){
        handler.afterInserMethod(Trigger.new);
    }
}