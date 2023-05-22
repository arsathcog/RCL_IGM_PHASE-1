/* -----------------------------------------------------------------------------
System  : RCL-VAS
Module  : Resources
Prog ID : ReportParams.java
Name    : Report Params
Purpose : Keeps Reports Parameter Names
--------------------------------------------------------------------------------
History : None
--------------------------------------------------------------------------------
Author          Date            What
--------------- --------------- ------------------------------------------------
NTL)AKS         30/10/2009      <Initial version>
--Change Log--------------------------------------------------------------------
## DD/MM/YY –User- -Task/CR No- -Short Description-
----------------------------------------------------------------------------- */

package com.rclgroup.dolphin.ezl.resource;

import java.util.HashMap;

/************************************************************************ 
 * Stores the Constants
 * @author AKS
 * @since  30/10/2009
 * @version 1.0
 ************************************************************************/
public class ReportParams {

    /* Report Name Extension */
    private static final String REPORT_NM_EXT = ".rdf";

    /* Parameter Names used in all Reports */
    private static final String PARAM_SYSDATE = 
        "P_I_V_DATE_TM"; //Always First Param
    private static final String PARAM_USER_ID = 
        "P_I_V_USER_ID"; //Always Last Param

    /* Register all Reports and Parameter Details */
    private static final HashMap hmReportParamList = new HashMap();


    public ReportParams() {
        //none
    }

    public static String[] getReportParams(String astrReportNm) {
        if (hmReportParamList.containsKey(astrReportNm)) {
            return (String[])hmReportParamList.get(astrReportNm);
        } else if (hmReportParamList.containsKey(astrReportNm.substring(0, 
                                                                        astrReportNm.length() - 
                                                                        REPORT_NM_EXT.length()))) {
            return (String[])hmReportParamList.get(astrReportNm.substring(0, 
                                                                          astrReportNm.length() - 
                                                                          REPORT_NM_EXT.length()));
        }
        return null;
    }

    static {
        /* Start - Contract Module Reports */
        //hmReportParamList.put("VCT004",new String [] { PARAM_SYSDATE,"P_I_V_CONTRACT_ID","P_I_V_CONTRACT_NO",PARAM_USER_ID });

    } //End-Static    
}
