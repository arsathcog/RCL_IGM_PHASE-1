INSERT INTO VASAPPS.VCM_CONFIG_MST
  (CONFIG_TYP
  ,CONFIG_CD
  ,CONFIG_VALUE
  ,CONFIG_DESC
  ,SORT_ORDER
  ,MAX_SIZE_CONFIG_VALUE
  ,FIX_LENGTH
  ,DISPLAY_FLAG
  ,STATUS
  ,CREATE_BY
  ,CREATE_DT
  ,UPD_BY
  ,UPD_DT
  ,MODULE
  ,USAGE_REMARK)
VALUES
  ('EZDL_EMS_VAL'
  ,'EZDL_VSL_CHECK'
  ,'Y'
  ,'Y=Validate Vessel in EZDL only,N=Validate SVVD in EZDL'
  ,1
  ,99
  ,2
  ,'Y'
  ,'A'
  ,'WUTKIT1'
  ,SYSTIMESTAMP
  ,'WUTKIT1'
  ,SYSTIMESTAMP
  ,'TOS'
  ,'Y=Validate Vessel in EZDL only,N=Validate SVVD in EZDL');