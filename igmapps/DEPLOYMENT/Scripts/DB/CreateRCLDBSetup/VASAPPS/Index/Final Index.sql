Create index IDXE_BLZ01_01 on TOS_LL_BOOKED_LOADING(FK_LOAD_LIST_ID);
Create index IDXE_BLZ01_02 on TOS_LL_BOOKED_LOADING(DN_EQUIPMENT_NO,RECORD_STATUS); 
Create index IDXE_BLZ01_03 on TOS_LL_BOOKED_LOADING(FK_BOOKING_NO,FK_BKG_EQUIPM_DTL,RECORD_STATUS); 

Create index IDXE_BDZ01_01 on TOS_DL_BOOKED_DISCHARGE(FK_DISCHARGE_LIST_ID); 
Create index IDXE_BDZ01_02 on TOS_DL_BOOKED_DISCHARGE(FK_BOOKING_NO,FK_BKG_EQUIPM_DTL,RECORD_STATUS); 
Create index IDXE_BDZ01_03 on TOS_DL_BOOKED_DISCHARGE(DN_EQUIPMENT_NO,RECORD_STATUS); 

Create index IDX_TOS_ONBOARD_LIST_EZL on TOS_ONBOARD_LIST(POL_SERVICE,POL_VESSEL,POL_VOYAGE,POD,POD_TERMINAL,POL,POL_TERMINAL,BOOKING_NO,CONTAINER_NO); 



