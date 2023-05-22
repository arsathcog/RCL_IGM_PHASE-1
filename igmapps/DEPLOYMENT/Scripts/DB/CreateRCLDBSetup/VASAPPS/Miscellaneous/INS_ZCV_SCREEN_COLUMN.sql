DECLARE PK_COLUMN_ID ZCV_VIEW_COLUMN.FK_SCREEN_COLUMN_ID%type;
BEGIN
     BEGIN
       SELECT MAX(ZSC.PK_SCREEN_COLUMN_ID) 
       INTO PK_COLUMN_ID
       FROM ZCV_SCREEN_COLUMN ZSC;
    END;
    --VGM for ll
    PK_COLUMN_ID := PK_COLUMN_ID + 1;
    INSERT INTO ZCV_SCREEN_COLUMN ZSC
    (
    PK_SCREEN_COLUMN_ID, 
    FK_SCREEN_ID, 
    COLUMN_ID,
    COLUMN_DESC, 
    HIDEABLE, 
    EDITABLE, 
    DATA_TYPE, 
    RECORD_ADD_USER, 
    RECORD_ADD_DATE, 
    DEFAULT_POSITION
    )
    VALUES
    ( PK_COLUMN_ID,
     7,
     'vmg',
     'VGM',
     'Y',
     'N',
     'C',
     'DEV_TEAM',
     SYSDATE,
     80
     );   

      --Category for ll
    PK_COLUMN_ID := PK_COLUMN_ID + 1;
    INSERT INTO ZCV_SCREEN_COLUMN ZSC
    (
    PK_SCREEN_COLUMN_ID, 
    FK_SCREEN_ID, 
    COLUMN_ID,
    COLUMN_DESC, 
    HIDEABLE, 
    EDITABLE, 
    DATA_TYPE, 
    RECORD_ADD_USER, 
    RECORD_ADD_DATE, 
    DEFAULT_POSITION
    )
    VALUES
    ( PK_COLUMN_ID,
     7,
     'category',
     'Category',
     'Y',
     'N',
     'C',
     'DEV_TEAM',
     SYSDATE,
     80
     );
     
     
     --VGM for dl
    PK_COLUMN_ID := PK_COLUMN_ID + 1;
    INSERT INTO ZCV_SCREEN_COLUMN ZSC
    (
    PK_SCREEN_COLUMN_ID, 
    FK_SCREEN_ID, 
    COLUMN_ID,
    COLUMN_DESC, 
    HIDEABLE, 
    EDITABLE, 
    DATA_TYPE, 
    RECORD_ADD_USER, 
    RECORD_ADD_DATE, 
    DEFAULT_POSITION
    )
    VALUES
    ( PK_COLUMN_ID,
     2,
     'vmg',
     'VGM',
     'Y',
     'N',
     'C',
     'DEV_TEAM',
     SYSDATE,
     80
     );   

      --Category for dl
    PK_COLUMN_ID := PK_COLUMN_ID + 1;
    INSERT INTO ZCV_SCREEN_COLUMN ZSC
    (
    PK_SCREEN_COLUMN_ID, 
    FK_SCREEN_ID, 
    COLUMN_ID,
    COLUMN_DESC, 
    HIDEABLE, 
    EDITABLE, 
    DATA_TYPE, 
    RECORD_ADD_USER, 
    RECORD_ADD_DATE, 
    DEFAULT_POSITION
    )
    VALUES
    ( PK_COLUMN_ID,
     2,
     'category',
     'Category',
     'Y',
     'N',
     'C',
     'DEV_TEAM',
     SYSDATE,
     80
     );
     COMMIT;
END;