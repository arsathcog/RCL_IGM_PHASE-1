Input Root Folder Path :: &ROOT_FOLDER_PATH
spool &&ROOT_FOLDER_PATH\RCL_DB_Setup_Result.out;

ACCEPT src_pwd_nm PROMPT 'Enter Password of source user "sealiner" to be created at source : ' HIDE
ACCEPT vasapps_pwd_nm PROMPT 'Enter Password of source user "vasapps" to be created at source : ' HIDE
ACCEPT ezll_admin_pwd_nm PROMPT 'Enter Password of EZLL Admin user "ezll_admin" to be created at source : ' HIDE

CONNECT sealiner/&src_pwd_nm@RCL_AV.WORLD;
show user
@&&ROOT_FOLDER_PATH\SEALINER\01_sealiner_grants.sql;
@&&ROOT_FOLDER_PATH\SEALINER\02_sc_mnu_tree.sql;

CONNECT vasapps/&vasapps_pwd_nm@RCL_AV.WORLD;
show user
@&&ROOT_FOLDER_PATH\VASAPPS\01_vasapps_tables.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\02_vasapps_types.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\03_vasapps_synonyms.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\04_vasapps_sequences.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\05_vasapps_views.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\06_vasapps_functions.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\07_vasapps_pre_procedures.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\08_vasapps_packages_spec.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\09_vasapps_packages_body.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\10_vasapps_post_procedures.sql;
@&&ROOT_FOLDER_PATH\VASAPPS\11_vasapps_create_data.sql;

CONNECT ezll_admin/&ezll_admin_pwd_nm@RCL_AV.WORLD;
show user
@&&ROOT_FOLDER_PATH\EZLL_ADMIN\01_ezll_admin_objects.sql;

spool off


