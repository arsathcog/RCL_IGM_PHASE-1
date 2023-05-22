/****************************************************/
/*                                                  */
/*              COMMON FUNCTIONS                    */
/*                                                  */
/****************************************************/

/* Start For ECM */
    var APP_NAME                = 'EZL';
    var SUCCESS                 = 'success';
    var FAILURE                 = 'failure';
    var ERROR_MSG		='1';
    var TILDE			='~';
    var RPT_OUTPUT_PDF          = 'pdf';
    var RPT_OUTPUT_EXCEL        = 'pdf';
    
    var BUS_OBJ_CONTRACT        = 'VCT';
    var BUS_OBJ_QUOTATION       = 'VQT';
    var BUS_OBJ_BOOKING         = 'VBK';
    var BUS_OBJ_JOB_ORDER       = 'VJO';
    var BUS_OBJ_TRACK_TRACE     = 'VTT';
    var BUS_OBJ_REPORTS         = 'VRP';
    
    var REC_STATUS_ACTIVE       = 'A';
    var REC_STATUS_SUSPEND      = 'S';


    /* Added By Ankit*/
    var MASTER_ID_SERVICE_GRP 	= "SERVICE_GROUP";
    var MASTER_ID_SERVICE 	= "SERVICE";
    var MASTER_ID_PORT        	= "PORT";
    var MASTER_ID_TERMINAL 	= "TERMINAL";
    var MASTER_ID_VESSEL       	= "VESSEL";
    var MASTER_ID_IN_VOYAGE 	= "IN_VOYAGE";
    var MASTER_ID_OUT_VOYAGE 	= "IN_VOYAGE";
    var MASTER_ID_FSC 	        = "FSC";
	var MASTER_ID_OPERATOR       = "OPERATOR";
	var MASTER_ID_EQUIPMENT   	  	= "EQUIPMENT_TYPE";
    var IDX_SRV_GRP_CD              = 0;
    var IDX_SRV_CD                  = 1;
    var IDX_VSL_CD                  = 2;
    var IDX_PRT_CD                  = 4;
    var IDX_TRM_CD                  = 5;
    var IDX_IN_VOY_CD               = 3;
    var IDX_OUT_VOY_CD              = 3;
    var IDX_PORT_CD                 = 0;
    var IDX_TRML_CD                 = 0;
    var IDX_OPR_CD                  = 0;	
	var IDX_CONTAINER_OP    		= 0;
	var IDX_SLOT_OP         		= 0;
	var IDX_PORT            		= 0;
	var IDX_EQUIPMENT_TYPE  		= 0;
	var IDX_HICCD                   = 0;	
	var IDX_HISDS                   = 1;				
	var IDX_IMDG                    = 0;	
	var IDX_UNNO                    = 1;			
	var IDX_UNVAR                   = 2;	
	var IDX_PORT_CODE               = 3;	
	var IDX_PORT_TYPE               = 4;	
	var IDX_FLASH_POINT             = 6;	

    var MASTER_ID_CONTRACT	='CONTRACT';
    var MASTER_ID_QUOTATION	='QUOTATION';
    var MASTER_ID_BOOKING	='BOOKING';
    var MASTER_ID_JOB_ORDER	='JOB_ORDER';
    var MASTER_ID_VENDOR	='VENDOR';
	var MASTER_ID_VENDOR_VBK='VENDOR_VBK';
    var MASTER_ID_CUSTOMER	='CUSTOMER';
    var MASTER_ID_FSC	        ='FSC';
    var MASTER_ID_SERVICE	='SERVICE';
    var MASTER_ID_SHIP_TERM	='SHIP_TERM';
    var MASTER_ID_LOC_TYPE	='LOC_TYPE';
    var MASTER_ID_LOCATION	='LOCATION';
    var MASTER_ID_UOM		='UOM';
    var MASTER_ID_CHRG_BASIS_TYPE='CHRG_BASIS_TYPE';
    var MASTER_ID_CURRENCY      ='CURRENCY';
    var MASTER_ID_COM_GROUP	='COMODITY_GROUP';
    var MASTER_ID_COMODITY	='COMODITY';
    var MASTER_ID_PRINT_ID	='PRINT_ID';
    var MASTER_ID_COUNTRY	='COUNTRY';
    var MASTER_ID_CATEGORY	='CATEGORY';
    var MASTER_ID_PRODUCT	='PRODUCT';
    var MASTER_ID_DOC_TYPE	='DOC_TYPE';
    var MASTER_ID_PACK_TYPE	='PACK_TYPE';
    var MASTER_ID_REASON	='REASON';
    var MASTER_ID_SHIPPING_TERM	='SHIPPING_TERM';
    var MASTER_ID_PAYMENT_TERM	='PAYMENT_TERM';
    var MASTER_ID_INCO_TERM	='INCO_TERM';
    var MASTER_ID_EVENT	        ='EVENT';
    var MASTER_ID_CUST_TYPE     ='CUST_TYPE';

    /* Doc Status */
    var DOC_STATUS_ALL           = "0";
    var DOC_STATUS_ENTRY         = "1";
    var DOC_STATUS_PENDING_APRV  = "2";
    var DOC_STATUS_APPROVE       = "3";
    var DOC_STATUS_CONFIRM       = "4";
    var DOC_STATUS_BILLING       = "5";
    var DOC_STATUS_REVIEW        = "6";
    var DOC_STATUS_CANCEL        = "7";
    var DOC_STATUS_PENDING_SEND  = "8";
    var DOC_STATUS_FINAL         = "9";
    
/* End For EZL */    

// VARIABLES FOR COLOR
var BG_ERR_CLR = 'red';             // error background color.
var FG_ERR_CLR = 'white';           // error foreground color.
var BG_DEF_CLR = 'white';           // default background color.
var FG_DEF_CLR = 'black';           // default foreground color.
var CONTROL    = 'CONTROL';         // default foreground color.

var updEnbDsb  = false;
// VARIABLES FOR DATE
var dtCh= "/";
var minYear=1000;
var maxYear=9999;

/* ID of the heading Division of the table(Optional)
 * required for sync. the Hor-Scrolling of Data Section
*/
var headingDivisionID = "DivHeading";

/* ID of the heading Division of the table(Optional)
 * required for sync. the Hor-Scrolling of Data Section
*/
var headingDivisionID = "DivHeading";

/* Status Column Values*/
var ADD = "ADD";
var UPD = "UPD";
var HIDE = "HIDE";
var DEL = "DEL";

var isIE = false;

var isErrFlg = false ;
var isErrFlag = false;
document.onclick = onClickDisable;


/* start for all child window closing */
var arrChilds = new Array();

function doCloseAllChilds() {
	
	var x=0;
	var V;
	
	for (x=0; x<arrChilds.length; x++) {
		try{
			V = arrChilds[x];
			V.window.close();
		}catch(e){
			//do nothing...
		}
	}
}
/* end for all child window closing */


function onClickDisable() {

    if(document.forms[0] != null && document.forms[0] != undefined) {
        if ( document.forms[0].action == '' ||
                   (window.event.srcElement.type == 'image' && window.event.srcElement.disabled)) {
            isErrFlg = true ;
        }
    }
    //document.getElementsByTagName("body").style="cursor: move";
    disableButtons('1');

    isErrFlg = false;
}

function disableButtons()
{//Start Change BY SACHIN
    if( (arguments[0] == '0'||arguments[0] == '2') || 
    //End change BY SACHIN
        ( arguments[0] == '1' && !isErrFlg && window.event.srcElement.type == 'image' )
      ) {
        var docElements = document.getElementsByTagName("input");
        if(docElements.length > 0 ) {
            for (i = 0; i < docElements.length ; i++ ){
                if(docElements[i].type == 'image'){
                    var attrib = docElements[i].attributes ;
                    //Start Change BY SACHIN
                    if((arguments[0] == '1' ||arguments[0] == '2') && !docElements[i].disabled){
                    //End Change BY SACHIN
                        docElements[i].disabled = true;
                    }
                    if( docElements[i].disabled ){
                        docElements[i].setAttribute("className" ,"topsOpacityLow");
                    }
                }
            }
        }
    }
}

/**
 * showError()
 * ================
 *
 * Show the Message Box (Error, Information, Warning)
 *
 * Parameters
 * ----------
 * <Parameter1> - <Message ID>              MANDATORY MUST BE PASSED BY USER
 * <Parameter2> - <Message>                 MANDATORY MUST BE PASSED BY USER
 * <Parameter3> - <Field>                   OPTIONAL
 * <Parameter4> - <PlaceHolders Array>      OPTIONAL
 * <Parameter5> - <Visible Tab String>      OPTIONAL
 * Return value
 * ------------
 */
function showError(){
    // Set Error Flag to true Begin
    isErrFlg = true ;
    // Set Error Flag to true End

    lstrMessageID = showError.arguments[0];
    lstrMessage   = showError.arguments[1];
    lobjField     = showError.arguments[2];

    //Array to store Place Holder Replacement
    var larrMessage     = new Array()   ;
    //Variable to store Default Error Icon and Title Message
    var lstrIconType    = 16            ;
    var lstrMessgeType  = "Error"       ;
    //Variable to store messge type like (I/W/E)
    var lstrMsgTyp                      ;
    //Variable to Count the place holder and get the insert position of place holder
    var counter         = 0             ;
    var insertPosition                  ;


    larrMessage = showError.arguments[3];

    //variables to store the Tab status
    lstrVisibleTab  = showError.arguments[4];

    //Set the status of Tab to visible
    if(lstrVisibleTab != null && lstrVisibleTab.length >0){
        manageTab(lstrVisibleTab);
    }

    if(larrMessage != null &&
           larrMessage.length > 0 ){

        while((insertPosition = lstrMessage.indexOf('#')) > -1){

            if(larrMessage[counter] == null ){
                larrMessage[counter] = "";
            }

            lstrMessage = lstrMessage.substring(0,insertPosition) +
                          larrMessage[counter] +
                          lstrMessage.substring(insertPosition+1,lstrMessage.length);
            counter++;
        }
    }

    lstrFinalMsg  = lstrMessageID + ' : ' + lstrMessage;

    if(lobjField!=null){
        setErrorColor(lobjField);
        lobjField.focus();
    }

    //Set the icon type and Title
    if(lstrMessageID != null || lstrMessageID.length() != 0){
        lstrMsgTyp = lstrMessageID.substring(1,2);

        if( lstrMsgTyp == 'W'){
            lstrIconType  = 48;
            lstrMessgeType = "Warning";
        }else if(lstrMsgTyp == 'I'){
            lstrIconType  = 64;
            lstrMessgeType = "Information";
        }
    }

    showAlert(lstrFinalMsg, lstrIconType, lstrMessgeType);
}


/**
 * showQuestion()
 * ================
 *
 * Show the Message Box (Warning) - Yes/No
 *
 * Parameters
 * ----------
 * <Parameter1> - <Message ID>          MANDATORY MUST BE PASSED BY USER
 * <Parameter2> - <Field>               OPTIONAL
 * <Parameter3> - <PlaceHolders Array>  OPTIONAL
 * Return value
 * ------------
 * <Boolean> - <true/false>
 */
function showQuestion(){
    var lstrMessage = '';
    lstrMessageID = showQuestion.arguments[0];
    lobjField     = showQuestion.arguments[1];
    lstrCaleeFunction = funcname(arguments.caller.callee);
    //Array to store Place Holder Replacement
    var larrMessage     = new Array()   ;
    var insertPosition                  ;
    var counter         = 0        ;

    larrMessage = showQuestion.arguments[2];
    
    lstrMessage = getErrorMsg(lstrMessageID);
    
    if(larrMessage != null &&
           larrMessage.length > 0 ){

        while((insertPosition = lstrMessage.indexOf('#')) > -1){

            if(larrMessage[counter] == null ){
                larrMessage[counter] = "";
            }
             lstrMessage = lstrMessage.substring(0,insertPosition) +
                          larrMessage[counter] +
                          lstrMessage.substring(insertPosition+1,lstrMessage.length);
             counter++;
        }
    }

    //lstrFinalMsg  = lstrMessageID + ' : ' + lstrMessage;
    lstrFinalMsg  = lstrMessage;

    if(lobjField!=null){
        lobjField.focus();
    }
    var cnfUser = confirm(lstrFinalMsg);
    if( !cnfUser ) {
        isErrFlg = true;
    }
    if(cnfUser && lstrCaleeFunction == 'onLoad'){
    	disableButtons('2');
    }
    //End ADD BY SACHIN
    return cnfUser;
}
//Start ADD BY SACHIN
function funcname(f) {
    var s = f.toString().match(/function (\w*)/)[1];
    if ((s == null) || (s.length==0)) return "anonymous";
    return s;
}
function getErrorMsg(errorCode){
    return errorCode;
}
//End ADD BY SACHIN
////////////////////////////////// VALIDATIONS FOR NUMBERS - BEGIN /////////////////////////////////////

/**
 * isInteger()
 * ================
 *
 * Method to check whether the data is numeric or not
 *
 * Parameters
 * ----------
 * <Parameter1> - <Number Value> MANDATORY MUST BE PASSED BY USER
 * *
 * Return value
 * ------------
 * <Boolean> - <TRUE - Number is an Integer , FALSE - Number is not an Integer>
 */
function isInteger(aValue){
   var lstrValue = aValue;
   re = new RegExp(",","g");
   lstrValue = lstrValue.replace(re,"");
   for (lintCounter = 0; lintCounter < lstrValue.length; lintCounter++){
        // Check that current character is number.
        var c = lstrValue.charAt(lintCounter);
        if (((c < "0") || (c > "9"))){
            return false;
        }
    }
    // All characters are numbers.
    return true;
}


