/*** SheetName = 10 ***/
/*** Table Creation script for Return shipment ***/
CREATE TABLE BKG_RETURN_SHIPMENT (
PK_RETURN_SHIPMENT_ID             VARCHAR2(17)      NOT NULL, 
FK_RETURN_BOOKING                 VARCHAR2(17)      NOT NULL, 
FK_RETURN_BL                      VARCHAR2(17)      NOT NULL, 
RETURN_REASON_CODE                VARCHAR2(3)       NOT NULL, 
RETURN_REASON_DESC                VARCHAR2(254)    , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE BKG_RETURN_SHIPMENT is 'Return shipment - Return shipment' ;
comment on column BKG_RETURN_SHIPMENT.PK_RETURN_SHIPMENT_ID is 'PK for Return Shipment' ;
comment on column BKG_RETURN_SHIPMENT.FK_RETURN_BOOKING is 'Booking No' ;
comment on column BKG_RETURN_SHIPMENT.FK_RETURN_BL is 'BL No.' ;
comment on column BKG_RETURN_SHIPMENT.RETURN_REASON_CODE is 'Return Reason' ;
comment on column BKG_RETURN_SHIPMENT.RETURN_REASON_DESC is 'Return Description' ;
comment on column BKG_RETURN_SHIPMENT.RECORD_STATUS is 'Record Status' ;
comment on column BKG_RETURN_SHIPMENT.RECORD_ADD_USER is 'Create By' ;
comment on column BKG_RETURN_SHIPMENT.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column BKG_RETURN_SHIPMENT.RECORD_CHANGE_USER is 'Update By' ;
comment on column BKG_RETURN_SHIPMENT.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_BKG_RSZ01 Creation script for Return shipment ***/
ALTER TABLE BKG_RETURN_SHIPMENT ADD CONSTRAINT PKR_BKG_RSZ01 PRIMARY KEY ( 
PK_RETURN_SHIPMENT_ID)
/
 
