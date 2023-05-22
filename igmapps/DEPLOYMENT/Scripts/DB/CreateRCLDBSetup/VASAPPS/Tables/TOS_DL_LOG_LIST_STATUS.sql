CREATE TABLE VASAPPS.TOS_DL_LOG_LIST_STATUS(
      DISCAHRGE_LIST_ID NUMBER NOT NULL
    , FK_SERVICE VARCHAR2(5) NOT NULL
    , FK_VESSEL VARCHAR2(5) NOT NULL
    , FK_VOYAGE VARCHAR2(10) NOT NULL
    , OLD_DISCHARGE_LIST_STATUS VARCHAR2(2) NOT NULL
    , NEW_DISCHARGE_LIST_STATUS VARCHAR2(2) NOT NULL
    , NEW_RECORD_CHANGE_USER VARCHAR2(10) NOT NULL
    , NEW_RECORD_CHANGE_DATE TIMESTAMP(6) NOT NULL
    , RECORD_ADD_DATE TIMESTAMP(6) NOT NULL
);

/