/**
 * validateFloat()
 * ================
 *
 * To validate that the number passed is valid or not
 *
 * Parameters
 * ----------
 * <Parameter1> - <NumberValue> MANDATORY MUST BE PASSED BY USER
 * <Parameter2> - <Number of digits before the decimal> MANDATORY MUST BE PASSED BY USER
 * <Parameter3> - <Number of digits after the decimal> MANDATORY MUST BE PASSED BY USER
 * <Parameter4> - <Negative Allowed : boolean> OPTIONAL (By default it is false)
 *
 * Return value
 * ------------
 * <Boolean> - <TRUE - Number is correct , FALSE - Number is incorrect>
 */
function validateFloat(astrNumber,astrDigitsBefDec,astrDigitsAfterDec)
{
    var lreComma = new RegExp(",","g");
    var lblnResult = false;
    var lstrVal = astrNumber;
    var lstrDigitsBefDec    = astrDigitsBefDec;
    var lstrDigitsAfterDec  = astrDigitsAfterDec;
    var lblnNegativeAllowed = validateFloat.arguments[3];
    // Replace the commas if present in the value
    if(lstrVal != null && lstrVal.length > 0){
        lstrVal = validateFloat.arguments[0].replace(lreComma,"");
    }else{
        // If Null is passed then return false
        return false;
    }

    if(lblnNegativeAllowed == null || lblnNegativeAllowed.length == 0){
        lblnNegativeAllowed = false;
    }

    if(lblnNegativeAllowed){
        //To match positive or negative real numbers with or without a decimal point and 0 to <<specified>> decimal places.
        lexp = "^-?\\d{0," + lstrDigitsBefDec + "}(\\.\\d{0," + lstrDigitsAfterDec + "})?$";
        lreData = new RegExp(lexp);
        lblnResult = lreData.test(lstrVal);
    }else{
        //To match positive real numbers with or without a decimal point and 0 to <<specified>> decimal places.
        lexp = "^\\d{0," + lstrDigitsBefDec + "}(\\.\\d{0," + lstrDigitsAfterDec + "})?$";
        lreData = new RegExp(lexp);
        lblnResult = lreData.test(lstrVal);
    }
    return lblnResult;
}
////////////////////////////////// VALIDATIONS FOR NUMBERS - END /////////////////////////////////////

////////////////////////////////// VALIDATIONS FOR DATES - BEGIN /////////////////////////////////////

/**
 * isValidDate()
 * ================
 *
 * Method to check whether the data is A VALID DATE or not
 *
 * Parameters
 * ----------
 * <Parameter1> - <Date> : the date to be in DDMMYYYY or DD/MM/YYYY format <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Boolean> - <TRUE - Date is correct , FALSE - Date is incorrect>
 */
function isValidDate(dtStr){
    re = new RegExp("/","g");
    dtStr = dtStr.replace(re,"");
    if(!isInteger(dtStr)){
        return false;
    }
    if(dtStr.length != 8) {
        return false;
    }
    var daysInMonth = DaysArray(12)
    var pos1=dtStr.indexOf(dtCh)

    var strDay=dtStr.substring(0,2)
    var strMonth=dtStr.substring(2,4)
    var strYear=dtStr.substring(4)
    strYr=strYear
    if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
    if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
    for (var i = 1; i <= 3; i++) {
        if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
    }
    month=parseInt(strMonth)
    day=parseInt(strDay)
    year=parseInt(strYr)
    if (pos1 != -1){
        return false
    }
    if (month<1 || month>12){
        return false
    }
    if (day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
        return false
    }
    if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
        return false
    }
    return true
}


/**
 * isValidMonthYear()
 * ================
 *
 * Check the validity of Date in YYYY/MM or YYYYMM format
 *          '0000/00' is a valid date for From Date
 *          '9999/99' is valid for To Date
 *
 * Parameters
 * ----------
 * <Parameter1> - <Date String><MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <Date Type> : '1' if it's From Date '2' if it's To Date <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Boolean> - <TRUE - If Valid Month-Year, FALSE if invalid month year >
 */
function isValidMonthYear(dtStr, FromToCheck){
    re = new RegExp("/","g");
    var formatdtStr = dtStr.replace(re,"");

    if(!isInteger(formatdtStr)){
        return false;
    }
    if(formatdtStr == '000000' && FromToCheck == '1'){
        return false;
    }
    if(formatdtStr == '999999' && FromToCheck == '2'){
        return false;
    }
    var month;
    var year;
    if(formatdtStr.length != 6) {
        return false;
    }

   year = formatdtStr.substring (0, 4);
   month = formatdtStr.substring (4, 6);

   if(month < "01" || month > "12"){
       return false;
   }
   if(year < "1000" || year > "9999"){
       return false;
   }
   return true
}

/**
 * isValidYrMonth()
 * ================
 *
 * Check the validity of Date in YYYY/MM format
 *          '0000/00' is a valid date for From Date
 *          '9999/99' is valid for To Date
 *
 * Parameters
 * ----------
 * <Parameter1> - <Date String><MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <Date Type> : '1' if it's From Date '2' if it's To Date <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Boolean> - <TRUE - If Valid Month-Year, FALSE if invalid month year >
 */
function isValidYrMonth(dtStr, FromToCheck){

    re = new RegExp("/","g");
    var dtStr = dtStr.replace(re,"");

    if(!isInteger(dtStr)){
        return false;
    }
    if(dtStr == '000000' && FromToCheck == '1'){
        return false;
    }
    if(dtStr == '999999' && FromToCheck == '2'){
        return false;
    }
   var month;
   var year;
    if(dtStr.length != 6) {
        return false;
    }
   year = dtStr.substring (0, 4);
   month = dtStr.substring (4, 6);

   if(year.length != 4 ){
       return false;
   }
   if(month.length != 2 ){
       return false;
   }
   if(month < "01" || month > "12"){
       return false;
   }
   if(year < "1000" || year > "9999"){
       return false;
   }
   return true
}

/**
 * compareDates()
 * ================
 *
 * Method to compare the From and To dates
 *
 * Parameters
 * ----------
 * <Parameter1> - <From Date> : the date to be in DD/MM/YYYY format <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <To   Date> : the date to be in DD/MM/YYYY format <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Number> -   0 if the dates are same
 *              -1 if the first one is an earlier date
 *              1 if the first one is a later date
 */
function compareDates (value1, value2) {
   var date1, date2;
   var month1, month2;
   var year1, year2;
   re = new RegExp("/","g");
   value1 = value1.replace(re,"");
   value2 = value2.replace(re,"");

   date1= value1.substring (0, 2);
   month1 = value1.substring (2, 4);
   year1 = value1.substring (4, 8);

   date2= value2.substring (0, 2);
   month2 = value2.substring (2, 4);
   year2 = value2.substring (4, 8);

   if (year1 > year2) return 1;
   else if (year1 < year2) return -1;
   else if (month1 > month2) return 1;
   else if (month1 < month2) return -1;
   else if (date1 > date2) return 1;
   else if (date1 < date2) return -1;
   else return 0;
}

/**
 * compareYearMonth()
 * ================
 *
 * Method to compare the From and To dates
 *
 * Parameters
 * ----------
 * <Parameter1> - <From Date> : the date to be in YYYY/MM format <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <To   Date> : the date to be in YYYY/MM format <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Number> -   0 if the dates are same
 *              -1 if the first one is an earlier date
 *              1 if the first one is a later date
 */
function compareYearMonth(value1, value2) {
   var month1, month2;
   var year1, year2;

    re = new RegExp("/","g");
    value1 = value1.replace(re,"");
    value2 = value2.replace(re,"");

    year1 = value1.substring(0, 4);
    month1 = value1.substring(4, 6);

    year2 = value2.substring(0, 4);
    month2 = value2.substring(4, 6);

    if (year1 > year2) return 1;
    else if (year1 < year2) return -1;
    else if (month1 > month2) return 1;
    else if (month1 < month2) return -1;
    else return 0;
}

/**
 * daysInFebruary()
 * ================
 *
 * To validate days in February (Used Internally)
 *
 * Parameters
 * ----------
 * <Parameter1> - <Year> MANDATORY MUST BE PASSED BY USER
 *
 * Return value
 * ------------
 * <Number> - Number of Days in February
 */
