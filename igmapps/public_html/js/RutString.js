/*-----------------------------------------------------------------------------------------------------------  
RutString.js
------------------------------------------------------------------------------------------------------------- 
Copyright RCL Public Co., Ltd. 2007 
-------------------------------------------------------------------------------------------------------------
Author Piyapong Ieumwananonthachai 03/04/08
- Change Log ------------------------------------------------------------------------------------------------  
## DD/MM/YY -User-     -TaskRef-      -Short Description  
-----------------------------------------------------------------------------------------------------------*/

function trim(strText){
    // trim leading spaces
    while (strText.substring(0,1) == ' '){
	strText = strText.substring(1, strText.length);
    }

    // trim trailing spaces
    while (strText.substring(strText.length-1,strText.length) == ' '){
	strText = strText.substring(0, strText.length-1);
    }

    return strText;
}
