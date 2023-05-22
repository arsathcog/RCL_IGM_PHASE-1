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
public class EllLoadListOverviewMod extends BaseVO {

    private String loadListId = null;
    private String serviceGroup = null;
    private String serviceCd = null;
    private String port = null;
    private String terminal = null;
    private String vessel = null;
    private String fsc = null;
    private String outVoyage = null;
    private String fromEta = null;
    private String toEta = null;
    private String fromAta = null;
    private String toAta = null;
    private String loadlistStatus = null;
    private String direction = null;
    private String sequence = null;
    private String bargeName = null;
    private String bargeVoyage = null;
    private String bookedNo = null;
    private String loadedNo = null;
    private String robNo = null;
    private String overld = null;
    private String shortld = null;
    private String issues = null;
    private String view = null;
    private String flag = null;
    private String etaTime = null;
    private String etdTime = null;
    

    // private String contractDate = null;

    public EllLoadListOverviewMod() {
    }


    /**
     *
     * @param aintSrlNo int
     * @param astrContractNo String
     * @param astrVendor String
     * @param astrServices String
     * @param astrEffDate String
     * @param astrExpDate String
     * @param astrRecStatus String
     * @param astrDocStatus String
     * @param astrFsc String
     * @param astrContractDate String
     * @param astrRowId String
     * @param astrUpdTime String
     * 
     */
    public EllLoadListOverviewMod(int aintSrlNo, String astrLoadListId, 
                                  String astrServiceGroup, 
                                  String astrServiceCd, String astrPort, 
                                  String astrTerminal, String astrVessel, 
                                  String astrOutVoyage, String astrFromEta, 
                                  String astrToEta, String astrFsc, 
                                  String astrFromAta, String astrToAta, 
                                  String astrLoadlistStatus, String astrView, 
                                  String astrRowId, String astrUpdTime) {

        this.srlNo = aintSrlNo;
        this.loadListId = astrLoadListId;
        this.serviceGroup = astrServiceGroup;
        this.serviceCd = astrServiceCd;
        this.port = astrPort;
        this.terminal = astrTerminal;
        this.vessel = astrVessel;
        this.outVoyage = astrOutVoyage;
        this.fromEta = astrFromEta;
        this.toEta = astrToEta;
        this.fromAta = astrFromAta;
        this.toAta = astrToAta;
        this.fsc = astrFsc;
        this.loadlistStatus = astrLoadlistStatus;
        this.view = astrView;
        this.rowId = astrRowId;
        this.updTime = astrUpdTime;

    }

    public void setServiceGroup(String serviceGroup) {
        this.serviceGroup = serviceGroup;
    }

    public String getServiceGroup() {
        return serviceGroup;
    }

    public void setServiceCd(String serviceCd) {
        this.serviceCd = serviceCd;
    }

    public String getServiceCd() {
        return serviceCd;
    }

    public void setVessel(String vessel) {
        this.vessel = vessel;
    }

    public String getVessel() {
        return vessel;
    }

    public void setOutVoyage(String outVoyage) {
        this.outVoyage = outVoyage;
    }

    public String getOutVoyage() {
        return outVoyage;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public String getDirection() {
        return direction;
    }

    public void setSequence(String sequence) {
        this.sequence = sequence;
    }

    public String getSequence() {
        return sequence;
    }

    public void setPort(String port) {
        this.port = port;
    }

    public String getPort() {
        return port;
    }

    public void setTerminal(String terminal) {
        this.terminal = terminal;
    }

    public String getTerminal() {
        return terminal;
    }

    public void setBargeName(String bargeName) {
        this.bargeName = bargeName;
    }

    public String getBargeName() {
        return bargeName;
    }

    public void setFromEta(String fromEta) {
        this.fromEta = fromEta;
    }

    public String getFromEta() {
        return fromEta;
    }

    public void setToEta(String toEta) {
        this.toEta = toEta;
    }

    public String getToEta() {
        return toEta;
    }

    public void setFromAta(String fromAta) {
        this.fromAta = fromAta;
    }

    public String getFromAta() {
        return fromAta;
    }

    public void setToAta(String toAta) {
        this.toAta = toAta;
    }

    public String getToAta() {
        return toAta;
    }


    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setBookedNo(String bookedNo) {
        this.bookedNo = bookedNo;
    }

    public String getBookedNo() {
        return bookedNo;
    }

    public void setLoadedNo(String loadedNo) {
        this.loadedNo = loadedNo;
    }

    /**
     * @return
     */
    public String getLoadedNo() {
        return loadedNo;
    }

    public void setRobNo(String robNo) {
        this.robNo = robNo;
    }

    public String getRobNo() {
        return robNo;
    }

    public void setOverld(String overld) {
        this.overld = overld;
    }

    public String getOverld() {
        return overld;
    }

    public void setShortld(String shortld) {
        this.shortld = shortld;
    }

    public String getShortld() {
        return shortld;
    }

    public void setIssues(String issues) {
        this.issues = issues;
    }

    public String getIssues() {
        return issues;
    }


    public void setView(String view) {
        this.view = view;
    }

    public String getView() {
        return view;
    }


    public void setFsc(String fsc) {
        this.fsc = fsc;
    }

    public String getFsc() {
        return fsc;
    }

    public void setBargeVoyage(String bargeVoyage) {
        this.bargeVoyage = bargeVoyage;
    }

    public void setLoadlistStatus(String loadlistStatus) {
        this.loadlistStatus = loadlistStatus;
    }

    public String getLoadlistStatus() {
        return loadlistStatus;
    }

    public String getBargeVoyage() {
        return bargeVoyage;
    }

    public void setLoadListId(String loadListId) {
        this.loadListId = loadListId;
    }

    public String getLoadListId() {
        return loadListId;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public String getFlag() {
        return flag;
    }

    public void setEtaTime(String etaTime) {
        this.etaTime = etaTime;
    }

    public String getEtaTime() {
        return etaTime;
    }

    public void setEtdTime(String etdTime) {
        this.etdTime = etdTime;
    }

    public String getEtdTime() {
        return etdTime;
    }
}

