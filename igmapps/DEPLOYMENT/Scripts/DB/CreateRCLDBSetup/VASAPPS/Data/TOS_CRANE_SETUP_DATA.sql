BEGIN
  INSERT INTO TOS_CRANE_SETUP
    (DN_PORT,
     DN_TERMINAL,
     CRANE_CODE,
     CRANE_TYPE,
     CRANE_NUMBER,
     FK_VENDOR_CODE,
     CRANE_DESCRIPTION,
     RECORD_STATUS,
     RECORD_ADD_USER,
     RECORD_ADD_DATE,
     RECORD_CHANGE_USER,
     RECORD_CHANGE_DATE)
    SELECT 'HKHKG',
           TQTERM,
           'S01',
           'S',
           1,
           NULL,
           'SHORE CRANE NO 1',
           'A',
           'WUTKIT1',
           SYSTIMESTAMP,
           'WUTKIT1',
           SYSTIMESTAMP
      FROM ITP130
     WHERE TQTERM LIKE 'HK%';

  INSERT INTO TOS_CRANE_SETUP
    (DN_PORT,
     DN_TERMINAL,
     CRANE_CODE,
     CRANE_TYPE,
     CRANE_NUMBER,
     FK_VENDOR_CODE,
     CRANE_DESCRIPTION,
     RECORD_STATUS,
     RECORD_ADD_USER,
     RECORD_ADD_DATE,
     RECORD_CHANGE_USER,
     RECORD_CHANGE_DATE)
    SELECT 'HKHKG',
           TQTERM,
           'S02',
           'S',
           2,
           NULL,
           'SHORE CRANE NO 2',
           'A',
           'WUTKIT1',
           SYSTIMESTAMP,
           'WUTKIT1',
           SYSTIMESTAMP
      FROM ITP130
     WHERE TQTERM LIKE 'HK%';

  INSERT INTO TOS_CRANE_SETUP
    (DN_PORT,
     DN_TERMINAL,
     CRANE_CODE,
     CRANE_TYPE,
     CRANE_NUMBER,
     FK_VENDOR_CODE,
     CRANE_DESCRIPTION,
     RECORD_STATUS,
     RECORD_ADD_USER,
     RECORD_ADD_DATE,
     RECORD_CHANGE_USER,
     RECORD_CHANGE_DATE)
    SELECT 'HKHKG',
           TQTERM,
           'H01',
           'H',
           1,
           NULL,
           'SHIP CRANE NO 1',
           'A',
           'WUTKIT1',
           SYSTIMESTAMP,
           'WUTKIT1',
           SYSTIMESTAMP
      FROM ITP130
     WHERE TQTERM LIKE 'HK%';

  INSERT INTO TOS_CRANE_SETUP
    (DN_PORT,
     DN_TERMINAL,
     CRANE_CODE,
     CRANE_TYPE,
     CRANE_NUMBER,
     FK_VENDOR_CODE,
     CRANE_DESCRIPTION,
     RECORD_STATUS,
     RECORD_ADD_USER,
     RECORD_ADD_DATE,
     RECORD_CHANGE_USER,
     RECORD_CHANGE_DATE)
    SELECT 'HKHKG',
           TQTERM,
           'H02',
           'H',
           2,
           NULL,
           'SHIP CRANE NO 2',
           'A',
           'WUTKIT1',
           SYSTIMESTAMP,
           'WUTKIT1',
           SYSTIMESTAMP
      FROM ITP130
     WHERE TQTERM LIKE 'HK%';

  INSERT INTO TOS_CRANE_SETUP
    (DN_PORT,
     DN_TERMINAL,
     CRANE_CODE,
     CRANE_TYPE,
     CRANE_NUMBER,
     FK_VENDOR_CODE,
     CRANE_DESCRIPTION,
     RECORD_STATUS,
     RECORD_ADD_USER,
     RECORD_ADD_DATE,
     RECORD_CHANGE_USER,
     RECORD_CHANGE_DATE)
    SELECT '*****',
           '*****',
           'S01',
           'S',
           1,
           NULL,
           'SHORE CRANE NO 1',
           'A',
           'WUTKIT1',
           SYSTIMESTAMP,
           'WUTKIT1',
           SYSTIMESTAMP
      FROM DUAL;

  INSERT INTO TOS_CRANE_SETUP
    (DN_PORT,
     DN_TERMINAL,
     CRANE_CODE,
     CRANE_TYPE,
     CRANE_NUMBER,
     FK_VENDOR_CODE,
     CRANE_DESCRIPTION,
     RECORD_STATUS,
     RECORD_ADD_USER,
     RECORD_ADD_DATE,
     RECORD_CHANGE_USER,
     RECORD_CHANGE_DATE)
    SELECT '*****',
           '*****',
           'S02',
           'S',
           2,
           NULL,
           'SHORE CRANE NO 2',
           'A',
           'WUTKIT1',
           SYSTIMESTAMP,
           'WUTKIT1',
           SYSTIMESTAMP
      FROM DUAL;

  INSERT INTO TOS_CRANE_SETUP
    (DN_PORT,
     DN_TERMINAL,
     CRANE_CODE,
     CRANE_TYPE,
     CRANE_NUMBER,
     FK_VENDOR_CODE,
     CRANE_DESCRIPTION,
     RECORD_STATUS,
     RECORD_ADD_USER,
     RECORD_ADD_DATE,
     RECORD_CHANGE_USER,
     RECORD_CHANGE_DATE)
    SELECT '*****',
           '*****',
           'H01',
           'H',
           1,
           NULL,
           'SHIP CRANE NO 1',
           'A',
           'WUTKIT1',
           SYSTIMESTAMP,
           'WUTKIT1',
           SYSTIMESTAMP
      FROM DUAL;

  INSERT INTO TOS_CRANE_SETUP
    (DN_PORT,
     DN_TERMINAL,
     CRANE_CODE,
     CRANE_TYPE,
     CRANE_NUMBER,
     FK_VENDOR_CODE,
     CRANE_DESCRIPTION,
     RECORD_STATUS,
     RECORD_ADD_USER,
     RECORD_ADD_DATE,
     RECORD_CHANGE_USER,
     RECORD_CHANGE_DATE)
    SELECT '*****',
           '*****',
           'H02',
           'H',
           2,
           NULL,
           'SHIP CRANE NO 2',
           'A',
           'WUTKIT1',
           SYSTIMESTAMP,
           'WUTKIT1',
           SYSTIMESTAMP
      FROM DUAL;

END;