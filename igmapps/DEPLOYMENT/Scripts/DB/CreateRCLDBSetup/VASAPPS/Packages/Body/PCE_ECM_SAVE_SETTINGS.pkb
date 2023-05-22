CREATE OR REPLACE PACKAGE BODY PCE_ECM_SAVE_SETTINGS AS
  
PROCEDURE PRE_GET_VIEW_INFO(  p_o_v_view_id    OUT     VARCHAR2
							                ,p_o_v_view_name OUT      VARCHAR2
                              ,p_o_v_default_flag OUT   VARCHAR2
							                ,p_o_v_view_type	  OUT    VARCHAR2
							                ,p_i_v_view_id	  IN    VARCHAR2	
							                , p_o_v_error    OUT     VARCHAR2
                              )
    IS
    BEGIN

        p_o_v_error := PCE_EUT_COMMON.G_V_SUCCESS_CD;

        SELECT PK_VIEW_ID , VIEW_NAME , DEFAULT_FLAG , VIEW_TYPE
		INTO   p_o_v_view_id , p_o_v_view_name , p_o_v_default_flag , p_o_v_view_type
		FROM  ZCV_VIEW
		WHERE PK_VIEW_ID = p_i_v_view_id;


    EXCEPTION
        WHEN OTHERS THEN
            p_o_v_error := SQLCODE || '~' || SQLERRM;
    END;

END PCE_ECM_SAVE_SETTINGS;
/* End of Package Body */

/
