CREATE TABLE EDI_ST_EQUIPMENT_TMP
(
  EDI_ETD_UID         NUMBER(16)                NOT NULL,
  RECORD_STATUS       VARCHAR2(1 BYTE)          NOT NULL,
  RECORD_CHANGE_USER  VARCHAR2(10 BYTE),
  RECORD_CHANGE_DATE  DATE
)