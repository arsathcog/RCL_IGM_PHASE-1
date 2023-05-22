CREATE OR REPLACE PROCEDURE PRE_TOS_COMMON_ERROR_LOG(
         p_parameter_string              IN VARCHAR2
       , p_prog_type                     IN VARCHAR2
       , p_opeartion_type                IN VARCHAR2
       , p_error_msg                     IN VARCHAR2
       , p_record_status                 IN VARCHAR2
	   , p_record_filter				 IN VARCHAR2 -- added by vikas on 19.10.2011
	   , p_record_table                  IN VARCHAR2 -- added by vikas on 19.10.2011
       , p_record_add_user               IN VARCHAR2
       , p_record_add_date               IN TIMESTAMP
       , p_record_change_user            IN VARCHAR2
       , p_record_change_date            IN TIMESTAMP
    ) AS
    BEGIN
            INSERT INTO TOS_SYNC_ERROR_LOG(
		        PK_SYNC_ERR_LOG_ID
                , PARAMETER_STRING
                , PROG_TYPE
                , OPEARTION_TYPE
                , ERROR_MSG
                , RERUN_STATUS
                , RECORD_STATUS
				, RECORD_FILTER          -- added by vikas on 19.10.2011
				, RECORD_TABLE           -- added by vikas on 19.10.2011
                , RECORD_ADD_USER
                , RECORD_ADD_DATE
                , RECORD_CHANGE_USER
                , RECORD_CHANGE_DATE
			)
            VALUES (
				SE_SEL01.NEXTVAL
				, SUBSTR(p_parameter_string,1,500)
				, p_prog_type
				, p_opeartion_type
				, SUBSTR(p_error_msg,1,100)
				, 0                     --bY DEFAULT IT WILL BE ZERO
				, p_record_status
				, p_record_filter       -- added by vikas on 19.10.2011
				, p_record_table        -- added by vikas on 19.10.2011
				, p_record_add_user
				, p_record_add_date
				, p_record_add_user
				, p_record_add_date
			);

    END PRE_TOS_COMMON_ERROR_LOG;

 /