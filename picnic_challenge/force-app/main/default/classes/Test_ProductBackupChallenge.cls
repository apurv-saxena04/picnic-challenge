/*******************************************************************************************
* @Name         Test_ProductBackupChallenge 
* @Author       Apurv Saxena <apurv93@gmail.com>
* @Date         01/04/2022
* @Group        Test Class
* @Description  Test class which covers all the apex classes,trigger, batch apex created for
				this challenge.
* @Apex Covered ProductBackupBatch, scheduleProductBackupBatch, updateSellingPriceTriggerHandler
				updateSellingPriceTrigger and productInfoHandler.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Apurv           01/04/2022          Initial Creation                                                      
*******************************************************************************************/

@isTest
public class Test_ProductBackupChallenge {
	
    @testSetup static void setup() {
        
        //Insert Product2 Record
        Product2 pro = new Product2(Name = 'Laptop X200', Family = 'Hardware', isActive=true, ExternalId='1234567891012');
		Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
		Pricebook2 standardPricebook = new Pricebook2(
    	Id = Test.getStandardPricebookId(),
    	IsActive = true
		);
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
		update standardPricebook;
 
		//Query for the Pricebook2 record, to check IsStandard field
		standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
		//It should return true
		System.assertEquals(true, standardPricebook.IsStandard);
 
 
		//Create the PricebookEntry
		PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
        );
		Insert pbe;
    }
    
    @isTest static void testProductBackupBatch() {
        test.startTest();
        scheduleProductBackupBatch m = new scheduleProductBackupBatch();
		String crn1 = '0 41 9 * * ?';
		String crn2 = '0 43 23 * * ?';
		system.schedule('Schedule job 1', crn1, m);
		system.schedule('Schedule job 2', crn2, m);
		test.stopTest();        
    }
    
    @isTest static void testProductInfoHandler() {
        Product2 prodObj = [SELECT id,Name,ExternalId FROM Product2 WHERE ExternalId = '1234567891012' LIMIT 1];
        test.startTest();
        productInfoHandler.getRelatedProductInfo(prodObj.ExternalId);
		test.stopTest();        
    }
}