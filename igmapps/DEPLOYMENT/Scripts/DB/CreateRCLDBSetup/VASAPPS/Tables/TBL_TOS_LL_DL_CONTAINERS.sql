-- Create table
create table TOS_LL_DL_CONTAINERS
(
  PK_TOS_LL_DL_CNTR_SEQ inteGER not null,
  SOURCE                varchar2(20) not null,
  FK_BOOKING_NO         varchar2(20) not null,
  FK_EQUIPMENT_SEQ      number(12),
  FK_OLD_EQUIPMENT_NO   varchar2(12),
  FK_NEW_EQUIPMENT_NO   varchar2(12),
  SIZE_TYPE_SEQ_NO      number(12),
  SUPPLIER_SEQ_NO       number(12),
  OVERHEIGHT            NUMBER(14,4),
  OVERLENGTH_REAR       NUMBER(14,4),
  OVERLENGTH_FRONT      NUMBER(14,4),
  OVERWIDTH_LEFT        NUMBER(14,4),
  OVERWIDTH_RIGHT       NUMBER(14,4),
  IMDG                  varchar2(4),
  IMO_CLASS             varchar2(4),
  UNNO                  varchar2(6),
  UN_VAR                varchar2(1),
  FUMIGATION_YN         varchar2(1),
  RESIDUE               varchar2(1),
  FLASH_POINT           varchar2(7),
  FLASH_UNIT            VARCHAR2(1),
  REEFER_TMP            varchar2(7),
  REEFER_TMP_UNIT       VARCHAR2(1),
  HUMIDITY              NUMBER(5,2),
  VENTILATION           NUMBER(5,2),
  WEIGHT                NUMBER(14,2),
  VGM                   NUMBER(14,2),
  VGM_CATEGORY          VARCHAR2(70),
  CREATED_USER			varchar2(15),
  MODE_TYPE				VARCHAR2(1),
  STATUS				VARCHAR2(1) NOT NULL,  
  ERR_DESC				varchar2(1000),
  RECORD_STATUS         varchar2(1) not null,
  RECORD_ADD_USER       varchar2(10) not null,
  RECORD_ADD_DATE       timestamp not null,
  RECORD_CHANGE_USER    varchar2(10),
  RECORD_CHANGE_DATE    timestamp
)
tablespace VASDATA
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table TOS_LL_DL_CONTAINERS
  is 'TO KEEP EQUIPMENT DATA AND DG INFO AND FLOW TO EZLL/EZDL.';
-- Add comments to the columns 
comment on column TOS_LL_DL_CONTAINERS.PK_TOS_LL_DL_CNTR_SEQ
  is 'MANDATORY BOOKING TO EZLL SEQ, PRIMARY KEY  AUTO INCREASEMENT : SR_TOS_LDC01';
comment on column TOS_LL_DL_CONTAINERS.SOURCE
  is 'Mandatory, Source  Vlaues : BKG - Data will flow to EZLL/EZDL, LLDL - Datat will flow back to Booking. ';
comment on column TOS_LL_DL_CONTAINERS.STATUS
  is 'Mandatory, STATUS Vlaues : P - PENDING, E - ERROR , C - COMPLETE  ';
comment on column TOS_LL_DL_CONTAINERS.FK_BOOKING_NO
  is 'Mandatory, Booking No, FK to BKP009.BIBKNO';
comment on column TOS_LL_DL_CONTAINERS.FK_EQUIPMENT_SEQ
  is 'Optional, Equipment Seq, FK to BKP009.BISEQN';
comment on column TOS_LL_DL_CONTAINERS.FK_OLD_EQUIPMENT_NO
  is 'Optional, Equipment No, FK to BKP009.BICTRN ';
comment on column TOS_LL_DL_CONTAINERS.FK_NEW_EQUIPMENT_NO
  is 'Optional, Equipment No FK to BKP009.BICTRN';
comment on column TOS_LL_DL_CONTAINERS.SIZE_TYPE_SEQ_NO
  is 'Optional, Size/Type Seqno FK to BKP032.EQP_SIZETYPE_SEQNO';
comment on column TOS_LL_DL_CONTAINERS.SUPPLIER_SEQ_NO
  is 'Optional, Supplier_Seq_no, FK to BKP009.SUPPLIER_SQNO';
comment on column TOS_LL_DL_CONTAINERS.OVERHEIGHT
  is 'Optional, Overheight , FK to BKP009.BIXHGT';
comment on column TOS_LL_DL_CONTAINERS.OVERLENGTH_REAR
  is 'Optional, Overlength rear , FK to BKP009.BIXLNB';
