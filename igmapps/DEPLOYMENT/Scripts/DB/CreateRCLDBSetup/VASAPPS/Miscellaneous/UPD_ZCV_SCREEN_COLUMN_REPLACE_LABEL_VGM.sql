-- Update Load and Discharge List Maintenance screen (overship tab,Restore tab)
MERGE INTO ZCV_SCREEN_COLUMN TAB 
USING (
SELECT  ZSC.PK_SCREEN_COLUMN_ID
                ,ZSC.COLUMN_ID          COLUMN_ID
               ,ZSC.COLUMN_DESC        COLUMN_NAME
               ,ZVC.DISPLAY_WIDTH      COLUMN_WIDTH
               ,ZSC.DEFAULT_POSITION   DEFAULT_POSITION
               ,ZVC.COLUMN_SEQ         SHOW_POSITION
               ,ZVC.DISPLAY_FLAG       IS_VISIBLE
               ,ZSC.HIDEABLE           IS_HIDEABLE
               ,ZVC.FK_VIEW_ID  
        FROM  ZCV_SCREEN_COLUMN ZSC,
              ZCV_VIEW_COLUMN   ZVC
        WHERE ZSC.PK_SCREEN_COLUMN_ID = ZVC.FK_SCREEN_COLUMN_ID
         AND   ZVC.FK_VIEW_ID          IN ( 4,5,15,16)
        AND   ZVC.RECORD_STATUS       = 'A'  -- Active
        AND  ZSC.COLUMN_ID = 'weight'
        ORDER BY ZVC.COLUMN_SEQ
        ) SCR
ON (  TAB.PK_SCREEN_COLUMN_ID = SCR.PK_SCREEN_COLUMN_ID)
WHEN MATCHED THEN UPDATE
SET TAB.COLUMN_ID = 'vgm'
,TAB.COLUMN_DESC = 'VGM';

COMMIT;

