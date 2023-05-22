/****************************************************/
/*                                                  */
/*           COMMON FUNCTIONS For RIA GRID          */
/*                                                  */
/****************************************************/

var mobjGrid;
var mintTotalRows = 0;
var mobjFixedTable;

function getGridControl()
{
	return mobjGrid;
}

function addRow()
{
	addRowToRiaGrid(getGridControl(), mintTotalRows);
	addRowInFixedTable();
	return false;
}

function addRowToRiaGrid(aobjRiaGrid, aintAddRowIndex) 
{
	// Fire Ajax call to add record in Ria Grid.
	aobjRiaGrid.addRowData("row" + aintAddRowIndex, getRecordToAddInGrid(aintAddRowIndex));
	
	// Increment the record count.
	mintTotalRows = mintTotalRows + 1;
	
    return false;
}

function updateCellBodyContent(aintRowIndex, aintColumnId, astrBodyContent,astrStatusUpdateRequired)
{
	// Fire Ajax call to update cell value in Grid.					
	updateRiaGridColumn(getGridControl(), aintRowIndex, aintColumnId, astrBodyContent);	 		

	// Update record Status
	if(astrStatusUpdateRequired){
		updateRecordStatus(aintRowIndex);
	}
	return false;
}

function updateRiaGridColumn(aobjRiaGrid, aintRowIndex, astrColumnId, astrColumnValue)
{
	var lstrRowId = "row" + aintRowIndex;

	// Fire Ajax call to update cell value in Grid.					
	aobjRiaGrid.updateCellData(lstrRowId, astrColumnId, astrColumnValue);	 		
}

// Function will be called to change the status to UPD
function updateRecordStatus(rowIndex)
{
	var lobjRecordStatus = getStatusObject(rowIndex);

	if(lobjRecordStatus != null) {
		var lstrRecordCurrentStatus = lobjRecordStatus.value;

		// Status ADD and Delete cann't be updated.
		if(lstrRecordCurrentStatus == ''){
			lobjRecordStatus.value = 'UPD'; 
		}
	}

	return false;
}

function deleteRow()
{

//      showBarMessage('Ready');
        var table   = document.getElementById(getFixedColumnsTableName());
        var numrows = table.rows.length;

        if(numrows == 0) {
//            showBarMessage(VBK_SE0085,ERROR_MSG);
			  alert("No record in table to delete.");	
            return false;
        } 

        if (!isSelected()) {
//            showBarMessage(ECM_GE0007,ERROR_MSG);
			  alert("No record selected to delete.");	
            return  false;
        }

        if(!removeRow()){
            return false; 
        }

        //set the action
        document.forms[0].action = DEL;
        document.forms[0].submit();
        return false;
}