function daysInFebruary (year){
    // February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}


/**
 * formatWeek()
 * ================
 *
 * Method to format the week to '00' format on tabout/onblur
 *
 * Parameters
 * ----------
 * <Parameter1> - control field
 *
 * Return None
 * ------------
 */
function formatWeek(aField)
{
    lstrValue = aField.value;
   
    if(!isInteger(lstrValue)){
		return;
    }
	if(lstrValue.length < 1){
		lstrValue = '';
	} else if(lstrValue.length < 2){
		lstrValue = '0' + lstrValue;
	}
    aField.value = lstrValue;
}
/**
 * compareYearWeek()
 * ================
 *
 * Method to compare the From and To dates(in YYYYWW format)
 *
 * Parameters
 * ----------
 * <Parameter1> - <From Date> : the date to be in YYYYWW format <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <To   Date> : the date to be in YYYYWW format <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Number> -   0 if the dates are same
 *              -1 if the first one is an earlier date
 *              1 if the first one is a later date
 */
function compareYearWeek(value1, value2) {
   var week1, week2;
   var year1, year2;

    re = new RegExp("/","g");
    value1 = value1.replace(re,"");
    value2 = value2.replace(re,"");

    year1 = value1.substring(0, 4);
    week1 = value1.substring(4, 6);

    year2 = value2.substring(0, 4);
    week2 = value2.substring(4, 6);

    if (year1 > year2) return 1;
    else if (year1 < year2) return -1;
    else if (week1 > week2) return 1;
    else if (week1 < week2) return -1;
    else return 0;
}

/**
 * isValidWeek()
 * ================
 *
 * Checks the Week No  is valid or not(in YYYYWW or WW format)
 *
 * Parameters
 * ----------
 * <Parameter1> - Week No 
 * <Parameter2> - format 
 *
 * Return value
 * ------------
 * Boolean (true=valid)
 */

function isValidWeek(value1,dataFormat) {
    var weekNo;
	if(value1 == null || value1.length == 0){
		return false;
	}
    if(!isInteger(value1) ){
		return false;
	}
	if(value1 <= 0){
		return false;
	}
	if(dataFormat == 'YYYYWW'){
	    if(value1.length != 6){
		    return false;
		}
		if(value1.substring(0, 4) == '0000'){
			return false;
		}
		weekNo = value1.substring(4, 6);
	} else {//'WW' format
		if(value1.length != 2){
			return false;
		}
		weekNo = value1.substring(0, 2);
	}
	if(weekNo <= 0 || weekNo >= 54){
		return false;
	}
	return true;
}


/**
 * getNoOfWeeks()
 * ================
 *
 * Method to calculate differences between two weeks (in YYYYWW format)
 *
 * Parameters
 * ----------
 * <Parameter1> - <From Date> : the date to be in YYYYWW format <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <To   Date> : the date to be in YYYYWW format <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Number> -   No of weeks difference between 2 parameters including both the week nos passed as param
 */
function getNoOfWeeks(value1, value2) {
   var week1, week2;
   var year1, year2;
   var totYear, totWeek;
   var maxWeek = 53;

    re = new RegExp("/","g");
    value1 = value1.replace(re,"");
    value2 = value2.replace(re,"");

    year1 = parseInt(value1.substring(0, 4));
    week1 = parseInt(value1.substring(4, 6)-0);

    year2 = parseInt(value2.substring(0, 4));
    week2 = parseInt(value2.substring(4, 6)-0);
	
	totYear = year2 - year1;	
	totWeek = 0;
	if(totYear == 0){
		totWeek = (week2 - week1) + 1;
	} else if(totYear == 1){
		totWeek = (maxWeek - week1) + 1;
		totWeek = totWeek + week2;
	} else if(totYear > 1){
		totWeek = (maxWeek - week1) + 1;
		totWeek = totWeek + week2;
		totWeek = totWeek + ((totYear-1)*maxWeek);
	}
    return totWeek;
}

/**
 * getNoOfMonths()
 * ================
 *
 * Method to calculate differences between two Months (in YYYYWW format)
 *
 * Parameters
 * ----------
 * <Parameter1> - <From Date> : the date to be in YYYYMM format <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <To   Date> : the date to be in YYYYMM format <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Number> -   No of weeks difference between 2 parameters including both the month nos passed as param
 */
function getNoOfMonths(value1, value2) {
   var month1, month2;
   var year1, year2;
   var totYear, totMonth;
   var maxMonth = 12;

    re = new RegExp("/","g");
    value1 = value1.replace(re,"");
    value2 = value2.replace(re,"");

    year1 = parseInt(value1.substring(0, 4));
    month1 = parseInt(value1.substring(4, 6)-0);

    year2 = parseInt(value2.substring(0, 4));
    month2 = parseInt(value2.substring(4, 6)-0);
	
	totYear = year2 - year1;	
	totMonth = 0;
	if(totYear == 0){
		totMonth = (month2 - month1) + 1;
	} else if(totYear == 1){
		totMonth = (maxMonth - month1) + 1;
		totMonth = totMonth + month2;
	} else if(totYear > 1){
		totMonth = (maxMonth - month1) + 1;
		totMonth = totMonth + month2;
		totMonth = totMonth + ((totYear-1)*maxMonth);
	}
    return totMonth;
}

/**
 * dateDiff()
 * ================
 *
 * Method to get no of days between two dates (in DD/MM/YYYY format)
 *
 * Parameters
 * ----------
 * <Parameter1> - <From Date> : the date to be in DD/MM/YYYY format <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <To   Date> : the date to be in DD/MM/YYYY  format <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Number> -   No of Days between 2 dates inlcuding both the dates.
 */
function dateDiff(value1, value2){
	re = new RegExp("/","g");
    value1 = value1.replace(re,"");
    value2 = value2.replace(re,"");
	
	//Set the two dates
	var fromDate = new Date(value1.substring(4, 8), value1.substring(2, 4) - 1, value1.substring(0, 2)); //Month is 0-11 in Javascript
	var toDate   = new Date(value2.substring(4, 8), value2.substring(2, 4) - 1, value2.substring(0, 2)); //Month is 0-11 in Javascript

	//Get 1 day in milliseconds
	var one_day=1000*60*60*24

	//Calculate difference btw the two dates, and convert to days
	return Math.ceil((toDate.getTime() - fromDate.getTime())/(one_day)) + 1;

}

/**
 * DaysArray()
 * ================
 *
 * To get the days array (Used Internally)
 *
 * Parameters
 * ----------
 * <Parameter1> - <Year> MANDATORY MUST BE PASSED BY USER
 *
 * Return value
 * ------------
 * <Array> - Days
 */
function DaysArray(n) {
    for (var i = 1; i <= n; i++) {
        this[i] = 31
        if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
        if (i==2) {this[i] = 29}
   }
   return this
}

////////////////////////////////// VALIDATIONS FOR DATES - END /////////////////////////////////////
/**
 * setErrorColor()
 * ================
 *
 * Method to Set the ERROR color in a field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 */
function setErrorColor(aField)
{
    aField.style.background = BG_ERR_CLR;
    aField.style.color = FG_ERR_CLR;
}

/**
 * setNormalColor()
 * ================
 *
 * Method to Set the NORMAL color in a field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 */
function setNormalColor(oElement)
{
    oElement.style.background = BG_DEF_CLR;
    oElement.style.color = FG_DEF_CLR;
}

/**
 * mandatoryCheck()
 * ================
 *
 * Method to check that value has been entered or not
 *
 * Parameters
 * ----------
 * <Parameter1> - <Field> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <String> <Optinal> - <Tab Name>
 *
 * Return value
 * ------------
 * <Boolean> - <TRUE - Value is entered , FALSE - Value is not entered>
 *
 */
function mandatoryCheck(aField, astrVisibleTab)
{
    var lstrValue = aField.value;
    if( lstrValue == null || (trimString(lstrValue)).length == 0){
        //showError("FE0001",FE0001,  aField ,null, astrVisibleTab);
        return false;
    }
    return true;
}


/**
 * mandatoryCheckNoSpaces()
 * ================
 *
 * Method to check that value has been entered or not,remove spaces if present
 *
 * Parameters
 * ----------
 * <Parameter1> - <Field> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <String> <Optinal> - <Tab Name>
 *
 * Return value
 * ------------
 * <Boolean> - <TRUE - Value is entered , FALSE - Value is not entered>
 *
 */
function mandatoryCheckNoSpaces(aField, astrVisibleTab)
{
    var lstrValue = aField.value;
    if( lstrValue == null || (trimString(lstrValue)).length == 0){
        //showError("FE0001",FE0001,  aField, null, astrVisibleTab);
        return false;
    }
    return true;
}

/**
 * isComboSelected()
 * ================
 *
 * Method to check if value has been selected in combo bos or not
 *
 * Parameters
 * ----------
 * <Parameter1> - <Field> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <String> <OPTIONAL>
 *
 * Return value
 * ------------
 * <Boolean> - <TRUE - Value is selected , FALSE - Value is not selected>
 *
 */

function isComboSelected(aField, astrVisibleTab)
{
    var lstrValue = aField.value;
    if( lstrValue == null || lstrValue == ""){
        //showError("FE0001",FE0001,  aField, null, astrVisibleTab);
        return false;
    }
    return true;
}

/**
 * hideMask_Number()
 * ================
 *
 * Method to remove the number format from the field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Number Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 *
 */
function hideMask_Number(aField)
{
    lstrValue = aField.value;
    re = new RegExp(",","g");
    aField.value = lstrValue.replace(re,"");
    aField.select();
}


/**
 * putMask_Number()
 * ================
 *
 * Method to put the number format to the field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Number Field> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <Number of Digits before decimal> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter3> - <Number of Digits after decimal>
 *
 * Return value
 * ------------
 *
 */
function putMask_Number(aField, aintDigits, aintDecimals)
{
   var lreComma = new RegExp(",","g");

    lstrValue = aField.value;
   lstrValue = lstrValue.replace(lreComma,"");

    // Curtailing Blank spaces from the begining and end of the entered text
    lstrValue = trimString(lstrValue);

    if( lstrValue == null || lstrValue.length == 0 ){
       aField.value = lstrValue;
       return;
    }
    var posNeg=lstrValue.indexOf('-');

    // Get the number of digits that can be there before period (.)
    lintLen = aintDigits;
    // Get the number of digits that can be there after period (.)
    lDeciLen = aintDecimals;

    allVal = lstrValue.split(".")

    if(posNeg != 0) {
        intVal = allVal[0];
    } else {
        intVal = allVal[0].substring(1,allVal[0].length);
    }

    floatVal = allVal[1];

   var i = intVal.length;

   while(i >= 1) {

      if(intVal.indexOf("0",0) == 0 ) {
         intVal = intVal.substring(1);
      }
      i = i-1;
   }

    if(intVal==null || intVal.length==0 ){
        intVal = "0";
    }

    if(allVal.length > 1){
        // Validating Float
        if(!validateFloat(lstrValue,lintLen,lDeciLen,true)){
            return;
        }
    }else{
        // Validating Integer
        if(!isInteger(intVal)){
            return;
        }
    }
    if(intVal.length > lintLen) {
        intVal = intVal.substring(0,lintLen);
    }
    if(allVal.length > 1){
        if(floatVal.length > lDeciLen) {
            floatVal = floatVal.substring(0,lDeciLen);
        } else if(floatVal.length < lDeciLen) {
            temp = floatVal.length;
            for(i = 0;i<(lDeciLen - temp);i++) {
                floatVal = floatVal + "0";
            }
        }
    }else{
        floatVal = "";
        for(i = 0;i<lDeciLen ;i++) {
            floatVal = floatVal + "0";
        }
    }
    remString = intVal;
    finalString = "";
    if(lintLen > 3) {
        while(remString.length > 3)
        {

            finalString = "," + remString.substring(remString.length-3) +  finalString;
            remString = remString.substring(0,remString.length-3);
        }
    }
    finalString = remString + finalString ;
    finalString = finalString + "." + floatVal;
    aField.value = ((posNeg == 0 && finalString != 0)?'-':'') + finalString;
}



/**
 * get_Number_WithOut_Mask()
 * ================
 *
 * Method to remove the number format from the field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Number Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * The number without the mask
 */
function get_Number_WithOut_Mask(aField)
{
    lstrValue = aField.value;
    re = new RegExp(",","g");
    return lstrValue.replace(re,"");
}




/**
 * putMask_Number_Value()
 * ================
 *
 * Method to put the number format to the field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Number Value> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <Number of Digits before decimal> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter3> - <Number of Digits after decimal>
 *
 * Return value
 * ------------
 *
 */
function putMask_Number_Value(aValue, aintDigits, aintDecimals)
{
    lstrValue = ""+aValue;
    re = new RegExp(",","g");
    lstrValue = lstrValue.replace(re,"");

    // Curtailing Blank spaces from the begining and end of the entered text
    lstrValue = trimString(lstrValue);

    if( lstrValue == null || lstrValue.length == 0 ){
       return;
    }
    var posNeg=lstrValue.indexOf('-');

    // Get the number of digits that can be there before period (.)
    lintLen = aintDigits;
    // Get the number of digits that can be there after period (.)
    lDeciLen = aintDecimals;

    allVal = lstrValue.split(".")

    if(posNeg != 0) {
        intVal = allVal[0];
    } else {
        intVal = allVal[0].substring(1,allVal[0].length);
    }

    floatVal = allVal[1];

   var i = intVal.length;

   while(i >= 1) {

      if(intVal.indexOf("0",0) == 0 ) {
         intVal = intVal.substring(1);
      }
      i = i-1;
   }

    if(intVal==null || intVal.length==0 ){
        intVal = "0";
    }

    if(allVal.length > 1){
        // Validating Float
        if(!validateFloat(lstrValue,lintLen,lDeciLen,true)){
            return;
        }
    }else{
        // Validating Integer
        if(!isInteger(intVal)){
            return;
        }
    }
    if(intVal.length > lintLen) {
        intVal = intVal.substring(0,lintLen);
    }
    if(allVal.length > 1){
        if(floatVal.length > lDeciLen) {
            floatVal = floatVal.substring(0,lDeciLen);
        } else if(floatVal.length < lDeciLen) {
            temp = floatVal.length;
            for(i = 0;i<(lDeciLen - temp);i++) {
                floatVal = floatVal + "0";
            }
        }
    }else{
        floatVal = "";
        for(i = 0;i<lDeciLen ;i++) {
            floatVal = floatVal + "0";
        }
    }
    remString = intVal;
    finalString = "";
    if(lintLen > 3) {
        while(remString.length > 3)
        {

            finalString = "," + remString.substring(remString.length-3) +  finalString;
            remString = remString.substring(0,remString.length-3);
        }
    }
    finalString = remString + finalString ;
    finalString = finalString + "." + floatVal;
    return ((posNeg == 0 && finalString != 0)?'-':'') + finalString;
}


////////////////////////////////// STRING FUNCTIONS- BEGIN /////////////////////////////////////

/**
 * trimString()
 * ================
 *
 * Method to remove the left and right curtailing spaces
 *
 * Parameters
 * ----------
 * <Parameter1> - <String> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <String> - <Resulted String >
 */
function trimString(astrValue)
{
  var lstrValue = astrValue;

  lstrValue=leftTrimString(lstrValue);
  lstrValue=rightTrimString(lstrValue);
  return lstrValue;
}


/**
 * leftTrimString()
 * ================
 *
 * Method to Trim the blank spaces on the left side of the string
 *
 * Parameters
 * ----------
 * <Parameter1> - <String> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <String> - <Resulted String >
 */
function leftTrimString(astrValue)
{
  var lstrValue = astrValue;

  lstrValue=lstrValue.replace(/^\s*(.*)/, "$1");
  return lstrValue;
}


/**
 * rightTrimString()
 * ================
 *
 * Trim the blank spaces on the right side of the string
 *
 * Parameters
 * ----------
 * <Parameter1> - <String> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <String> - <Resulted String >
 */
function rightTrimString(astrValue)
{
  var lstrValue = astrValue;

  lstrValue=lstrValue.replace(/(.*?)\s*$/, "$1");
  return lstrValue;
}


/**
 * isEmpty()
 * ================
 *
 * Check whether string s is empty.
 *
 * Parameters
 * ----------
 * <Parameter1> - <String>
 *
 * Return value
 * ------------
 * <Boolean> - <True if empty else FALSE>
 */
function isEmpty(lstrValue)
{
    lstrValue=leftTrimString(lstrValue);
    lstrValue=rightTrimString(lstrValue);

    return ((lstrValue == null) || (lstrValue.length == 0))
}
////////////////////////////////// STRING FUNCTIONS- END /////////////////////////////////////

////////////////////////////////// MASK FUNCTIONS- BEGIN /////////////////////////////////////

/**
 * putMask_YearMonthDate()
 * ================
 *
 * Put the Mask 'YYYY/MM' on a Date field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Date Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 */
function putMask_YearMonthDate(oElement)
{
    var lstrValue = oElement.value;
    if(lstrValue == "" || !isInteger(lstrValue))
    return;

    re = new RegExp("/","g");
    lstrValue = lstrValue.replace(re,"");
    if (lstrValue.length == 6) {
        partOne = lstrValue.substring(0,4);
        partTwo = lstrValue.substring(4);
        oElement.value = partOne + "/" +partTwo;
    }
}


/**
 * hideMask_YearMonthDate()
 * ================
 *
 * Remove the Mask 'YYYY/MM' from a Date field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Date Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 */
function hideMask_YearMonthDate(oElement)
{
    var lstrValue = oElement.value;

    re = new RegExp("/","g");
    oElement.value = lstrValue.replace(re,"");
    oElement.select();
}


/**
 * hideMask_Date()
 * ================
 *
 * Method to remove the Date Mask
 *
 * Parameters
 * ----------
 * <Parameter1> - <Date Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 */
function hideMask_Date(oElement)
{
    var lstrValue = oElement.value;

    re = new RegExp("/","g");
    oElement.value = lstrValue.replace(re,"");
    oElement.select();
}


/**
 * putMask_Date()
 * ================
 *
 * Method to Put the Date Mask
 *
 * Parameters
 * ----------
 * <Parameter1> - <Date Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 */
function putMask_Date(oElement)
{
    var lstrValue = oElement.value;
    if(lstrValue == "" || !isValidDate(lstrValue))
    return;

    re = new RegExp("/","g");
    lstrValue = lstrValue.replace(re,"");

    lstrValue = lstrValue.toUpperCase();
    if (lstrValue.length == 8) {
        partOne = lstrValue.substring(0,2);
        partTwo = lstrValue.substring(2,4);
        partThree = lstrValue.substring(4);
        oElement.value = partOne + "/" +partTwo + "/" +partThree;
    }
}

/*
* For scrolling of header section when the scroll bar of data section is scrolled.
* called in onScroll event of Data section of the table.
* NOTE: METHOD USED INTERNALLY.
*/
function divData()
{
    oElement = document.getElementById(headingDivisionID);
    if(oElement != null) {
        oElement .scrollLeft = event.srcElement.scrollLeft;
    }
}

 function setScroll(len )
 {
         oElement = document.getElementById("DivData");
        if(oElement != null) {
            oElement .scrollLeft = event.srcElement.scrollLeft + len;
        }
 }


////////////////////////////////// MASK FUNCTIONS- END /////////////////////////////////////
/**
 * openChildWindow()
 * ================
 *
 * Function to open child screen
 *
 * Parameters
 * ----------
 * <Parameter1> - <SCREEN_URL> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <WINDOW_OBJ> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter3> - <WIDTH>      <OPTIONAL>
 * <Parameter4> - <HEIGHT>     <OPTIONAL>
 *
 * Return value - void
 * ------------
 */
function openChildWindow(){
    setErrorFlag();
    var lstrWidth  = '750px';//set default width
    var lstrHeight = '450px';//set default height
    var lstrURL;
    var lstrArgument;

    lstrURL = openChildWindow.arguments[0];
    if( lstrURL.indexOf("?") == -1 ) {
        lstrURL = lstrURL + "?childFw=Y" ;
    } else {
        lstrURL = lstrURL + "&childFw=Y" ;
    }
    lstrURL  = encodeURI(lstrURL);
    lstrArgument   = openChildWindow.arguments[1];

    //set the width
    if(openChildWindow.arguments[2] != null && openChildWindow.arguments[2].length > 0 ){
        lstrWidth= openChildWindow.arguments[2];
    }

    //set the height
    if(openChildWindow.arguments[3] != null && openChildWindow.arguments[3].length > 0 ){
        lstrHeight= openChildWindow.arguments[3];
    }

    // for appending the readonly flag of Parent Screen
    if(document.getElementById('readOnlyFlg') != null && document.getElementById('readOnlyFlg')!= undefined){
        if(lstrURL.indexOf('?') != -1 ){
            lstrURL = lstrURL+ '&childScreen=true&readOnlyFlg='+document.getElementById('readOnlyFlg').value;
        }else{
            lstrURL = lstrURL+ '?childScreen=true&readOnlyFlg='+document.getElementById('readOnlyFlg').value;
        }
    }

    //open model dialog
    window.showModalDialog(lstrURL,lstrArgument, 'dialogHeight:' + lstrHeight + ';dialogWidth:' + lstrWidth + ';center:yes;status:no');
    // Set Error Flag to true so that Buttons are not disabled of parent
    isErrFlg = true;
}

function getDisplayMonth(iMonth) {

    // pass in an month as an integer
    // return the month string

    var monthArray = new Array("January","Febuary","March","April","May","June","July","August","September","October","November","December");

    return monthArray[iMonth];
}

function getDisplayDate() {

    // uses getDisplayMonth()
    // returns passed Date formatted nicely
    // Month day, Year  mmmm dd, yyyy

    theDate = new Date();

    // split into day, month, year
    iDay = theDate.getDate();
    iMonth = theDate.getMonth();
    iYear = theDate.getFullYear();

    sDisplayDate = iDay +  " " + getDisplayMonth(iMonth) + " " + iYear;

    return sDisplayDate;
}




/**
 * checkNoDataToSave_()
 * ================
 *
 * Function to check if there is any data in the table to Save
 * Assumes that the status column in the table has been defined by the name 'status'
 *
 * Parameters
 * ----------
 * <Parameter1> - <Table ID> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value - <TRUE - if data in the table or FALSE - if no data in the table>
 * ------------
 */
function checkNoDataToSave_()
{
   var table =  document.getElementById(arguments[0]);
   var objStatus = document.getElementById('value[' + 0 + '].status');
   numrows = table.rows.length;
   var count = 0;
   if(numrows <= 0)
   {
      return false;
   }
   else if(objStatus == null)
   {
      return false;
   }
   else
   {
      for(i=0;;i++)
      {
         var lobjStatus = document.getElementById('value[' + i + '].status');
         if(lobjStatus == null) {
            break;
         }

         var lstrStatus = lobjStatus.value;

         if(lstrStatus == HIDE)
         {
            continue;
         }
         count++;
         break;
      }
   }
   if(count == 0)
   {
      return false;
   }

   return true;
}



/**
 * checkNoChangesToSave_()
 * ================
 *
 * Function to check if there are any changes to be saved
 * Assumes that the status column in the table has been defined by the name 'status'
 *
 * Parameters
 * ----------
 *
 * Return value - <TRUE - if chages made or FALSE - if no changes>
 * ------------
 */
function checkNoChangesToSave_()
{
    var count = 0;
    for(i=0;;i++)
    {
        var str = 'value[' + i + '].status';
        var obj = document.getElementById(str);
        if(obj == null)
        {
            break;
        }
        var lstrStatus = obj.value;

        if(lstrStatus == HIDE || lstrStatus == '')
        {
            continue;
        }
        count++;
        break;
    }
    if(count == 0)
    {
        return false;
    }

    return true;
}



/**
 * updateRowColor()
 * ================
 *
 * Function to update the color of the rows in the table
 * To be called from ADD button
 * Assumes that the status column in the table has been defined by the name 'status'
 *
 * Parameters
 * ----------
 *
 * Return value
 * ------------
 */
function updateRowColor()
{
    // Re-arrange the colors
    for(j=0,k=0;;j++)
    {
        var str = 'value[' + j + '].status';
        var obj = document.getElementById(str);
        if(obj == null)
        {
            break;
        }
        if(obj.value != HIDE)
        {
            var SelectedRow = document.getElementById('row' + j);
            SelectedRow.className = (k%2==0?"firstRow":"secondRow");
            k++;
        }
    }
}




/**
 * isSelected()
 * ================
 *
 * Function to check if any checkbox is selected or not
 * Assumes that the checkbox column in the table has been defined by the name 'selected'
 *
 * Parameters - <Table ID> <MANDATORY MUST BE PASSED BY USER>
 * ----------
 *
 * Return value - <TRUE if selected else FALSE>
 * ------------
 */
function isSelected() {
    var table =  document.getElementById(arguments[0]);
    var numrows = table.rows.length;
    if(numrows <= 0) {
        return false;
    }
    var chk = 0;
    for(i=0;;i++){
        var str = 'value[' + i + '].selected';
        var obj = document.getElementById(str);
        if(obj == null) {
            break;
        }
        if(obj.checked) {
            chk=1;
            break;
        }
    }

    if(chk==1) {
        return true;
    } else {
        return false;
    }
}




/**
 * delRow()
 * ================
 *
 * Function to delete the row in table
 * Assumes that the checkbox column in the table has been defined by the name 'selected'
 * Assumes that the status column in the table has been defined by the name 'status'
 *
 * Parameters - <Table ID> <MANDATORY MUST BE PASSED BY USER>
 * ----------
 *
 * Return value
 * ------------
 */
function delRow() {

    var chk = 0;

    for(i=0;;i++){
        var str = 'value[' + i + '].selected';
        var obj = document.getElementById(str);
        if(obj == null) {
            break;
        }
        if(obj.checked) {
            chk=1;
            var str1 = document.getElementById('value[' + i + '].status').value;

            if(str1 == HIDE) {
                continue;
            }
            var name = "value["+i+"].status";
            if(str1 == ADD) {

                document.getElementById(name).value = HIDE;
                document.getElementById(arguments[0]).rows[i].cells[0].innerHTML =
                    "<div style='width:46px'>"+HIDE+"</div>";
                var SelectedRow = document.getElementById('row' + i);
                SelectedRow.style.display = "none";


            } else if(str1 == DEL) {
                document.getElementById(name).value = '';
                document.getElementById(arguments[0]).rows[i].cells[0].innerHTML =
                    "<div style='width:46px'></div>";


            } else {

                document.getElementById(name).value = DEL;
            document.getElementById(arguments[0]).rows[i].cells[0].setAttribute("align","CENTER");
                document.getElementById(arguments[0]).rows[i].cells[0].innerHTML =
                    "<div style='width:46px'>"+DEL+"</div>";
            }
            obj.checked=false;

        }
    }

    updateRowColor();

}



/**
 * checkDuplicacy()
 * ================
 *
 * Function to check duplicacy in table
 * Assumes that the status column in the table has been defined by the name 'status'
 *
 * Parameters 1 - <Table ID> <MANDATORY MUST BE PASSED BY USER>
 * Parameters 2 - Array of Column Names to be checked <MANDATORY MUST BE PASSED BY USER>
 * Parameters 3 - Concatenated value of the PK <MANDATORY MUST BE PASSED BY USER>
 * ----------
 *
 * Return value - <TRUE if duplicate rows else FALSE>
 * ------------
 */
function checkDuplicacy()
{
    var table =  document.getElementById(arguments[0]);
    var numRows = table.rows.length;
    if (numRows <= 0)
    {
        return false;
    }

    var PKColumns = arguments[1];
    var numOfPKColumns = PKColumns.length;

    var inputValue = arguments[2];

    var concat = '';

    for (i=0;i< numRows ;i++ )
    {
        concat = '';
        if (document.getElementById('value[' + i + '].status').value == HIDE || document.getElementById('value[' + i + '].status').value == DEL)
        {
            continue;
        }
        else
        {
            for(j=0; j < numOfPKColumns - 1; j++)
            {
                var str = 'value[' + i + '].' + PKColumns[j+1];
                var obj = document.getElementById(str);
                concat = concat + obj.value;
            }

            if (concat == inputValue)
            {
                return true;
            }
        }
    }
    return false;


}

/**
 * checkDuplicacyTable()
 * ================
 *
 * Function to check duplicacy in table
 * Assumes that the status column in the table has been defined by the name 'status'
 *
 * Parameters 1 - <Table ID> <MANDATORY MUST BE PASSED BY USER>
 * Parameters 2 - Array of Column Names to be checked <MANDATORY MUST BE PASSED BY USER>
 * ----------
 *
 * Return value - <TRUE if duplicate rows else FALSE>
 * ------------


function  checkDuplicacyTable()
{
    var table =  document.getElementById(arguments[0]);
    var numRows = table.rows.length;
    if (numRows <= 0)
    {
        return false;
    }

   var PKColumns = arguments[1];
    var numOfPKColumns = PKColumns.length;

    var concat = '';
   var inputValue = '';
    for (i=0;i< numRows ;i++ )
    {
        concat = '';
        if (document.getElementById('value[' + i + '].status').value == HIDE || document.getElementById('value[' + i + '].status').value == DEL)
        {
            continue;
        }
        else
        {
         // Picking the value of row in first loop
         for(j=0; j < numOfPKColumns; j++)
            {
                var str = 'value[' + i + '].' + PKColumns[j];
                var obj = document.getElementById(str);
                concat = concat + obj.value;
            }

         for(k=i+1; k < numRows; k++) {
            if (document.getElementById('value[' + k + '].status').value == HIDE || document.getElementById('value[' + k + '].status').value == DEL)
            {
               continue;
            }
            inputValue = '';

            // Picking the value of row in second loop
            for(j=0; j < numOfPKColumns ; j++)
            {
               var str = 'value[' + k + '].' + PKColumns[j];
               var obj = document.getElementById(str);
               inputValue = inputValue + obj.value;
            }
            if (concat == inputValue)
            {
               var str = 'value[' + k + '].' + PKColumns[0];
               var obj = document.getElementById(str);
               // Set Error
               setErrorColor(obj);
               // Set Focue
               obj.focus();
               return true;
            }

         }
        }
    }
   return false;
}
*/

function  checkDuplicacyTable()
{
   var table =  document.getElementById(arguments[0]);
   var numRows = table.rows.length;
   if (numRows <= 0)
   {
      return false;
   }

   var PKColumns = arguments[1];
   var numOfPKColumns = PKColumns.length;
   var concatRowPK = '~';
   var concatAllRowsPK = '';
   var inputValue = '';
   for (i=numRows-1;i >= 0;i-- )
   {
      concatRowPK = '~';
      if (document.getElementById('value[' + i + '].status').value == HIDE || document.getElementById('value[' + i + '].status').value == DEL)
      {
         continue;
      }
      else
      {
         // Picking the value of row in first loop
         for(j=0; j < numOfPKColumns; j++)
         {
            var str = 'value[' + i + '].' + PKColumns[j];
            var obj = document.getElementById(str);
            concatRowPK = concatRowPK + obj.value + '~';
         }

         if (concatAllRowsPK.indexOf(concatRowPK) == -1) {
                concatAllRowsPK = concatAllRowsPK + '~~' + concatRowPK;
         } else {
            return true;
         }
      } // end else
   } // end for loop
   return false;
}


/**
 * checkDuplicacyTableColorChange()
 * ================
 *
 * Function to check duplicacy in table and change the color row to red
 * Assumes that the status column in the table has been defined by the name 'status'
 *
 * Parameters 1 - <Table ID> <MANDATORY MUST BE PASSED BY USER>
 * Parameters 2 - Array of Column Names to be checked <MANDATORY MUST BE PASSED BY USER>
  * Return value - <TRUE if duplicate rows else FALSE>
 *             */

function  checkDuplicacyTableColorChange() {
   var table =  document.getElementById(arguments[0]);
   var numRows = table.rows.length;
   var isDuplicate = false;
   if (numRows <= 0)
   {
      return false;
   }

   var PKColumns = arguments[1];
   var numOfPKColumns = PKColumns.length;
   var concatRowPK = '~';
   var  arrTest= new Array(numRows);
   if(numRows>1)
   {
   for (i=0;i <numRows ;i++ )
   {
      concatRowPK = '~';
      if (document.getElementById('value[' + i + '].status').value == HIDE || document.getElementById('value[' + i + '].status').value == DEL)
      {
         continue;
      }  // end if
      else
      {
         // Picking the value of row in first loop
         for(j=0; j < numOfPKColumns; j++)
         {
            var str = 'value[' + i + '].' + PKColumns[j];
            var obj = document.getElementById(str);
            concatRowPK = concatRowPK + obj.value + '~';
         }
           //Check if key exists in the array
         if (concatRowPK in arrTest) {
            var v =   parseInt(arrTest[concatRowPK]-0);
            document.getElementById("row"+v).className ="redRow";
            document.getElementById("row"+i).className ="redRow";
            isDuplicate = true;
         } else {
            //if key is not added in array then add
             arrTest[concatRowPK] = i;

         }   // end else
         } // end else
      }     // end for loop
   }   // end if
   // if the duplicate parts exists then return true
   if(isDuplicate)
   {
   return true;
   }
   return false;
}//end of checkDuplicacyTableColorChange function

/**
 * checkPKChanged()
 * ================
 *
 * Function to check if PK is changed
 *
 * Parameters 1 - <ROW ID> <MANDATORY MUST BE PASSED BY USER>
 * Parameters 2 - Array of Column Names to be checked <MANDATORY MUST BE PASSED BY USER>
 * Parameters 3 - Concatenated value of the PK <MANDATORY MUST BE PASSED BY USER>
 * ----------
 *
 * Return value - <TRUE if PK changed else FALSE>
 * ------------
 */
function checkPKChanged() {
    var rowID = arguments[0];
    var PKColumns = arguments[1];
    var inputValue = arguments[2];

    var numOfPKColumns = PKColumns.length;
    var concat = '';

    for (i = 0; i < numOfPKColumns; i++)
    {
        concat = concat + document.getElementById('value[' + rowID + '].' + PKColumns[i]).value;
    }

    if(concat != inputValue)
    {
        return true;
    }
    return false;
}


/**
 * hideMask_PartNumber()
 * ================
 *
 * Method to remove the part number format from the field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Part Number Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 *
 */
function hideMask_PartNumber(aField)
{
    var lobjFrcFw = handlePartFranchise( '1', aField, '' , arguments[1]);
    var lstrFrcLen ;
    if( lobjFrcFw != null ) {
       lstrFrcLen = lobjFrcFw.value.length;
    } else {
       lstrFrcLen = 0
    }
    lstrValue = aField.value.substring(lstrFrcLen);
    re = new RegExp("-","g");
    aField.value = lstrValue.replace(re,"");
    aField.select();
}

function handlePartFranchise()
{
    var lstrFieldName = arguments[1].name ;
    var lintIndexBrk  = lstrFieldName.indexOf('[');
    var lintLastIndexBrk  = lstrFieldName.indexOf(']');
    var lstrCurrRow   = '';
    var nameFrCdFw  ;
    var table ;
    var lstrFranchise = arguments[2];
    // Franchise is not passed
    if( lstrFranchise == null ) {
        lstrFranchise = '';
    }

    var refFrCdFw ;
    // Get Current Row
    if( lintIndexBrk != -1 ) {
        lstrCurrRow   = lstrFieldName.substring(lintIndexBrk + 1,lintLastIndexBrk) ;
        if( arguments[3] != null ) {
            table = document.getElementById(arguments[3]);
            nameFrCdFw = "value["+lstrCurrRow+"]." + arguments[3] + "frmFwFrcCd";
        } else {
            table = document.getElementById("DataTable");
            nameFrCdFw = "value["+lstrCurrRow+"].frmFwFrcCd";
        }

        var rowFw   = table.rows(lstrCurrRow-0);
        var numcols = rowFw.cells.length
        refFrCdFw   = document.getElementById(nameFrCdFw);
        // if Object doesn't exists
        if( refFrCdFw == null ) {
            var cellFrCdFw = rowFw.insertCell(numcols);

            cellFrCdFw.innerHTML = '<TD><input type="hidden" name="' +  nameFrCdFw +'" value="' + lstrFranchise + '"></TD>';
        }
    } else {
        refFrCdFw =  document.forms[0].frmFwFrcCd ;
    }

    if( arguments[0] == '0' && refFrCdFw != null ) {
        refFrCdFw.value = lstrFranchise ;
    }

    return refFrCdFw ;

}

/**
 * putMask_PartNumber()
 * ================
 *
 * Method to put the part number format to the field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Part Number Field> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <Format Mask for Field> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter3> - <Franchise for Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 *
 */
function putMask_PartNumber(aField, aMask, aFranchise){

    var lstrValue   = aField.value;
    var finalString = '';
    var lintIndex   = -1;
    var lintReplaceIndex = -1;
    var lstrFormatMask = aMask;

    handlePartFranchise( '0', aField, aFranchise, arguments[3]);

    if(validatePartNo(aField)) {
        lstrValue = trimString(lstrValue);
        lstrValue = lstrValue.toUpperCase();

        if( aFranchise != null && aFranchise.length > 0 )
        {
            lstrValue = lstrValue.substring(1);
        }
        re = new RegExp("-","g");
        lstrValue = lstrValue.replace(re,'');

        finalString = lstrValue;

        if(lstrFormatMask != null && lstrFormatMask.length >0 ){
            lstrFormatMask = trimString(aMask.toUpperCase());

            while((lintIndex = lstrFormatMask.indexOf("-")) > -1){
                lintReplaceIndex = lintReplaceIndex + lintIndex + 1;
                if(lintReplaceIndex < finalString.length){
                    finalString = finalString.substring(0,lintReplaceIndex) +
                    '-' +
                    finalString.substring(lintReplaceIndex);
                }else{
                    break;
                }
                lstrFormatMask = lstrFormatMask.substring(lintIndex +1);
            }
        }
        if( aFranchise != null && aFranchise.length > 0 )
        {
            finalString = aFranchise + '-' + finalString;
        }

        aField.value = finalString;

    }
}

/**
 * validatePartNo()
 * ================
 *
 * Method to validate the part number
 *
 * Parameters
 * ----------
 * <Parameter1> - <Part Number Field> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 *
 */
function validatePartNo(aField)
{
   var lstrValue = aField.value;
   var lchrTemp;

    re = new RegExp("-","g");
    lstrValue = lstrValue.replace(re,"");

/*   for(i=0;i<lstrValue.length;i++) {

       lchrTemp = lstrValue.charAt(i);
            if (!(  (lchrTemp >= 'A' && lchrTemp <= 'Z')
                  || (lchrTemp >= 'a' && lchrTemp <= 'z')
                  || (lchrTemp >= '0' && lchrTemp <= '9'))) {
                return false;
            }
   }*/

   return true;
}//End of validatePartNo


/**
 * putMask_Integer()
 * ================
 *
 * Method to put the number format to the field
 *
 * Parameters
 * ----------
 * <Parameter1> - <Number Field> <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <Number of Digits before decimal> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 *
 */
function putMask_Integer(aField, aintDigits)
{
   intVal = aField.value;

   re = new RegExp(",","g");
   intVal = intVal.replace(re,"");

   lintLen = aintDigits;
    // Curtailing Blank spaces from the begining and end of the entered text
    intVal = trimString(intVal);

    if( intVal == null || intVal.length == 0 ){
       aField.value = intVal;
       return;
    }
    var posNeg=intVal.indexOf('-');

    // Validating Integer
    if(!isInteger(intVal)){
        return;
    }
    if(intVal.length > lintLen) {
        intVal = intVal.substring(0,lintLen);
    }

   remString = intVal;

   var i = remString.length;

   while(i > 1) {

      if(remString.indexOf("0",0) == 0 ) {
         remString = remString.substring(1);
      }
      i = i-1;
   }

    finalString = "";

   if(lintLen > 3) {
        while(remString.length > 3)
        {

            finalString = "," + remString.substring(remString.length-3) +  finalString;
            remString = remString.substring(0,remString.length-3);
        }
    }
    finalString = remString + finalString ;
    aField.value = ((posNeg == 0 && finalString != 0)?'-':'') + finalString;
}

/**
 * clearTable()
 * ================
 *
 * Method to put the clear data from table in case validations fail on a crtiteria
 *
 * Parameters
 * ----------
 *Parameters - <Table ID> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 *
 */
   function clearTable(aTable) {
      var myTable = document.getElementById(aTable);
      if(myTable.rows.length == 0) {
         return;
      }
      for(var i=myTable.rows.length-1; i >= 0; i--) {
         myTable.deleteRow(i);
      }
   }

/**
 * clearDiv()
 * ================
 *
 * Method to put the clear data from div
 *
 * Parameters
 * ----------
 *Parameters - <Div ID> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 *
 */
function clearDiv(aDev) {
  var myDiv = document.getElementById(aDev);
  myDiv.innerHTML='';
}

/**
 * setDisable()
 * ================
 *
 * Method to disable the field
 *
 * Parameters
 * ----------
 *Parameters - <Field ID> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 *
 */
   function setDisable(aField) {
      aField.disabled = true;
      aField.style.backgroundColor = "#EBEEEA";
   }

/**
 * setEnable()
 * ================
 *
 * Method to enable the field
 *
 * Parameters
 * ----------
 *Parameters - <Field ID> <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 *
 */
   function setEnable(aField) {
      aField.disabled = false;
      setNormalColor(aField);
   }

   /**
    * validatePageNo
    * ================
    *
    * Method to validate the page no.
    *
    * Parameters
    * ----------
    *Parameters - <objPageNo-Page No. Object> <MANDATORY MUST BE PASSED BY USER>
    *
    * Return value (true/false)
    * ------------
    *
    */
   function validatePageNo(objPageNo) {
      // No data to go
      if (!checkNoDataToSave_('DataTable')) {
         return false;
      }
      // do processing to go to desired page
      var lstrPageNo = objPageNo.value;
      //Check mandatory input
      if (!mandatoryCheck(objPageNo)) {
         return false;
      }
      //If not valid number
      if (!isInteger(lstrPageNo)) {
         //showError("FE0003", FE0003, objPageNo);
         return false;
      }
     //Cannot be zero
     if (eval(lstrPageNo) == 0 ) {
         //showError("FE0011", FE0011, objPageNo);
        return false;
     }
     objPageNo.value = lstrPageNo;
     return true;
   }

   /**
    * validatePage_NoStatus
    * ================
    *
    * Method to validate the page no of search screen having no status column.
    *
    * Parameters
    * ----------
    *Parameters - <objPageNo-Page No. Object> <MANDATORY MUST BE PASSED BY USER>
    *
    * Return value (true/false)
    * ------------
    *
    */
   function validatePage_NoStatus(objPageNo) {
      // do processing to go to desired page
      var lstrPageNo = objPageNo.value;

      //Check mandatory input
      if (!mandatoryCheck(objPageNo)) {
         return false;
      }
      //If not valid number
      if (!isInteger(lstrPageNo)) {
         //showError("FE0003", FE0003, objPageNo);
         return false;
      }
     //Cannot be zero
     if (eval(lstrPageNo) == 0 ) {
         //showError("FE0011", FE0011, objPageNo);
        return false;
     }
     objPageNo.value = lstrPageNo;
     return true;
   }

   /**
    * isValidDateTime
    * ================
    *
    * Method to validate the date Time
    *
    * Parameters
    * ----------
    *Parameters - <DateTime Object's Value> <MANDATORY MUST BE PASSED BY USER>
    *
    * Return value (true/false)
    * ------------
    *
    */
   function isValidDateTime(dtTmStr) {
      re = new RegExp("/","g");
      dtTmStr = dtTmStr.replace(re,"");

      re = new RegExp(":","g");
      dtTmStr = dtTmStr.replace(re,"");

      if(dtTmStr.length != 13) {
         return false;
      }

      // Take the Date time part in sepearte variables.
      dtStr = dtTmStr.substring(0,8);
      tmStr = dtTmStr.substring(9);
      if(!isValidDate(dtStr)) {
         return false;
      }
      if(dtTmStr.charAt(8) != " ") {
         return false;
      }
      if(!isValidTime(tmStr)) {
         return false;
      }
      return true;
   }

   /**
    * isValidTime
    * ================
    *
    * Method to validate the Time
    *
    * Parameters
    * ----------
    * Parameters - <Time value> <MANDATORY MUST BE PASSED BY USER>
    *
    * Return value (true/false)
    * ------------
    *
    */
   function isValidTime(aTimeStr) {
      var lstrValue = aTimeStr;
      re = new RegExp(":","g");
      aTimeStr = lstrValue.replace(re,"");

      if(!isInteger(aTimeStr)){
         return false;
      }

      if(aTimeStr.length < 4){
         return false;
      }

      var strHour  =aTimeStr.substring(0,2);
      var strMinute=aTimeStr.substring(2,4);
      var strSecond=aTimeStr.substring(4);
      hour    = parseInt(strHour-0);
      minute  = parseInt(strMinute-0);
      second  = parseInt(strSecond-0);
      if (hour<0 || hour>23){
         return false
      }
      if (minute < 0 || minute > 59){
         return false
      }
      if (second < 0 || second > 59){
         return false
      }
      return true;
    }

   /**
    * hideMask_DateTime()
    * ================
    *
    * Method to remove the Date-Time Mask
    *
    * Parameters
    * ----------
    * <Parameter1> - <DateTime Field> <MANDATORY MUST BE PASSED BY USER>
    *
    * Return value
    * ------------
    */
   function hideMask_DateTime(oElement)
   {
      var lstrValue = oElement.value;

      re = new RegExp("/","g");
      lstrValue = lstrValue.replace(re,"");

      re = new RegExp(":","g");
      oElement.value = lstrValue.replace(re,"");
      oElement.select();
   }


   /**
    * putMask_DateTime()
    * ================
    *
    * Method to Put the DateTime Mask
    *
    * Parameters
    * ----------
    * <Parameter1> - <DateTime Field> <MANDATORY MUST BE PASSED BY USER>
    *
    * Return value
    * ------------
    */
   function putMask_DateTime(oElement)
   {
      var lstrValue = oElement.value;
      if(lstrValue == "" || !isValidDateTime(lstrValue))
         return;

      re = new RegExp("/","g");
      lstrValue = lstrValue.replace(re,"");

      re = new RegExp(":","g");
      lstrValue = lstrValue.replace(re,"");

      lstrValue = lstrValue.toUpperCase();

      if (lstrValue.length == 15) {
         strDay    = lstrValue.substring(0,2);
         strMonth  = lstrValue.substring(2,4);
         strYear   = lstrValue.substring(4,8);
         strHour   = lstrValue.substring(9,11);
         strMinute = lstrValue.substring(11,13);
         strSecond = lstrValue.substring(13);

         oElement.value =
            strDay + "/" +strMonth + "/" +strYear + " " + strHour + ":" + strMinute + ":" + strSecond;
      }
   }

/**
 * compareDateTime()
 * ================
 *
 * Method to compare the From and To dates
 *
 * Parameters
 * ----------
 * <Parameter1> - <From Date> : the date to be in DD/MM/YYYY HH24:MI:SS format <MANDATORY MUST BE PASSED BY USER>
 * <Parameter2> - <To   Date> : the date to be in DD/MM/YYYY HH24:MI:SS format <MANDATORY MUST BE PASSED BY USER>
 *
 * Return value
 * ------------
 * <Number> -   0 if the dates are same
 *              -1 if the first one is an earlier date
 *              1 if the first one is a later date
 */
   function compareDateTime (value1, value2) {
      var date1, date2;
      var month1, month2;
      var year1, year2;
      re = new RegExp("/","g");
      value1 = value1.replace(re,"");
      value2 = value2.replace(re,"");

      re = new RegExp(":","g");
      value1 = value1.replace(re,"");
      value2 = value2.replace(re,"");


      date1= value1.substring (0, 2);
      month1 = value1.substring (2, 4);
      year1 = value1.substring (4, 8);
      hour1   = value1.substring (9, 11);
      minute1   = value1.substring (11, 13);
      second1 = value1.substring (13, 15);

      date2= value2.substring (0, 2);
      month2 = value2.substring (2, 4);
      year2 = value2.substring (4, 8);
      hour2   = value2.substring (9, 11);
      minute2   = value2.substring (11, 13);
      second2 = value2.substring (13, 15);


      if (year1 > year2) return 1;
      else if (year1 < year2) return -1;
      else if (month1 > month2) return 1;
      else if (month1 < month2) return -1;
      else if (date1 > date2) return 1;
      else if (date1 < date2) return -1;
      else if (hour1 > hour2) return 1;
      else if (hour1 < hour2) return -1;
      else if (minute1 > minute2) return 1;
      else if (minute1 < minute2) return -1;
      else if (second1 > second2) return 1;
      else if (second1 < second2) return -1;
      else return 0;
   }

   function updateStatus(arow) {
      //get the status of the selected row
      var lobjStatus = document.getElementById('value[' + arow + '].status');
      var lstrstatus = lobjStatus.value;
      if( ! updEnbDsb ) {
          if(lstrstatus == '') {
             lobjStatus.value = UPD;
             //Set status to upd
             document.getElementById("DataTable").rows[arow].cells[0].innerHTML =
                   "<div style='width:46px'>"+UPD+"</div>";
          }
      }
   }

   /**
    * putMask_Time()
    * ================
    *
    * Method to Put the Time Mask (HH24:MI)
    *
    * Parameters
    * ----------
    * <Parameter1> - <Time Field> <MANDATORY MUST BE PASSED BY USER>
    *
    * Return value
    * ------------
    */

   function putMask_Time(oElement)
   {
      var lstrValue = oElement.value;
      if(lstrValue == "" || !isValidTime(lstrValue))
         return;
      re = new RegExp(":","g");
      lstrValue = lstrValue.replace(re,"");

      lstrValue = lstrValue.toUpperCase();

      if (lstrValue.length == 4) {
         strHour   = lstrValue.substring(0,2);
         strMinute = lstrValue.substring(2,4);
         oElement.value =
            strHour + ":" + strMinute ;
      }
     }

   /**
    * hideMask_Time()
    * ================
    *
    * Method to hide the Time Mask (HH24:MI will be converted to HH24MI)
    *
    * Parameters
    * ----------
    * <Parameter1> - <Time Field> <MANDATORY MUST BE PASSED BY USER>
    *
    * Return value
    * ------------
    */
     function hideMask_Time(oElement)
   {
      var lstrValue = oElement.value;
      re = new RegExp(":","g");
      oElement.value = lstrValue.replace(re,"");
      oElement.select();
   }


   /**
    * populateBranch()
    * ================
    *
    * Method to populate Branch Combo on the basis of selected Dealer
    *
    * Parameters
    * ----------
    * None
    *
    * Return value
    * ------------
    */

 function populateBranch()
 {
    var lstrDlrCode = document.forms[0].dealer.value;
    var lstrBlankFlag=arguments[0] ;
    // dealerBranch - a hidden combo
    comboDealerBranch = eval(document.forms[0].dealerBranch);
    comboBranch = eval(document.forms[0].branch);
    for(lintI=0; lintI < comboBranch.length; lintI++)
    {
        document.forms[0].branch.options[lintI] = null;
        lintI = -1;
    }

    //Enter default record
    if(lstrBlankFlag != null && lstrBlankFlag!="" && lstrBlankFlag=="YES" ){
       document.forms[0].branch.options[document.forms[0].branch.options.length] = new Option(" ", "");
    }else{
        document.forms[0].branch.options[document.forms[0].branch.options.length] = new Option(document.AppJsp.allLabel.value, "");
    }
    for(lintI=0; lintI < comboDealerBranch.length; lintI++)
    {
        var opt= document.forms[0].dealerBranch[lintI].text;
        var value= document.forms[0].dealerBranch[lintI].value;

        var lintPos = value.indexOf("~");
        if (lintPos > -1)
        {
            var brcCode = value.substring(0, 2);
            var dlrCode = value.substring(3);
            if(dlrCode == lstrDlrCode || dlrCode == '')
            {
                with(document.forms[0].branch)
                {
                    options[options.length] = new Option(opt, brcCode);
                }
            }
        }
        /*else
        {
            document.forms[0].branch.options[document.forms[0].branch.options.length] = new Option(document.AppJsp.allLabel.value, "");
        }*/
    }
 }

//function to close screen
function closeWindow() {
      if(checkNoChangesToSave_()) {
         if(!showQuestion("FW0004", FW0004)) {
             return false;
         }
     }
     window.close();
     return false;
 }

    function changeUpper(afield) {
        afield.value = trimString(afield.value.toUpperCase());
    }

/**
 * checkDuplicacyTable_1()
 * ================
 *
 * Function to check duplicacy in table
 * Assumes that the status column in the table has been defined by the name 'status'
 *
 * Parameters 1 - <Table ID> <MANDATORY MUST BE PASSED BY USER>
 * Parameters 2 - Array of Column Names to be checked <MANDATORY MUST BE PASSED BY USER>
 * ----------
 *
 * Return value - <TRUE if duplicate rows else FALSE>
 * ------------
 */

function  checkDuplicacyTable_1() {
    var table =  document.getElementById(arguments[0]);
    var numRows = table.rows.length;
    if (numRows <= 0){
        return false;
    }
    var PKColumns = arguments[1];
    var numOfPKColumns = PKColumns.length;
    var tableList = new Array();
    var checkList = new Array();
    var tableCounter = -1;
    var checkCounter = -1;
    var concat = '';
    for (i=0;i< numRows ;i++ ){
        concat = '';
        if (document.getElementById('value[' + i + '].status').value == HIDE || document.getElementById('value[' + i + '].status').value == DEL){
            continue;
        }else{
            // Picking the value of row in first loop
            for(j=0; j < numOfPKColumns; j++){
                var str = 'value[' + i + '].' + PKColumns[j];
                var obj = document.getElementById(str);
                concat = concat + obj.value;
            }
            if(document.getElementById('value[' + i + '].status').value == ADD || document.getElementById('value[' + i + '].status').value == UPD){
                checkCounter = checkCounter +1;
                checkList[checkCounter] = concat;
            }else {
                tableCounter = tableCounter + 1 ;
                tableList[tableCounter] = concat ;
            }
        }
    }
    for (i=0; i<= checkCounter; i++){
        for(k=i+1; k<= checkCounter ; k++){
            if(checkList[i] == checkList[k]){
                return true;
            }
        }
        for(k=0; k<= tableCounter ; k++){
            if(checkList[i]== tableList[k]){
                return true;
            }
        }
    }
    return false;
}

   /**
    * populateCombo()
    * ================
    *
    * Method to populate Child Combo on the basis of selected Parent value
    *
    * Parameters
    * ----------
    * None
    *
    * Return value
    * ------------
    */
 //Changed by Jatin to show 'All' in english in case of populate combo
 //from TMT report screens,aintFlag==99 will add 'All' in combo
 function populateCombo(aobjParentCmb,
                        aobjChildCmb,aobjHiddenCmb,aarrstrParentCode, aintFlag)
 {
    // dealerBranch - a hidden combo
    comboHidden = eval(aobjHiddenCmb);
    comboChild = eval(aobjChildCmb);
    for(lintI=0; lintI < comboChild.length; lintI++)
    {
        aobjChildCmb.options[lintI] = null;
        lintI = -1;
    }
    //Enter default record
    if(aintFlag == 1) {
        comboChild.options[comboChild.options.length]= new Option("Select One...", "");
    } else if(aintFlag == 99) {
    	comboChild.options[comboChild.options.length]= new Option("", "");
    } else {
        comboChild.options[comboChild.options.length]= new Option(document.AppJsp.allLabel.value, "");
    }

    for(lintCtr=0; lintCtr < aarrstrParentCode.length; lintCtr++)
    {
        for(lintI=0; lintI < comboHidden.length; lintI++)
        {
            var opt= aobjHiddenCmb[lintI].text;
            var value= aobjHiddenCmb[lintI].value;
            var lintPos = value.indexOf("~");
            if (lintPos > -1) {
                var childCode = value.substring(0, lintPos);
                var parentCode = value.substring(lintPos+1);
                if(parentCode == aarrstrParentCode[lintCtr] || parentCode == '')
                {
                    with(aobjChildCmb)
                    {
                        options[options.length] = new Option(opt, childCode);
                    }
                }
            }
           /* else
            {
                if(lintCtr == 0) {
                    aobjChildCmb.options[aobjChildCmb.options.length] = new Option();
                }
            }*/
        }
    }
 }


/**
    * setToFiveMul()
    * ================
    *
    * Method to set the time value as a multiple of roundno
    *
    * Parameters
    * ----------
    * Parameter1   Time field <MANDATORY>
    * Parameter 2  Value by which the time is to be incremented.<MANDATORY>
    *
    * Return value
    * ------------
    */
 function setToFiveMul(aobjField,roundno) {
    if(!isValidTime(aobjField.value)){
      return;
    }
   putMask_Time(aobjField);
   var lstrTimeVal = aobjField.value;
   var lstrHrVal;
   var lstrMinVal;
   //Replace : from time
   re = new RegExp(":","g");
   lstrTimeVal = lstrTimeVal.replace(re,"");

   lstrHrVal = lstrTimeVal.substring(0,2);
   lstrMinVal = lstrTimeVal.substring(2,4);

    lstrMinVal = multipleNo(roundno,lstrMinVal);

    if(lstrMinVal ==  60)
        {
        lstrHrVal = eval(lstrHrVal)+1;

        lstrMinVal = '00';

        aobjField.value = lstrHrVal + lstrMinVal;
        if(aobjField.value.length == 3)
            {
            aobjField.value = '0'+aobjField.value;
            }

        if(lstrHrVal == 24)
            {
                lstrHrVal = '00';

                aobjField.value = lstrHrVal + lstrMinVal;

                putMask_Time(aobjField);
            }
            putMask_Time(aobjField);
        }
         if(lstrMinVal == '5')
                 {
             lstrMinVal = '05';

                 }

                 aobjField.value = lstrHrVal+lstrMinVal;

                 putMask_Time(aobjField);
}


//convert to a multiple of the parameter passed
    function multipleNo(multipleNo, FieldValue) {
        //fieldValue = objFieldValue.value;
            if(FieldValue % multipleNo == 0)
        {
            FieldValue = FieldValue;
            return(FieldValue);
        }
    else
        {

            lstrDiv = FieldValue / multipleNo;
            FieldValue = multipleNo * (Math.ceil(lstrDiv) );
            return(FieldValue);
        }
    }

/**
    * timeIncrement()
    * ================
    *
    * Method to Increment the time value
    *
    * Parameters
    * ----------
    * Parameter   Time field <MANDATORY>
    *
    * Return value
    * ------------
    */
function timeIncrement(aobjField) {

   var lstrTimeValue = aobjField.value;

   re = new RegExp(":","g");
   lstrTimeValue = lstrTimeValue.replace(re,"");

   lstrHrValue = lstrTimeValue.substring(0,2);
   lstrMinValue = lstrTimeValue.substring(2,4);

   if(lstrMinValue == '00') {
      lstrMinValue = '05';
   } else {
      lstrMinValue = eval(lstrMinValue) + 5;lstrMinValue = lstrMinValue.toString();
   }
      if(lstrMinValue.length == 1)
      {
         lstrMinValue = '0'+lstrMinValue;
      }
    if(lstrMinValue ==  60)
        {
        lstrHrValue = eval(lstrHrValue)+1;

        lstrMinValue = '00';

        aobjField.value = lstrHrValue + lstrMinValue;
        if(aobjField.value.length == 3)
            {
            aobjField.value = '0'+aobjField.value;
            }

        if(lstrHrValue == 24)
            {
                lstrHrValue = '00';

                aobjField.value = lstrHrValue + lstrMinValue;

                putMask_Time(aobjField);
            }
            putMask_Time(aobjField);
        } else {
               aobjField.value = lstrHrValue + lstrMinValue;
               if(aobjField.value.length == 3)
               {
                  aobjField.value = '0'+aobjField.value;
               }
               putMask_Time(aobjField);
        }
         }


/**
    * timeDecrement()
    * ================
    *
    * Method to Decrement the time value
    *
    * Parameters
    * ----------
    * Parameter   Time field <MANDATORY>
    *
    * Return value
    * ------------
    */
function timeDecrement(aobjField) {

   var lstrTimeValue = aobjField.value;

   re = new RegExp(":","g");
   lstrTimeValue = lstrTimeValue.replace(re,"");

   lstrHrValue = lstrTimeValue.substring(0,2);
   lstrMinValue = lstrTimeValue.substring(2,4);

   if(lstrMinValue == '00') {
      lstrMinValue = '55';
   } else {
      lstrMinValue = eval(lstrMinValue) - 5;lstrMinValue = lstrMinValue.toString();
   }
      if(lstrMinValue.length == 1)
     {
         lstrMinValue = '0'+lstrMinValue;
      }
    if(lstrMinValue ==  55)
        {
        lstrHrValue = eval(lstrHrValue)-1;

        lstrMinValue = '55';

        aobjField.value = lstrHrValue + lstrMinValue;
        if(aobjField.value.length == 3)
            {
            aobjField.value = '0'+aobjField.value;
            }

        if(lstrHrValue == -1)
            {
                lstrHrValue = '23';

                aobjField.value = lstrHrValue + lstrMinValue;

                putMask_Time(aobjField);
            }
            putMask_Time(aobjField);
        } else {
               aobjField.value = lstrHrValue + lstrMinValue;
               if(aobjField.value.length == 3)
               {
                  aobjField.value = '0'+aobjField.value;
               }
               putMask_Time(aobjField);
        }
         }

function setFocusOnComp()
{
    // Get the Passed Component Reference
    var lobjComp = document.getElementById(arguments[0]);
    // Set the focus on the component
    if( ! lobjComp.disabled ) {
        lobjComp.focus();
    }
}

//to put mask on Bill no.
function putMask_BillNo(aField)
 {
  var lstrValue = aField.value;
  var finalString = '';

    if(lstrValue.length==8){  // Curtailing Blank spaces from the begining and end of the entered text
      lstrValue = trimString(lstrValue);
      lstrValue = lstrValue.toUpperCase();

     finalString = lstrValue.substring(0,3) + "-" + lstrValue.substring(3,8) ;

      aField.value = finalString;
   }
 }//end of function putMask_BillNo

//to hide mask for Bill No.
function hideMask_BillNumber(aField)
 {
    lstrValue = aField.value;
    re = new RegExp("-","g");
    aField.value = lstrValue.replace(re,"");
    aField.select();
 }//end of function hideMask_BillNo



 /**
  * initRequest()
  * Initialize  request for XMLHTTP request for getPartDetails function
  *
  * Parameters
  * ----------
  * Returns
  * -----------
  * Returns the component of XMLHTTP request
  */
function initRequest(url) {
    if (window.XMLHttpRequest) {
        return new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        isIE = true;
        return new ActiveXObject("Microsoft.XMLHTTP");
    }
}


 /**
    * getPartDetails()
    * ================
    *
    * Method to Get Franchise, Format Mask,
    * Part Name and Part Price for Passed Part No.
    *
    * Parameters
    * ----------
    * Parameter 1  Old Part No.
    * Parameter 2  New Part No.
    * Parameter 3  Part Cost
    *
    * Return value
    * ------------
    * Returns and Array which has following information
    * Index 0     Franchise Code
    * Index 1     Format Mask
    * Index 2     Part Name
    * Index 3     Part Price
    * Index 4     Part No with formatmask
    */
function getPartDetails(){
    var lstrPartNo = arguments[1].toUpperCase();
    var lstrPartCostFlg = '';
    if(arguments[2] != null) {
        lstrPartCostFlg = arguments[2].toUpperCase();
    }

    var url = document.AppJsp.ajaxServlet.value + '/getpartdetail' + '?partno=' +
        escape(lstrPartNo)+'&partCost=' + lstrPartCostFlg;
    var req = initRequest(url);

    var lstrarrPartDtl =  new Array(7);

    // Passed Franchise Code
    lstrarrPartDtl[0] = '';
    // Part Franchise Mask
    lstrarrPartDtl[1] = '';
    // Part Name
    lstrarrPartDtl[2] = '';
    // Part Price
    lstrarrPartDtl[3] = '';
    //Part No with Franchise Code
    lstrarrPartDtl[4] = lstrPartNo;
    lstrarrPartDtl[5] = '';
    lstrarrPartDtl[6] = '';
    req.onreadystatechange =
            function() {
                if (req.readyState == 4) {
                    if (req.status == 200) {
                        lstrarrPartDtl = fetchPartDetails(req.responseXML, lstrPartNo);
                    } else if (req.status == 204){
                        //showError('Error: Some Error in file reading');
                    }
                }
            };
    req.open("GET", url, true);
    req.send(null);

    //pause for 50 miliseconds
    pause(200);
    return lstrarrPartDtl;
}

/*
* This function will not return until (at least)
* the specified number of milliseconds have passed.
* It uses a modal dialog.
*/
function pause(numberMillis) {
    var dialogScript =
    'window.setTimeout(' +
    ' function () { window.close(); }, ' + numberMillis + ');';
    var result =
    // For IE5.
    window.showModalDialog(
    'javascript:document.writeln(' +
    '"<script>' + dialogScript + '<' + '/script>")');

    /* For NN6, but it requires a trusted script.
    openDialog(
    'javascript:document.writeln(' +
    '"<script>' + dialogScript + '<' + '/script>"',
    'pauseDialog', 'modal=1,width=10,height=10');
    */
}

/**
    * fetchPartDetails()
    * ================
    *
    * Method to read the return string from AJEX and get the Part details
    *
    * Parameters
    * ----------
    * Parameter 1  responseXML  XMLHTTP request object
    *
    * Return value
    * ------------
    * Returns and Array which has following information
    * Index 0     Franchise Code
    * Index 1     Format Mask
    * Index 2     Part Name
    * Index 3     Part Price
    * Index 4     Part No with formatmask
    */
function fetchPartDetails(responseXML, astrPartNo){
    var lobjParts;
    var lobjPart;
    var lstrPartNo;
    var lstrPartName;
    var lstrFranchise;
    var lstrFormatMask;
    var lstrPrice;
    var lstrCost;
    var lstrMinCost;
    var lstrarrPartDtl = new Array(7);

    //Get the Parts node
    lobjParts = responseXML.getElementsByTagName("parts")[0];
    //If there is no part in parts node
    if (lobjParts.childNodes.length <= 0) {
        // Passed Franchise Code
        lstrarrPartDtl[0] = '';
        // Part Franchise Mask
        lstrarrPartDtl[1] = '';
        // Part Name
        lstrarrPartDtl[2] = '';
        // Part Price
        lstrarrPartDtl[3] = '';
        //Part No with Franchise Code
        lstrarrPartDtl[4] = astrPartNo;
        // Part Cost
        lstrarrPartDtl[5] = '';
        // Min. Unit Cost
        lstrarrPartDtl[6] = '';
    }else{
        lobjPart = lobjParts.childNodes[0];
        if(lobjPart != null){
            lstrPartNo      = lobjPart.getElementsByTagName("partNo")[0].childNodes[0].nodeValue;
            lstrPartName    = lobjPart.getElementsByTagName("partName")[0].childNodes[0].nodeValue;
            lstrFranchise   = lobjPart.getElementsByTagName("franchise")[0].childNodes[0].nodeValue;
            lstrFormatMask  = lobjPart.getElementsByTagName("formatMask")[0].childNodes[0].nodeValue;
            lstrPrice       = lobjPart.getElementsByTagName("unitPrice")[0].childNodes[0].nodeValue;
            lstrCost        = lobjPart.getElementsByTagName("unitCost")[0].childNodes[0].nodeValue;
            lstrMinCost        = lobjPart.getElementsByTagName("minUnitCost")[0].childNodes[0].nodeValue;


            // Passed Franchise Code
            lstrarrPartDtl[0] = lstrFranchise;
            // Part Franchise Mask
            lstrarrPartDtl[1] = lstrFormatMask;
            // Part Name
            lstrarrPartDtl[2] = lstrPartName;
            // Part Price
            lstrarrPartDtl[3] = lstrPrice;
            //Part No with Franchise Code
            lstrarrPartDtl[4] = lstrFranchise + '-' + lstrPartNo;
            //Part Cost
            lstrarrPartDtl[5] = lstrCost;
            //Part Min. Cost
            lstrarrPartDtl[6] = lstrMinCost;
        }
    }
    return lstrarrPartDtl;
}

/**
  * selectAll()
  * =============
  *
  * To select/deselect all the rows in a table
  *
  * astrTable : The table object which is to be operated on (MANDATORY)
  * aobjSelectAll: Name of the select All checkbox on the table(MANDATORY)
  * return value
  */
    function selectAll(astrTable, aobjSelectAll) {
        var lstrSelected;
        var lobjSelected;
        var lobjStatus;
        var lintCount;
        var lobjTable   = document.getElementById(astrTable);
        var lintNumRows = lobjTable.rows.length;
        for (lintCount=0;lintCount < lintNumRows;lintCount++) {
            lobjStatus= document.getElementById("value[" + lintCount + "].status");
            if(lobjStatus.value != "HIDE"){
                lstrSelected = "value[" + lintCount + "].selected";
                lobjSelected = document.getElementById(lstrSelected);
                if( ! lobjSelected.disabled ) {
                    lobjSelected.checked = aobjSelectAll.checked;
                }
            }
        }
    }

/**
  * changeSelectAll()
  * ===================
  *
  * To deselect the select all checkbox on the table
  *
  * aobjClicked  : The clicked checkbox
  * astrSelectAll: Name of the select All checkbox on the table
  * return
  */
    function changeSelectAll(aobjClicked,astrSelectAll){
        var objSelectAll=document.getElementById(astrSelectAll);
        if(!aobjClicked.checked){
            objSelectAll.checked = false;
        }
    }


//function to validate email Id
//returns true if valid email - ID else false value is returned
function isValidEmailId(aobjEmailId, astrVisibleTab, astrMulFlag){

    var re = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/g;
    var lstrEmails = new Array();

    if(astrMulFlag != null && astrMulFlag == 'Y'){
       lstrEmails = aobjEmailId.value.split(",");
    }else{
       lstrEmails[0] = aobjEmailId.value ;
    }

    for(lintCounter = 0; lintCounter < lstrEmails.length; lintCounter ++){
        //if email id is valid email id
        if( lstrEmails[lintCounter].search(re) == -1 ){
            //showError("FE0079", FE0079, aobjEmailId, null, astrVisibleTab);
            return false;
        }
    }
    return true;
}

//Added by Dharmveer for EPC File upload on 10/09/2008
function uploadEPCFile(astrFilePath, aobjFileData) {
    var lstrData;
    lstrData = "";
	try {
        objFSO = new ActiveXObject("Scripting.FileSystemObject");
        if (objFSO.FileExists(astrFilePath)) {
            lstrData = objFSO.OpenTextFile(astrFilePath, 1,false,-2).ReadAll();                      
        } else {
    	    //showError("FE0901",FE0901);
    	    return false;
        }
        aobjFileData.value = lstrData;
    }
    catch(e){
        //Consume JS error or show to alert as per requirement
        //showError("FE0904",FE0904);
        return false;
    }
    return true;
}

//function for delete EPC uploaded file
function deleteFile(objFilePath)
{
    var myObject;
    try {
       myObject = new ActiveXObject("Scripting.FileSystemObject");
       if(myObject.FileExists(objFilePath))
       { 
           var f = myObject.GetFile(objFilePath);
           f.Delete();
       }
    }
    catch(e){
        //Consume JS error or show to alert as per requirement
        //showError("FE0904",FE0904);
        return false;
    }
}

/* Start for EZL */
function openLookup(prmFormName, prmRowId, prmMasterId, prmValues){
        setErrorFlag();
        var screenWidth = 800;	    
        var screenHeight= 500;
        var x = aw>800?(aw-screenWidth)/2:0;
        var y = ah>600?(ah-screenHeight)/2:0;
        var winName = prmFormName;	
        var urlString = '?prmFormName='+prmFormName+'&prmRowId='+prmRowId+'&prmMasterId='+prmMasterId+'&prmValues='+prmValues;	
        var objWindow = window.open(secm002Url+urlString,winName,'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=no,scrollbars=no,toolbar=no,titlebar=yes',false);
        /* start added for closing all child windows */
		V = new Object();
		V.name = winName;
		V.window = objWindow;
		arrChilds[arrChilds.length] = V;   
		/* end added for closing all child windows */		
		objWindow.focus();        
    }
    
    function openAttachment(prmFormName, prmObject, prmReferenceId, prmReferenceNo)
    {	
            
            var screenWidth = 1000;	    
            var screenHeight= 500;
            var x = aw>800?(aw-screenWidth)/2:0;
            var y = ah>600?(ah-screenHeight)/2:0;
            var winName = prmFormName;		
            var queryStr = '?&prmAppName='+APP_NAME
                            +'prmFormName='+prmFormName
                            +'&prmObject='+prmObject
                            +'&prmReferenceId='+prmReferenceId
                            +'&prmReferenceNo='+prmReferenceNo;
            var screen_url = svcm002Url + queryStr;
            childWindow = window.open(screen_url,winName, 'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=no,scrollbars=no,toolbar=no,titlebar=yes');					
			/* start added for closing all child windows */
			V = new Object();
			V.name = winName;
			V.window = childWindow;
			arrChilds[arrChilds.length] = V;   
			/* end added for closing all child windows */	
            childWindow.focus();
    }
    
    function openChildScreen64(screen_url,screen_id)
    {	
            setErrorFlag();
            var screenWidth = 600;	    
            var screenHeight= 400;
            var x = aw>800?(aw-screenWidth)/2:0;
            var y = ah>600?(ah-screenHeight)/2:0;
            var winName = screen_id;		
            childWindow = window.open(screen_url,winName, 'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=no,scrollbars=no,toolbar=no,titlebar=yes');					
			/* start added for closing all child windows */
			V = new Object();
			V.name = winName;
			V.window = childWindow;
			arrChilds[arrChilds.length] = V;   
			/* end added for closing all child windows */	
            childWindow.focus();
    }

    function openChildScreen65(screen_url,screen_id)
    {	
            setErrorFlag();
            var screenWidth = 600;	    
            var screenHeight= 500;
            var x = aw>800?(aw-screenWidth)/2:0;
            var y = ah>600?(ah-screenHeight)/2:0;
            var winName = screen_id;		
            childWindow = window.open(screen_url,winName, 'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=no,scrollbars=no,toolbar=no,titlebar=yes');					
			/* start added for closing all child windows */
			V = new Object();
			V.name = winName;
			V.window = childWindow;
			arrChilds[arrChilds.length] = V;   
			/* end added for closing all child windows */	
            childWindow.focus();
    }
	
    function openChildScreen75(screen_url,screen_id)
    {	
            setErrorFlag();
            var screenWidth = 750;	    
            var screenHeight= 500;
            var x = aw>800?(aw-screenWidth)/2:0;
            var y = ah>600?(ah-screenHeight)/2:0;
            var winName = screen_id;		
            childWindow = window.open(screen_url,winName, 'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=no,scrollbars=no,toolbar=no,titlebar=yes');					
			/* start added for closing all child windows */
			V = new Object();
			V.name = winName;
			V.window = childWindow;
			arrChilds[arrChilds.length] = V;   
			/* end added for closing all child windows */	
            childWindow.focus();
    }
    
    function openChildScreen85(screen_url,screen_id)
    {	
            setErrorFlag();
            var screenWidth = 850;	    
            var screenHeight= 500;
            var x = aw>800?(aw-screenWidth)/2:0;
            var y = ah>600?(ah-screenHeight)/2:0;
            var winName = screen_id;		
            childWindow = window.open(screen_url,winName, 'width='+screenWidth+',height=' + screenHeight + ',left=' + x + ',top=' + y + 'resizable=no,scrollbars=no,toolbar=no,titlebar=yes');					
			/* start added for closing all child windows */
			V = new Object();
			V.name = winName;
			V.window = childWindow;
			arrChilds[arrChilds.length] = V;   
			/* end added for closing all child windows */	
            childWindow.focus();
    }

    var IDX_PRINT_ID_TYPE	= 0;
    var IDX_PRINT_ID_CD		= 1;	
	
    var IDX_FSC_CD			= 0; 
    var IDX_FSC_NM			= 1; 
	
    var IDX_SHIP_TERM_CD	= 0; 
    var IDX_SHIP_TERM_NM	= 1; 
	
    var IDX_COM_GROUP_CD	= 0; 
    var IDX_COM_GROUP_NM	= 1; 
	
    var IDX_COMODITY_CD		= 0; 
    var IDX_COMODITY_NM		= 1; 
	
    var IDX_SERVICE_CD		= 0; 
    var IDX_SERVICE_DESC	= 1; 
    var IDX_SERVICE_CAT		= 2; 
    var IDX_SERVICE_TYPE	= 3; 
    var IDX_SERVICE_CHRG_CD	= 4; 
    var IDX_SERVICE_SURCHRG_CD	= 5; 
    var IDX_SERVICE_ROUTE_TYPE	= 6; 
    var IDX_SERVICE_REC_STATUS  = 7; 
    function getServiceDtls(astrFormName, astrRowId, astrServiceCd){
        callAjax(astrFormName, astrRowId, MASTER_ID_SERVICE, astrServiceCd);		
    }

    var IDX_UOM_CD		= 0; 
    var IDX_UOM_DESC		= 1;
    var IDX_UOM_TYPE		= 2;
    var IDX_UOM_REC_STATUS	= 3;
    function getUomDtls(astrFormName, astrRowId, astrUomCd){
        callAjax(astrFormName, astrRowId, MASTER_ID_UOM, astrUomCd);
    }
    
    var IDX_VND_CD		= 0; 
    var IDX_VND_NM		= 1; 
    var IDX_VND_TYPE	        = 2;
    var IDX_VND_ADD1	        = 3;
    var IDX_VND_ADD2	        = 4;
    var IDX_VND_ADD3	        = 5;
    var IDX_VND_ADD4	        = 6;
    var IDX_VND_CITY	        = 7;
    var IDX_VND_STATE	        = 8;
    var IDX_VND_CNTRY	        = 9;
    var IDX_VND_ZIP	        = 10;
    var IDX_VND_TEL	        = 11;
    var IDX_VND_FAX	        = 12;
    var IDX_VND_EMAIL	        = 13;
    var IDX_VND_CONTACT	        = 14;
    var IDX_VND_TITLE	        = 15;
    var IDX_VND_REC_STATUS	= 16;
    function getVendorDtls(astrFormName, astrRowId, astrVendorCd){
        callAjax(astrFormName, astrRowId, MASTER_ID_VENDOR, astrVendorCd);		
    }
    
    var IDX_CUST_CD		= 0; 
    var IDX_CUST_NM		= 1; 
    var IDX_CUST_TYPE	        = 2;
    var IDX_CUST_ADD1	        = 3;
    var IDX_CUST_ADD2	        = 4;
    var IDX_CUST_ADD3	        = 5;
    var IDX_CUST_ADD4	        = 6;
    var IDX_CUST_CITY	        = 7;
    var IDX_CUST_STATE	        = 8;
    var IDX_CUST_CNTRY	        = 9;
    var IDX_CUST_ZIP	        = 10;
    var IDX_CUST_TEL	        = 11;
    var IDX_CUST_FAX	        = 12;
    var IDX_CUST_EMAIL	        = 13;
    var IDX_CUST_COL_FSC        = 14;
    var IDX_CUST_COL_FSC_CURR   = 15;
    var IDX_CUST_REC_STATUS	= 16;
    function getCustDtls(astrFormName, astrRowId, astrCustCd){
        callAjax(astrFormName, astrRowId, MASTER_ID_CUSTOMER, astrCustCd);
    }
    
    var IDX_PRODUCT_CD		= 0; 
    var IDX_PRODUCT_DESC	= 1; 
    var IDX_PRODUCT_PACK_TYPE   = 2; 
    var IDX_PRODUCT_GOODS_TYPE  = 3; 
    var IDX_PRODUCT_CAT_DTL     = 4; 
    var IDX_PRODUCT_NET_WEIGHT	= 5; 
    var IDX_PRODUCT_GROSS_WEIGHT= 6; 
    var IDX_PRODUCT_DIMENSION_M3= 7; 
    var IDX_PRODUCT_CAT	        = 8; 
    function getProductDtls(astrFormName, astrRowId, astrParam){
        callAjax(astrFormName, astrRowId, MASTER_ID_PRODUCT, astrParam);
    }
    
    function callAjax(formName, rowId, actionType, actionParam){
	//alert('formName='+formName+',rowId='+rowId+',actionType='+actionType+',actionParam='+actionParam);
        ajaxUrl = svut001Url + '?pageAction=callAjax&actionType='+actionType+'&actionParam='+actionParam;
        $.post(ajaxUrl, function(retValue) {
                setAjaxRetValue(formName, rowId, actionType, retValue);
        });
    }
    function setAjaxRetValue(aFormName, aRowId, aActionType, aRetValue){
            //alert('aRetValue='+aRetValue);
            if(aRetValue == FAILURE) {
                //Invalid Master Code
                showBarMessage('Invalid Master Code',ERROR_MSG);
            } else {
		showBarMessage('Ready');
	    }
            setLookupValues(aFormName, aRowId, aActionType, aRetValue.split(TILDE));
    }
    
    function openHelp() {
        setErrorFlag();
        alert('Help...');
        var strFileName = '1';
        var strUrl = "/RCLWebApp/help/ApplicationHelp.htm#"+strFileName;
        var objWindow = window.open(strUrl,"Help","width=900,height=600,status=no,resizable=no,top=150,left=150");
        objWindow.focus();
    }
    
    
    function openReport(){
        //Module : Ex. VCT
        document.reportForm.module.value = openReport.arguments[0];
        //Calling Screen ID : Ex. VCT001
        document.reportForm.screen.value = openReport.arguments[1];
        //Report Name : Ex. VCT004.rdf
        document.reportForm.report.value = openReport.arguments[2];
        //Open Mode : Ex. pdf
        document.reportForm.desformat.value = openReport.arguments[3];
        //NO_OF_PARAMS#PARAM-1#PARAM-2#PARAM-3#PARAM-N(userid)
        document.reportForm.reportDetails.value = openReport.arguments[4];
        //set the report servlet action url
        document.reportForm.action = reportUrl;
        document.reportForm.submit();
    }
	
	
	var aItem   = null;
	/*
		p_item	: Return Item.
		p_month : 0-11 for Jan-Dec; 12 for All Months.
		p_year	: 4-digit year
		p_format: Date format (mm/dd/yyyy, dd/mm/yy, ...)	
	*/
	function showCalendar(p_item, p_month, p_year, p_format)
	{
		aItem = p_item;
		window.showModalDialog(appCtxPath+"/pages/common/misc/calendar.jsp",self,'dialogHeight:238px;dialogWidth:211px;status=no');
	}
	function showCalendarWithTime(p_item, p_month, p_year, p_format)
	{
		aItem = p_item;
		window.showModalDialog(appCtxPath+"/pages/common/misc/calendar.jsp?reqFormat="+p_format,self,'dialogHeight:238px;dialogWidth:211px;status=no');
	}	
	//call after closing calender
	function setDate(strDate) {
		var formName = 'forms[0]';
		var fieldName = '';
		if(aItem.indexOf(formName) >= 0){
			fieldName = aItem.substring(formName.length+1);
		} else {
			fieldName = aItem;
		}
		afield = document.getElementById(fieldName);		
		afield.value = strDate;		
		afield.focus();
		/*if(aItem!=null){
		    //get object name		  
		    var lstrControlName = (aItem).substring(0,aItem.indexOf(".")+1);
		    lstrControlName = lstrControlName + 'status';
			if(document.getElementById(lstrControlName)!= null && document.getElementById(lstrControlName)!=''){
				//set status value to 'UPD'
				if(document.getElementById(lstrControlName).value != 'ADD'){				
					document.getElementById(lstrControlName).value = 'UPD';
				}	
			}
		}*/	
	}

	function stopOnChange(objControl, selCode, editFlag){
		//If Non-Editable, dont allow to change value
		if(!editFlag){
			objControl.value = selCode;
		}
		return false;
	}
	
	//objName = object name
	//objValue = value in the field being checked
	// e = event
	// decimalFlag(true=double false=integer)
	function numFormat(objName, objValue, e, decimalFlag) {
		var whichCode = (window.Event) ? e.which : e.keyCode;
		//Create numeric string values for '.' and '0123456789'
        //The codes provided include both keyboard and keypad values
        var strCheckDouble   = '46,48,49,50,51,52,53,54,55,56,57';		
		var strCheckInteger  = '48,49,50,51,52,53,54,55,56,57';		
		if (whichCode == 8) {//Ignore the Netscape value for backspace. IE has no value
		    return false;
		} else{
			if(decimalFlag){
				if (strCheckDouble.indexOf(whichCode) == -1) {
					e.keyCode = '8';//cancel event
					return false;
				}
				//if decimal point kyed
				if (whichCode == '46') {
					//stop keying 2 decimal points
					if(objValue.indexOf('.') != -1){
						e.keyCode = '8';//cancel event
						return false;
					}
				}
			} else {
				if (strCheckInteger.indexOf(whichCode) == -1) {
					e.keyCode = '8';//cancel event
					return false;
				}
			}
		}
		
	}

    function disableOnSubmit() {
    isErrFlag = false;

    if(!isErrFlag &&
          window.event.srcElement.type== 'button' &&
          window.event.srcElement.attributes.getNamedItem("disabled").value =='false'
      ){
          buttonName = window.event.srcElement.name;
        
          // Process only, if button is not lookup button.
          if(buttonName.indexOf("Lookup") == -1) {
                // Get all element on page of type input tag
                var docAllInputTagElements = document.getElementsByTagName("input");
                // Process only if page contains input type tags
                if(docAllInputTagElements.length > 0 ) {
                    // Process for each element
                    for (i = 0; i < docAllInputTagElements.length ; i++ ) {
                        // if elelent is of Type Button
                        if(docAllInputTagElements[i].type == 'button'){
                            // disable Button
                            document.getElementById(docAllInputTagElements[i].name).disabled = true;
                            // Set Opacity
                            // docAllInputTagElements[i].setAttribute("className" ,"Body_Image_Disable");

                        } // end - if(docAllInputTagElements[i].type == 'image')

                    } // end for loop

                } // end - if(docAllInputTagElements.length > 0 )

          }// end - if( attrSrcValue!="btn_clear.gif" && attrSrcValue!="icon_calendar.gif")
    }
        isErrFlag = false ;
   }

    function setErrorFlag() {
        isErrFlag = true;
    }
/* End for EZL */