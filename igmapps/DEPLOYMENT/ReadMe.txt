EZLL_WEB_APP_BUILD_001_00_1_061_20130625_01
Build Tag: EZLL_WEB_APP_BUILD_001_00_1_061_20130625_01

Description:
------------
Screen Version: 1.61

Changes -
    1.  In match process, get bookings in ascending order of booking and slot operator.

Deployment Procedure:
---------------------
Important Note: this build only provides for 64 bit environment, and
this 64 bit build is required to deploy on production environment.

    - DEPLOYMENT\Scripts\DB\CreateRCLDBSetup\VASAPPS\Packages\Spec  folder
        1. PCE_ECM_EDI.pkg

    - DEPLOYMENT\Scripts\DB\CreateRCLDBSetup\VASAPPS\Packages\Body folder
        1. PCE_ECM_EDI.pkb

Note: Please restart the application server after successful deployement.