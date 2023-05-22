CREATE OR REPLACE PACKAGE "PCR_TOS_SYNC_LL_DL_BOOKING" is

  -- Author  : WACCHO1
  -- Created : 16/12/2015 2:11:33 PM
  -- Purpose : To flow data from booking to ezll/ezdl


  PROCEDURE PRR_TOS_LL_DL_BOOKING;
  
  PROCEDURE PRR_TOS_LL_DL_BKP009;
  
  PROCEDURE PRR_TOS_LL_DL_BKG_DG_DTL; 
  
  PROCEDURE PRR_TOS_LL_DL_ROUTING;
  
  PROCEDURE PRR_TOS_UPD_STATUS (P_I_V_BOOKING_NO     VARCHAR2 
                               ,P_I_V_SEQ            INTEGER
                               ,P_I_V_STATUS         VARCHAR2 
                               ,P_I_V_ERR_DESC       VARCHAR2 
                               ,P_I_V_SOURCE         VARCHAR2  
                               );
                               

end PCR_TOS_SYNC_LL_DL_BOOKING;

 
