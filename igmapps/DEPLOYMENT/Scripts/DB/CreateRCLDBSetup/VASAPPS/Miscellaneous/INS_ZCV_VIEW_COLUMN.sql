DECLARE PK_COLUMN_ID ZCV_VIEW_COLUMN.FK_SCREEN_COLUMN_ID%type;
FK_COLUMN_ID ZCV_VIEW_COLUMN.FK_SCREEN_COLUMN_ID%type;
BEGIN
     BEGIN 
       SELECT MAX(ZVC.PK_VIEW_COLUMN_ID) 
       INTO PK_COLUMN_ID
       FROM ZCV_VIEW_COLUMN ZVC;
       
       SELECT MAX(ZSC.PK_SCREEN_COLUMN_ID) 
       INTO FK_COLUMN_ID
       FROM ZCV_SCREEN_COLUMN ZSC;
    END;
      
    
    --VGM for ll
     PK_COLUMN_ID := PK_COLUMN_ID+1;
      FK_COLUMN_ID := FK_COLUMN_ID +1;
     INSERT INTO ZCV_VIEW_COLUMN
            (
                PK_VIEW_COLUMN_ID, 
                FK_VIEW_ID, 
                FK_SCREEN_COLUMN_ID, 
                COLUMN_SEQ, 
                DISPLAY_FLAG,
                 DISPLAY_WIDTH, 
                 RECORD_STATUS, 
                 RECORD_ADD_USER, 
                 RECORD_ADD_DATE,
                 RECORD_CHANGE_USER,
                 RECORD_CHANGE_DATE
            )
            (
                SELECT 
                PK_COLUMN_ID,
                14,
                FK_COLUMN_ID,
                17,
                'N',
                117,
                'A',
                'DEV_TEAM',
                SYSDATE,
                'DEV_TEAM',
                SYSDATE
                FROM
                DUAL
            );
     --Category for ll
     PK_COLUMN_ID := PK_COLUMN_ID+1;
      FK_COLUMN_ID := FK_COLUMN_ID +1;
     INSERT INTO ZCV_VIEW_COLUMN
            (
                PK_VIEW_COLUMN_ID, 
                FK_VIEW_ID, 
                FK_SCREEN_COLUMN_ID, 
                COLUMN_SEQ, 
                DISPLAY_FLAG,
                 DISPLAY_WIDTH, 
                 RECORD_STATUS, 
                 RECORD_ADD_USER, 
                 RECORD_ADD_DATE,
                 RECORD_CHANGE_USER,
                 RECORD_CHANGE_DATE
            )
            (
                SELECT 
                PK_COLUMN_ID,
                14,
                FK_COLUMN_ID,
                18,
                'Y',
                200,
                'A',
                'DEV_TEAM',
                SYSDATE,
                'DEV_TEAM',
                SYSDATE
                FROM
                DUAL
            );
            
            --VGM for dl
     PK_COLUMN_ID := PK_COLUMN_ID+1;
      FK_COLUMN_ID := FK_COLUMN_ID +1;
     INSERT INTO ZCV_VIEW_COLUMN
            (
                PK_VIEW_COLUMN_ID, 
                FK_VIEW_ID, 
                FK_SCREEN_COLUMN_ID, 
                COLUMN_SEQ, 
                DISPLAY_FLAG,
                 DISPLAY_WIDTH, 
                 RECORD_STATUS, 
                 RECORD_ADD_USER, 
                 RECORD_ADD_DATE,
                 RECORD_CHANGE_USER,
                 RECORD_CHANGE_DATE
            )
            (
                SELECT 
                PK_COLUMN_ID,
                3,
                FK_COLUMN_ID,
                17,
                'N',
                117,
                'A',
                'DEV_TEAM',
                SYSDATE,
                'DEV_TEAM',
                SYSDATE
                FROM
                DUAL
            );
     --Category for ll
     PK_COLUMN_ID := PK_COLUMN_ID+1;
      FK_COLUMN_ID := FK_COLUMN_ID +1;
     INSERT INTO ZCV_VIEW_COLUMN
            (
                PK_VIEW_COLUMN_ID, 
                FK_VIEW_ID, 
                FK_SCREEN_COLUMN_ID, 
                COLUMN_SEQ, 
                DISPLAY_FLAG,
                 DISPLAY_WIDTH, 
                 RECORD_STATUS, 
                 RECORD_ADD_USER, 
                 RECORD_ADD_DATE,
                 RECORD_CHANGE_USER,
                 RECORD_CHANGE_DATE
            )
            (
                SELECT 
                PK_COLUMN_ID,
                3,
                FK_COLUMN_ID,
                18,
                'Y',
                200,
                'A',
                'DEV_TEAM',
                SYSDATE,
                'DEV_TEAM',
                SYSDATE
                FROM
                DUAL
            );
            COMMIT;
END;