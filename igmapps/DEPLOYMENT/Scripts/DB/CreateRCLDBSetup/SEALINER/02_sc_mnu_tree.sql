delete from sc_mnu_tree where program_id='TOS_OPR' and menu_id='ELL001';
delete from sc_mnu_tree where program_id='TOS_OPR' and menu_id='EDL001';
delete from sc_mnu_tree where program_id='CA' and menu_id='SECM';
delete from sc_mnu_tree where program_id='SECM' and menu_id='SECM005';
delete from sc_mnu_tree where program_id='SECM' and menu_id='SECM007';
delete from sc_mnu_tree where program_id='SECM' and menu_id='SECM010';
delete from sc_mnu_tree where program_id='DIM_MNT' and menu_id='SEDL004';

set define off
insert into sc_mnu_tree values('R','*','***','ELL001','TOS_OPR',52,'Easy Load List Overview','ELL001',null,'TOS','F','A',null,'/ezllapps/do/sell001?appId=Dolphin','Y');
insert into sc_mnu_tree values('R','*','***','EDL001','TOS_OPR',53,'Easy Discharge List Overview','EDL001',null,'TOS','F','A',null,'/ezllapps/do/sedl001?appId=Dolphin','Y');
insert into sc_mnu_tree values('R','*','***','SECM','CA',4,'E-Notice Template Maintenance','SECM',null,'CA','F','A',null,null,'Y');
insert into sc_mnu_tree values('R','*','***','SECM005','SECM',1,'E-Notice Template setup','SECM005',null,'CA','F','A',null,'/ezllapps/do/secm005?appId=Dolphin','Y');
insert into sc_mnu_tree values('R','*','***','SECM007','SECM',2,'E-Notice Recieving Organization Master','SECM007',null,'CA','F','A',null,'/ezllapps/do/secm007?appId=Dolphin','Y');
insert into sc_mnu_tree values('R','*','***','SECM010','SECM',3,'E Notice Service Maintenance','SECM010',null,'CA','F','A',null,'/ezllapps/do/secm010?appId=Dolphin&PAGE_URL=/do/secm010','Y');
insert into sc_mnu_tree values('R','*','***','SEDL004','DIM_MNT',5,'Return Shipment','SEDL004',null,'DIM','F','A',null,'/ezllapps/do/sedl004?appId=Dolphin','Y');
set define on
commit;