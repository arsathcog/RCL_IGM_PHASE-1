Input Root Folder Path :: &ROOT_FOLDER_PATH
spool &&ROOT_FOLDER_PATH\RCL_DB_Setup_Rollback_Result.out;

ACCEPT src_pwd_nm PROMPT 'Enter Password of source user "sealiner" to be created at source : ' HIDE
ACCEPT vasapps_pwd_nm PROMPT 'Enter Password of source user "vasapps" to be created at source : ' HIDE

CONNECT sealiner/&src_pwd_nm@RCL_AV.WORLD;
show user
@&&ROOT_FOLDER_PATH\SEALINER\01_sealiner_revoke_grants.sql;
@&&ROOT_FOLDER_PATH\SEALINER\02_sc_mnu_tree.sql;

CONNECT vasapps/&vasapps_pwd_nm@RCL_AV.WORLD;
show user
@&&ROOT_FOLDER_PATH\VASAPPS\01_vasapps_drop_tables.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\02_vasapps_drop_types.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\03_vasapps_drop_synonym.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\04_vasapps_drop_sequences.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\05_vasapps_drop_views.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\06_vasapps_drop_functions.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\07_vasapps_drop_procedures.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\08_vasapps_drop_packages.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\09_vasapps_delete_data.sql;
spool off
