/** ************************************************************************* */
/** HISTORY_BEGIN                                                             */
/** System name         : RCL-VAS                                             */
/** Outline of function : Data Transfer Object for Contracts List Result      */
/** PGM ID              : EllLoadListOverviewMod                              */
/** PGM Name            : Contract List VO/DTO                                */
/** @author             : AKS                                                 */
/** @version v1.00      : 2009/10/27                                          */
/** @version v1.01      : YYYY/MM/DD                                          */
/** Content of change   : Specify the change                                  */
/** @version v1.02      : YYYY/MM/DD Developer Name                           */
/** Content of change   : Specify the change                                  */
/** HISTORY_END                                                               */
/** ************************************************************************* */
package

com.rclgroup.dolphin.web.igm.vo;

import com.niit.control.common.BaseVO;

/**
 * Transfer Object for Contract List Result
 * @author AKS
 * @version v1.00 2009/10/27
 */
public class EllTareWeightOverviewMod extends BaseVO {

    private String tw_equipment_no = null;
    private String tw_size = null;
    private String tw_type_desc = null;
    private String tw_value = null;
    

    // private String contractDate = null;

    public EllTareWeightOverviewMod() {
    }


    /**
     *
     * @param equipment_no String
     *
     */

    public void setTw_equipment_no(String tw_equipment_no) {
        this.tw_equipment_no = tw_equipment_no;
    }

    public String getTw_equipment_no() {
        return tw_equipment_no;
    }

    public void setTw_size(String tw_size) {
        this.tw_size = tw_size;
    }

    public String getTw_size() {
        return tw_size;
    }

    public void setTw_type_desc(String tw_type_desc) {
        this.tw_type_desc = tw_type_desc;
    }

    public String getTw_type_desc() {
        return tw_type_desc;
    }

    public void setTw_value(String tw_value) {
        this.tw_value = tw_value;
    }

    public String getTw_value() {
        return tw_value;
    }
}

