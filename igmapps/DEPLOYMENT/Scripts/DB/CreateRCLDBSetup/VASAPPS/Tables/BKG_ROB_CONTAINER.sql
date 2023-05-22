/*** SheetName = 11 ***/
/*** Table Creation script for ROB Container ***/
CREATE TABLE BKG_ROB_CONTAINER (
PK_ROB_CONTAINER_ID               INTEGER           NOT NULL, 
FK_RETURN_SHIPMENT_ID             INTEGER          , 
CONTAINER_NUMBER                  VARCHAR2(12)      NOT NULL, 
FK_ARRIVAL_BOOKING_NUMBER         VARCHAR2(17)      NOT NULL, 
FK_DEPARTURE_BOOKING_NUMBER       VARCHAR2(17)      NOT NULL, 
STOWAGE_POSITION                  VARCHAR2(7)      , 
RECORD_STATUS                     VARCHAR2(1)       NOT NULL, 
RECORD_ADD_USER                   VARCHAR2(10)      NOT NULL, 
RECORD_ADD_DATE                   TIMESTAMP         NOT NULL, 
RECORD_CHANGE_USER                VARCHAR2(10)      NOT NULL, 
RECORD_CHANGE_DATE                TIMESTAMP         NOT NULL
)
/
 
comment on TABLE BKG_ROB_CONTAINER is 'ROB Container - ROB Container' ;
comment on column BKG_ROB_CONTAINER.PK_ROB_CONTAINER_ID is 'PK for Return Shipment' ;
comment on column BKG_ROB_CONTAINER.FK_RETURN_SHIPMENT_ID is 'Return Shipment ID' ;
comment on column BKG_ROB_CONTAINER.CONTAINER_NUMBER is 'Container No.' ;
comment on column BKG_ROB_CONTAINER.FK_ARRIVAL_BOOKING_NUMBER is 'Arrival Booking Number' ;
comment on column BKG_ROB_CONTAINER.FK_DEPARTURE_BOOKING_NUMBER is 'Departure Booking Number' ;
comment on column BKG_ROB_CONTAINER.STOWAGE_POSITION is 'Stowage Position' ;
comment on column BKG_ROB_CONTAINER.RECORD_STATUS is 'Record Status' ;
comment on column BKG_ROB_CONTAINER.RECORD_ADD_USER is 'Create By' ;
comment on column BKG_ROB_CONTAINER.RECORD_ADD_DATE is 'Create Date Time' ;
comment on column BKG_ROB_CONTAINER.RECORD_CHANGE_USER is 'Update By' ;
comment on column BKG_ROB_CONTAINER.RECORD_CHANGE_DATE is 'Update Date Time' ;
/*** P.Key PKR_BKG_RCZ01 Creation script for ROB Container ***/
ALTER TABLE BKG_ROB_CONTAINER ADD CONSTRAINT PKR_BKG_RCZ01 PRIMARY KEY ( 
PK_ROB_CONTAINER_ID)
/
 