comment on column TOS_LL_DL_CONTAINERS.OVERLENGTH_FRONT
  is 'Optional, Overlength front, FK to BKP009.BIXLNF';
comment on column TOS_LL_DL_CONTAINERS.OVERWIDTH_LEFT
  is 'Optional, Overwidth left , FK to BKP009.BIXWDL';
comment on column TOS_LL_DL_CONTAINERS.OVERWIDTH_RIGHT
  is 'Optional, Overwidth right , FK to BKP009.BIXWDR';
comment on column TOS_LL_DL_CONTAINERS.IMDG
  is 'Optional, IMDG , FK to  BKP009.BIIMCL';
comment on column TOS_LL_DL_CONTAINERS.IMO_CLASS
  is 'Optional, IMO_Class FK to booking_dg_comm_detail.IMO_CLASS';
comment on column TOS_LL_DL_CONTAINERS.UNNO
  is 'Optional, UNNO , FK to BKP009.BIUNN';
comment on column TOS_LL_DL_CONTAINERS.UN_VAR
  is 'Optional, UN_VARIANT , FK to BKP009.UN_VARIANT';
comment on column TOS_LL_DL_CONTAINERS.FUMIGATION_YN
  is 'Optional, FUMIGATION , FK to booking_dg_comm_detail.FUMIGATION_YN';
comment on column TOS_LL_DL_CONTAINERS.RESIDUE
  is 'Optional, RESIDUE , FK to booking_dg_comm_detail.RESIDUE';
comment on column TOS_LL_DL_CONTAINERS.FLASH_POINT
  is 'Optional, FLASH_POINT , FK to BKP009.BIFLPT';
comment on column TOS_LL_DL_CONTAINERS.FLASH_UNIT
  is 'Optional, FLASH_UNIT , FK to BKP009.BIFLBS';
comment on column TOS_LL_DL_CONTAINERS.REEFER_TMP
  is 'Optional, REEFER_TMP , FK to BKP009.BIRFFM';
comment on column TOS_LL_DL_CONTAINERS.REEFER_TMP_UNIT
  is 'Optional, REEFER_TMP_UNIT , FK to BKP009.BIRFBS';
comment on column TOS_LL_DL_CONTAINERS.HUMIDITY
  is 'Optional, HUMIDITY , FK to BKP009.HUMIDITY';
comment on column TOS_LL_DL_CONTAINERS.VENTILATION
  is 'Optional, VENTILATION , FK to BKP009.AIR_PRESSURE';
comment on column TOS_LL_DL_CONTAINERS.WEIGHT
  is 'Optional, WEIGHT , FK to BKP009.MET_WEIGHT';
comment on column TOS_LL_DL_CONTAINERS.VGM
  is 'Optional, VGM , FK to BKP009.EQP_VGM';
comment on column TOS_LL_DL_CONTAINERS.VGM_CATEGORY
  is 'Optional, VGM_CATEGORY , FK to BKP009.EQP_CATEGORY';
comment on column TOS_LL_DL_CONTAINERS.CREATED_USER
  is 'Optional, Created User, FK to BKP009.BICUSR';  
comment on column TOS_LL_DL_CONTAINERS.MODE_TYPE
  is 'Mandatory, MODE TYPE ,VALUE : I - INSERTING, U - UPDATING , D - DELETING';  
comment on column TOS_LL_DL_CONTAINERS.ERR_DESC
  is 'Mandatory, ERROR DESCRIPTION';  
comment on column TOS_LL_DL_CONTAINERS.RECORD_STATUS
  is 'Mandatory, Record status , value : A - Active , S - Suspend';
comment on column TOS_LL_DL_CONTAINERS.RECORD_ADD_USER
  is 'Mandatory, Record add user ';
comment on column TOS_LL_DL_CONTAINERS.RECORD_ADD_DATE
  is 'Mandatory, Record Add Date ';
comment on column TOS_LL_DL_CONTAINERS.RECORD_CHANGE_USER
  is 'Optional, Record Change User ';
comment on column TOS_LL_DL_CONTAINERS.RECORD_CHANGE_DATE
  is 'Optional, Record Change Date ';
-- Create/Recreate indexes 
create unique index PK_TOS_LL_DL_CNTR_SEQ on TOS_LL_DL_CONTAINERS (pk_tos_ll_dl_cntr_seq)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate indexes 
create index IDX_TOS_LDC01 on TOS_LL_DL_CONTAINERS (record_add_date, STATUS, source,RECORD_STATUS)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
create index IDX_TOS_LDC02 on TOS_LL_DL_CONTAINERS (pk_tos_ll_dl_cntr_seq, fk_booking_no)
  tablespace VASINDX
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
  