function isSelected() 
{
    var chk = 0;
    for(i=0;i<mintTotalRows;i++){
        var obj = getSelectedObject(i);
        
		if(obj != null && obj.checked) {
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


function removeRow(){
        var table   = document.getElementById(getFixedColumnsTableName());
        var numRows = table.rows.length;
        
        if(numRows<= 0) {
            return false;
        }

        var delNoRows = 0;
	    for(var rowNo=numRows-1; rowNo>= 0; rowNo--) {
	    	var rowId     = table.rows(rowNo).id;
	    	var rowIndex  = rowId.substring(3);

            var status    = getStatusObject(rowIndex).value;
            var selectRow = getSelectedObject(rowIndex).checked;
            var objSelectTempRecordStatus =  getTempRecordStatusObject(rowIndex);
            var lstrSelectTempRecordStatus = "";
            if(objSelectTempRecordStatus!=null){
                var lstrSelectTempRecordStatus =  objSelectTempRecordStatus.value;
            }

            if(status=='ADD'&& selectRow==true && lstrSelectTempRecordStatus!='ADD'){
                table.deleteRow(rowNo);
                deleteRowFromRiaGrid(getGridControl(), rowId) ;
                delNoRows++;
            }
        }

        if(delNoRows == numRows)
            return false;

        return true;
}

function deleteRowFromRiaGrid(aobjRiaGrid, rowId) 
{
	// Fire Ajax call to delete row from grid.
	aobjRiaGrid.deleteRowData(rowId);
	return false;
}

function getSelectedRowData(aintRowIndex)
{	
    var rowData = getExistingRecordInGrid(getGridControl(), "row"+aintRowIndex);
	
//  Uncomment - if need to print the data for dubugging purpose.
/*
    for(j=0;j<getGridControl().columnNumber;j++){
                alert(getGridControl().getColumnAtPosition(j).id + " = " + rowData[getGridControl().getColumnAtPosition(j).id]);
    }
*/	
    return rowData;
}

function getRecordFromFixedTable(aintRowIndex)
{
	var table = document.getElementById(getFixedColumnsTableName());	
	return false;
}



function getExistingRecordInGrid(aobjGrid, astrRowId)
{
	var lintRowIndex  = - 1;
    var rowData = {};
	var larrDefaultPositionControlId = getDefaultPositionControlId();
    
    for(i=0; i<mintTotalRows; i++){
		if(aobjGrid.data[i][0] == astrRowId){
			lintRowIndex = i;
			break;   
		}
	}
	
	for(j=0;j<aobjGrid.columnNumber;j++){
		rowData[larrDefaultPositionControlId[j]] = aobjGrid.data[lintRowIndex][j+1];
	}
	return rowData;
}

function synchronizeTables()
{
	oElement1 = document.getElementById(getFixedColumnsDivId());
    oElement2 = document.getElementById(getGridId() + '_headDiv');

	if(oElement1 != null){
		oElement1.scrollTop=event.srcElement.scrollTop;
	}
	if(oElement2 != null){
		oElement2.scrollLeft=event.srcElement.scrollLeft;
	}        
	return false;	
}

function setRowSelection(aintRowIndex)
{

	getGridControl().selectionMode =1;  	// No Row Selection
	getGridControl().clearSelection();
	getGridControl().setRowSelection("row"+aintRowIndex,true);
	getGridControl().selectionMode =0;	// No Row Selection
	return false;
}

function setSearchCriteria()
{   	
    var larrSearchCriteria = new Array();
    var lstrSearchString  = '';
    larrSearchCriteria = getSearchCriteria();
	
    for(i=0;i<larrSearchCriteria.length;i++) {
        lstrSearchString += '~' + larrSearchCriteria[i] + '=' + document.getElementById(larrSearchCriteria[i]).value;
    }
    return lstrSearchString.substring(1);
}

function getGridSearchCriteria()
{

    var viewId = getSelectedViewId();
    var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.GetSearchCriteria", {"viewId":viewId},null);
    setGridSearchCriteria(responseMap);
    return false;
}

function setGridSearchCriteria(responseMap)
{
	var searchValue;
	var searchFields = getSearchCriteria();

	for(i=0;i<searchFields.length;i++) {
		searchValue = responseMap ["data"][searchFields[i]];

		if(searchValue=="undefined" || searchValue==null){
			if(document.getElementById(searchFields[i]).type == "select-one"){
				document.getElementById(searchFields[i]).selectedIndex = 0;
			}else{
				document.getElementById(searchFields[i]).value= "";				
			}	
		}else{
			document.getElementById(searchFields[i]).value= searchValue;		
		}
	}			
		
	return false;
}

function validateOperatorCode(opCode)
{
	if(opCode.value != "") {
	    var lstrOpcode = opCode.value; 
		var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.ValidateMasterData", {"validateField":"OPCODE","codeVal1":lstrOpcode},null);
		return responseMap ["data"];
    }else{
		return "N";
	}
	return false;	
}

// Add by THIWAT1 15/09/16
function validatePlaceOfDelivery1(placeOfDel)
{
	if(placeOfDel.value != "") {
	    var lstrPlaceOfDelivery = placeOfDel.value; 
		var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.ValidateMasterData", {"validateField":"PLACEOFDEL","codeVal1":lstrPlaceOfDelivery},null);
		return responseMap ["data"];
    }else{
		return "N";
	}
	return false;	
}

function validateShipmentTerm(shipTermCode)
{
	if(shipTermCode.value != "") {
	    var lstrShipTermCode = shipTermCode.value; 
		var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.ValidateMasterData", {"validateField":"SHIPTERMCODE","codeVal1":lstrShipTermCode},null);
		return responseMap ["data"];
    }else{
		return "N";
	}
	return false;	
}

function validateHandInsCode(hinsCode)
{
	if(hinsCode.value != "") {
	    var lstrHinsCode = hinsCode.value; 
		var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.ValidateMasterData", {"validateField":"HINSCODE","codeVal1":lstrHinsCode},null);
		return responseMap ["data"];
    }else{
		return "N";
	}
	return false;
}

function validateEquipmentType(opCode)
{
	if(opCode.value != "") {
	    var lstrOpcode = opCode.value; 
		var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.ValidateMasterData", {"validateField":"EQUIPMENTTYPE","codeVal1":lstrOpcode},null);
		return responseMap ["data"];
    }else{
		return "N";
	}
	return false;	
}

function validatePortCode(opCode)
{
	if(opCode.value != "") {
	    var lstrOpcode = opCode.value; 
		var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.ValidateMasterData", {"validateField":"PORT","codeVal1":lstrOpcode},null);
		return responseMap ["data"];
    }else{
		return "N";
	}
	return false;	
}

function validatePortTerminal(opCode)
{
	if(opCode.value != "") {
	    var lstrOpcode = opCode.value; 
		var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.ValidateMasterData", {"validateField":"PORTTERMINAL","codeVal1":lstrOpcode},null);
		return responseMap ["data"];
    }else{
		return "N";
	}
	return false;	
}


/*
function validateUnNoUnVar(unNoVal, unVarVal)
{
	if(unNoVal.value != "" && unVarVal!="") {        
	    var lstrUnNoVal  = unNoVal.value; 
            var lstrUnVarVal = unVarVal.value; 
            
		var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.ValidateMasterData", {"validateField":"UNNOVAR","codeVal1":lstrUnNoVal,"codeVal2":lstrUnVarVal},null);
		if(responseMap ["data"]=="undefined" || responseMap ["data"]==null){
			showBarMessage("Invalid UN No. and UN Variable value",ERROR_MSG);
		}else if(responseMap ["data"] =="N"){
			showBarMessage("Invalid UN No. and UN Variable value",ERROR_MSG);
		}else{
			showBarMessage("Ready");
		}
	}	
    return false;
}

function validatePortClassType(portCode, portClass, portClassType)
{
	if(portCode.value != "" && portClass!="" && portClassType!="") {
	    var lstrPortCode      = portCode.value; 
            var lstrPortClass     = portClass.value; 
            var lstrPortClassType = portClassType.value; 
            
		var responseMap = SweetDevRia.ComHelper.syncCallIAction ("com.niit.control.common.ria.grid.common.ValidateMasterData", {"validateField":"PORTVAL","codeVal1":lstrPortCode,"codeVal2":lstrPortClass,"codeVal3":lstrPortClassType},null);
		if(responseMap ["data"]=="undefined" || responseMap ["data"]==null){
			showBarMessage("Invalid Port Class and Port Class Type value",ERROR_MSG);
		}else if(responseMap ["data"] =="N"){
			showBarMessage("Invalid Port Class and Port Class Type value",ERROR_MSG);
		}else{
			showBarMessage("Ready");
		}
	}	
    return false;
}
*/


function deleteGridRows() {
    var objGrid = getGridControl();
    for(i=0; i<mintTotalRows; i++){
            if(objGrid.data[i][0] != null){
                    deleteRowFromRiaGrid(objGrid,"row"+i);
            }
    }
}