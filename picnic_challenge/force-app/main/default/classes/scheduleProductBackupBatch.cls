/*******************************************************************************************
* @Name         scheduleProductBackupBatch
* @Author       Apurv Saxena <apurv93@gmail.com>
* @Date         01/04/2022
* @Group        Apex Scheduler
* @Description  This is an apex scheduler class which executes ProductBackupBatch class
                It is triggered from anonynms block at 09:41 am and 23:43 pm daily. 
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Apurv           01/04/2022          Initial Creation                                                      
*******************************************************************************************/

global class scheduleProductBackupBatch implements Schedulable{
    
    global void execute(SchedulableContext sc){
        ProductBackupBatch batchCls = new ProductBackupBatch();
        database.executeBatch(batchCls);
    }
}