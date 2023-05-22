-- Suspend Ready for Invoice and Alert Require status
UPDATE VCM_CONFIG_MST
   SET STATUS = 'S'
 WHERE CONFIG_TYP IN ('DL_STS', 'LL_LLS')
   AND CONFIG_CD IN (5, 20)
   AND STATUS = 'A';

-- Change Loading Complete to Pre Loading
UPDATE VCM_CONFIG_MST
   SET CONFIG_DESC = 'Pre Loading'
 WHERE CONFIG_TYP IN ('DL_STS', 'LL_LLS')
   AND CONFIG_VALUE = 'LLS02'
   AND STATUS = 'A';
-- Change Work Complete to Loading Complete
UPDATE VCM_CONFIG_MST
   SET CONFIG_DESC = 'Loading Complete'
 WHERE CONFIG_TYP IN ('DL_STS', 'LL_LLS')
   AND CONFIG_VALUE = 'LLS04'
   AND STATUS = 'A';   
   
-- Change Discharge Complete to Pre Discharge
UPDATE VCM_CONFIG_MST
   SET CONFIG_DESC = 'Pre Discharge'
 WHERE CONFIG_TYP IN ('DL_STS', 'LL_LLS')
   AND CONFIG_VALUE = 'DLSTS03'
   AND STATUS = 'A';
-- Change Work Complete to Loading Complete
UPDATE VCM_CONFIG_MST
   SET CONFIG_DESC = 'Discharge Complete'
 WHERE CONFIG_TYP IN ('DL_STS', 'LL_LLS')
   AND CONFIG_VALUE = 'DLSTS05'
   AND STATUS = 'A';    