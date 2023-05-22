Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (51,'MC001','Booking is already available in overshipped tab with loaded status.','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (52,'MC002','Booking is already available in overlanded tab with discharge status.','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (53,'MC003','Error occurred in raise enotice edi package.','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (54,'MC004','Booking not found in Booked tab','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (55,'MC005','Load list not found in load list header table','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (56,'MC006','Service,vessel,voyage not found in ITP063 table.','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (57,'MC007','Next discharge list not found for this load list.','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (58,'MC008','Discharge list not found in discharge list header table','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (59,'MC009','Previous load list not found for this discharge list.','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (60,'MC010','Synchronization equipment update failed.','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (61,'MC011','Error occurred in LL-DL matching update','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (62,'MC012','Error occurred in deleting record from TOS_TMP_AUTOMATCH_LAUNCH.','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (63,'MC013','Error occurred in automatch.','A','EDI',SYSDATE,'EDI',SYSDATE);
Insert into tos_error_mst(PK_ERROR_ID,ERROR_CODE,ERROR_MESSAGE,RECORD_STATUS,RECORD_ADD_USER,RECORD_ADD_DATE,RECORD_CHANGE_USER,RECORD_CHANGE_DATE) values  (64,'MC014','Error occurred in autoexpand','A','EDI',SYSDATE,'EDI',SYSDATE);

commit;

/