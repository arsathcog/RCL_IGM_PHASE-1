var isCalShown = 0;
var gdCtrl = new Object();
var dateFormat1 = "yyyy";
//var gdCtrl = new Object();
var goSelectTag = new Array();
var gcGray = "gray";
var gcToggle = "#CAD2D2";
var gcBG = "#E2E8EF";
var gcBG2 = "#C7D1E2";
var gcToday = "#ffff00";

var gdCurDate = new Date();
//alert("gdCurDate---->"+gdCurDate);

var giYear = gdCurDate.getFullYear();
var giMonth = gdCurDate.getMonth()+1;
var giDay = gdCurDate.getDate();
var giHours = gdCurDate.getHours();
var giMinutes = gdCurDate.getMinutes();

var WeekDay = new Array("SUN","MON","TUE","WED","THU","FRI","SAT");
var gMonths = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
var gToday = "Today";
var isFromApplet = 0;
var dumPoint;

var yearArray  = new Array();
var dispYear = "";

if (typeof(_day) == "number")
{
  	giDay = _day;
}

if (typeof(_month) == "number")
{
  	giMonth = _month;
}
  
if (typeof(_year) == "number")
{
  	giYear = _year;
}

//alert("giYear-->"+giYear+"\n"+"giDay -->"+giDay+"\n"+"giMonth -->"+giMonth);
if (typeof(isCalledFromApplet) == "number" && isCalledFromApplet == 1)
{
	isFromApplet = 1;
}

if((typeof(_daysOfWeek) == "object") && _daysOfWeek.length == 7) {
	  for (i=0; i<7; i++)
	  	WeekDay[i] = _daysOfWeek[i];
}

if((typeof(_monthsOfYear) == "object") && _monthsOfYear.length == 12) {
	  for (i=0; i<12; i++)
	  	gMonths[i] = _monthsOfYear[i];
}

if(typeof(_today) == "string") {
	gToday = _today;
  }

function fSetDate(iYear, iMonth, iDay, iHour, iMinute)
{
  VicPopCal.style.visibility = "hidden";
  isCalShown = 0;
    if (iMonth == 1 || iMonth == 2 || iMonth == 3 || iMonth == 4 || iMonth == 5 || iMonth == 6 || iMonth == 7 || iMonth == 8 || iMonth == 9)
    {
      iMonth= '0'+iMonth;
    }
    if (iDay == 1 || iDay == 2 || iDay == 3 || iDay == 4 || iDay == 5 || iDay == 6 || iDay == 7 || iDay == 8 || iDay == 9)
    {
      iDay = '0'+iDay
    }
	if(iHour<10)
	{
		iHour = '0'+iHour;
	}
	if(iMinute<10)
	{
		iMinute = '0'+iMinute;
	}
	

    // code for date formats
	// 1 DD/MM/YYYY 
	// 2 MM/DD/YYYY
	// 3 YYYY/MM/DD
	// 4 YYYY/DD/MM

	// 5 DD-MM-YYYY
	// 6 MM-DD-YYYY
	// 7 YYYY-MM-DD
	// 8 YYYY-DD-MM

if (dateFormat1=="DD/MM/YYYY") {  
	 gdCtrl.value = iDay+"/"+iMonth+"/"+iYear;
} else if (dateFormat1=="MM/DD/YYYY") {
	gdCtrl.value = iMonth+"/"+iDay+"/"+iYear;
}  else if (dateFormat1=="YYYY/MM/DD") {
	gdCtrl.value = iYear+"/"+iMonth+"/"+iDay;
} else if (dateFormat1=="YYYY/DD/MM") {
	gdCtrl.value = iYear+"/"+iDay+"/"+iMonth;
} else if (dateFormat1=="DD-MM-YYYY") {
	gdCtrl.value = iDay+"-"+iMonth+"-"+iYear;
} else if (dateFormat1=="MM-DD-YYYY") {
	gdCtrl.value = iMonth+"-"+iDay+"-"+iYear;
} else if (dateFormat1=="YYYY-MM-DD") {
	gdCtrl.value = iYear+"-"+iMonth+"-"+iDay;
} else if (dateFormat1=="YYYY-DD-MM") {
	gdCtrl.value = iYear+"-"+iDay+"-"+iMonth;
} else if (dateFormat1=="DD/MM/YYYY HH24:MI") {
	gdCtrl.value = iDay+"/"+iMonth+"/"+iYear+" "+iHour+":"+iMinute;
} else {
	 gdCtrl.value = iYear+"/"+iMonth+"/"+iDay;
}

var siblingElement = null;
siblingElement = gdCtrl.nextSibling ;
var parentLength = gdCtrl.parentElement.children.length;
for (var y=0; y<parentLength; y++)
{
  if (siblingElement != null && siblingElement.type == "button")
  {
        siblingElement.focus();
        break;
  }
  siblingElement = siblingElement.nextSibling ;      
}

  for (i in goSelectTag)
  	goSelectTag[i].style.visibility = "visible";
  
  goSelectTag.length = 0;

  fCloseCal(); 

  if (isFromApplet == 1)
  {
		passDateToJSP();
		self.close();
  }
}


function fSetSelected(aCell){
  var iOffset = 0;
  var iYear = parseInt(tbSelYear.value);
  var iMonth = parseInt(tbSelMonth.value);
  self.event.cancelBubble = true;
  aCell.bgColor = gcBG;
  with (aCell.children["cellText"]){
  	var iDay = parseInt(innerText);
  	if (color=="#808080" || color=="#990000")
		iOffset = (Victor<10)?-1:1;
	iMonth += iOffset;
	if (iMonth<1) {
		iYear--;
		iMonth = 12;
	}else if (iMonth>12){
		iYear++;
		iMonth = 1;
	}
	with (document.all.tags("SELECT")){
 	    for (i=0; i<length; i++){
            if ((item(i).Victor !="Won")   && fTagInBound(item(i))){
 			    item(i).style.visibility = "visible";
 			    goSelectTag[goSelectTag.length] = item(i);
 		    }
		    else if((item(i).Victor !="undefined")){
			    item(i).style.visibility = "hidden";
		    }
	    }
    }
  }
  fSetDate(iYear, iMonth, iDay, giHours, giMinutes);
}

function Point(iX, iY){
	this.x = iX;
	this.y = iY;
}

function fBuildCal(iYear, iMonth) {
  var aMonth=new Array();
  for(i=1;i<7;i++)
  	aMonth[i]=new Array(i);

  var dCalDate=new Date(iYear, iMonth-1, 1);
  var iDayOfFirst=dCalDate.getDay();
  var iDaysInMonth=new Date(iYear, iMonth, 0).getDate();
  var iOffsetLast=new Date(iYear, iMonth-1, 0).getDate()-iDayOfFirst+1;
  var iDate = 1;
  var iNext = 1;

  for (d = 0; d < 7; d++)
	aMonth[1][d] = (d<iDayOfFirst)?-(iOffsetLast+d):iDate++;
  for (w = 2; w < 7; w++)
  	for (d = 0; d < 7; d++)
		aMonth[w][d] = (iDate<=iDaysInMonth)?iDate++:-(iNext++);
  return aMonth;
}

function fDrawCal(iYear, iMonth, iCellHeight, sDateTextSize) {
  
  var styleTD = " bgcolor='"+gcBG+"' bordercolor='"+gcBG+"' valign='middle' align='center' height='"+iCellHeight+"' style=\"font-family: Tahoma, 'MS Sans Serif', Verdana; font-size: 11px; font-weight: normal; color: #000000; ";
  var styleTD2 = " bgcolor='"+gcBG2+"' bordercolor='"+gcBG2+"' valign='middle' align='center' height='"+iCellHeight+"' style=\"font-family: Tahoma, 'MS Sans Serif', Verdana; font-size: 11px; font-weight: bold; color: #000000; \"";

  with (document) {
	write("<tr>");
	for(i=0; i<7; i++)
		write("<td "+styleTD2+"color:#990099' >" + WeekDay[i] + "</td>");
	write("</tr>");

  	for (w = 1; w < 7; w++) {
		write("<tr>");
		for (d = 0; d < 7; d++) {
			write("<td id=calCell "+styleTD+"cursor:hand;\" onMouseOver='if (this.bgColor != gcToday){ this.bgColor=gcToggle; this.style.fontWeight=\"bold\"; }' onMouseOut='if (this.bgColor != gcToday){ this.bgColor=gcBG; this.style.fontWeight=\"normal\"; }' onclick='fSetSelected(this)'>");
			write("<font id=cellText Victor='Liming Weng'> </font>");
			write("</td>")
		}
		write("</tr>");
	}
  }
}

function fUpdateCal(iYear, iMonth) {
  var idx = tbSelYear.selectedIndex;  
  iYear = yearArray[idx] ;

  myMonth = fBuildCal(iYear, iMonth);
  var i = 0;
  for (w = 0; w < 6; w++)
	for (d = 0; d < 7; d++)
		with (cellText[(7*w)+d]) {
			Victor = i++;
			if (myMonth[w+1][d]<0) {
				color = ((d==0)||(d==6))?"#990000":gcGray;
				innerText = -myMonth[w+1][d];
			}else{
				color = ((d==0)||(d==6))?"#FF0000":"black";
				if (iYear == giYear && iMonth == giMonth && myMonth[w+1][d] == giDay)
				{
					style.fontWeight = "bold";
					calCell[(7*w)+d].bgColor = gcToday;
					innerText = myMonth[w+1][d];
				}
				else
				{
					style.fontWeight = "";
					calCell[(7*w)+d].bgColor = gcBG;
					innerText = myMonth[w+1][d];
				}
			}
		}
}

function fSetYearMon(iYear, iMon){
  tbSelMonth.options[iMon-1].selected = true;
  for (i = 0; i < tbSelYear.length; i++)
	if (tbSelYear.options[i].value == iYear || tbSelYear.options[i].value == dispYear )
		tbSelYear.options[i].selected = true;
  fUpdateCal(iYear, iMon);

}

function fPrevMonth(){
  var iMon = tbSelMonth.value;
  var idx = tbSelYear.selectedIndex;
  var iYear = yearArray[idx] ;//tbSelYear.value; 
  dispYear = tbSelYear.value; 

  if (--iMon<1) {
	  iMon = 12;
	  iYear--;
	  dispYear--;
  }

  fSetYearMon(iYear, iMon);
}

function fNextMonth(){
  var iMon = tbSelMonth.value;
  var idx = tbSelYear.selectedIndex;  
  var iYear = yearArray[idx] ;//tbSelYear.value;
  dispYear = tbSelYear.value; 

  if (++iMon>12) {
	  iMon = 1;
	  iYear++;
	  dispYear++;
  }


//alert("HERE         "+iYear);
  fSetYearMon(iYear, iMon);
}

function fToggleTags(){
  with (document.all.tags("SELECT")){
 	for (i=0; i<length; i++){
 		if ((item(i).Victor!="Won")&&fTagInBound(item(i))){
 			item(i).style.visibility = "hidden";
 			goSelectTag[goSelectTag.length] = item(i);
 		}
 		if(item(i).name != null && (item(i).name == 'tbSelMonth' || item(i).name == 'tbSelYear')){
		    item(i).style.visibility = "visible";
		}
	}
  }
}

function fToggleTagsTwo(){
    with (document.all.tags("SELECT")){
 	    for (i=0; i<length; i++){
     		if ((item(i).Victor !="Won")   && fTagInBound(item(i))){
 	    		item(i).style.visibility = "visible";
 		    	goSelectTag[goSelectTag.length] = item(i);
 		    }
		    else if((item(i).Victor !="undefined")){
			    item(i).style.visibility = "visible";
			    goSelectTag[goSelectTag.length] = item(i);
		    }
        	if(item(i).name != null && (item(i).name == 'tbSelMonth' || item(i).name == 'tbSelYear')){
			    item(i).style.visibility = "hidden";
			}
	    }
    }  
}

function fTagInBound(aTag){
  with (VicPopCal.style){
  	var l = parseInt(left);
  	var t = parseInt(top);
  	var r = l+parseInt(width);
  	var b = t+parseInt(height);
	var ptLT = fGetXY(aTag);
	return !((ptLT.x>r)||(ptLT.x+aTag.offsetWidth<l)||(ptLT.y>b)||(ptLT.y+aTag.offsetHeight<t));
  }
}

function fGetXY(aTag){
  var oTmp = aTag;
  var pt = new Point(0,0);
  do {
  	pt.x += oTmp.offsetLeft;
  	pt.y += oTmp.offsetTop;
	//alert("pt.x is "+pt.x+"pt.y is "+pt.y)
  	oTmp = oTmp.offsetParent;
  } while(oTmp.tagName!="BODY");
  return pt;
}


// Main: popCtrl is the widget beyond which you want this calendar to appear;
//       dateCtrl is the widget into which you want to put the selected date.
// i.e.: <input type="text" name="dc" style="text-align:center" readonly><INPUT type="button" value="V" onclick="fPopCalendar(dc,dc);return false">
function fPopCalendar(popCtrl, dateCtrl, dateFormat, _day, _month, _year){
//alert ("_year " +_year );
/* added by Sri 2003-10-22 to overcome the control names with a '-' in them */
  
  if(typeof(popCtrl) == "string") {
	  popCtrl = document.getElementById(popCtrl);
  }
  if(typeof(dateCtrl) == "string") {
	  dateCtrl = document.getElementById(dateCtrl);
  }
  
  if (typeof(_day) == "number")
  	giDay = _day;
  else
  	giDay = gdCurDate.getDate();
  if (typeof(_month) == "number")
  	giMonth = _month;
  else
  	giMonth = gdCurDate.getMonth()+1;
  if (typeof(_year) == "number")
  	{
	  giYear = _year;
	 // alert("1 - " +giYear);
	}
  else{
  	giYear = gdCurDate.getFullYear();
	 // alert("2 - " +giYear);
  }
  	
	
/* addition ends */

//alert(dateFormat)

  gdCtrl = dateCtrl;
  dateFormat1 = dateFormat.toUpperCase();;
  fSetYearMon(giYear, giMonth);
  var point = fGetXY(popCtrl);
  dumPoint =  point;

  /* added by Rajneesh to avoid the horiziontal scroll bar for Modify RFQ page*/
  /* get screen resolution and adjust if required */
	browserName=navigator.appName;
	browserVer=parseInt(navigator.appVersion);
	if ((browserVer >= 4 & browserName == "Netscape") | (browserVer >= 4 & browserName == "Microsoft Internet Explorer")) {
		version="4";
	} else {
		version="3";
	}
	if (version=="4") {
		scrWidth = screen.width; 
		scrHeight = screen.height;
		if(point.x > (scrWidth - 600)){
		  point.x = point.x - 100;
		}
		if(point.y > (scrHeight - 400)){
			point.y = point.y - 250;
		}
	} else{
	}
  /* addition ends */

  with (VicPopCal.style) {
  	left = point.x;
	top  = point.y+popCtrl.offsetHeight+1;
	width = VicPopCal.offsetWidth;
	height = VicPopCal.offsetHeight;
	fToggleTags(point);
	visibility = 'visible';

	isCalShown = 1;
  }
  VicPopCal.focus();
}

function fCloseCal()
{
	VicPopCal.style.visibility = 'hidden';
	isCalShown = 0;
	fToggleTagsTwo(dumPoint);
}

function fHideCal(){
  var oE = window.event;
  if ((oE.clientX>0)&&(oE.clientY>0)&&(oE.clientX<document.body.clientWidth)&&(oE.clientY<document.body.clientHeight)) {
	var oTmp = document.elementFromPoint(oE.clientX,oE.clientY);
	while ((oTmp.tagName!="BODY") && (oTmp.id!="VicPopCal"))
		oTmp = oTmp.offsetParent;
	if (oTmp.id=="VicPopCal")
		return;
  }
  VicPopCal.style.visibility = 'hidden';
  isCalShown = 0;
  for (i in goSelectTag)
	goSelectTag[i].style.visibility = "visible";
  goSelectTag.length = 0;
}



with (document) {
write("<Div id='VicPopCal' onblur='' onclick='focus()' style='POSITION:absolute;visibility:hidden;border:2px ridge;width:10;z-index:100;'>");
write("<table id='caltable' border='0' bgcolor='#9FB3CC' width='200' height='200'>");
if (isFromApplet == 0)
{
	write("<TR style='background-color:" + "#3A6EA5" + "'>");
	write("<td id='topBar' name='topBar' valign='middle' align='right'><input type='button' name='btnClose' value='X' style=\"height:15;width:15;font-family: Tahoma, 'MS Sans Serif', Verdana; font-size: 8px; font-weight: bold; color: #000000; text-decoration: none\" onClick='self.event.cancelBubble=true; fCloseCal();'>");
	write("</td>");
	write("</TR>");
}
write("<TR>");
write("<td valign='middle' align='center'><input type='button' name='PrevMonth' value='<' style=\"height:20;width:20;font-family: Tahoma, 'MS Sans Serif', Verdana; font-size: 12px; font-weight: normal; color: #000000; text-decoration: none\" onClick='fPrevMonth()' onblur=''>");
write("&nbsp;<select name='tbSelMonth' style=\"font-family: Tahoma, 'MS Sans Serif', Verdana; font-size: 11px; color: #000000\" onChange='fUpdateCal(tbSelYear.value, tbSelMonth.value)' Victor='Won' onclick='self.event.cancelBubble=true' onblur=''>");
for (i=0; i<12; i++)
	write("<option value='"+(i+1)+"'>"+gMonths[i]+"</option>");
write("</SELECT>");
write("&nbsp;<SELECT name='tbSelYear' style=\"font-family: Tahoma, 'MS Sans Serif', Verdana; font-size: 11px; color: #000000\" onChange='fUpdateCal(tbSelYear.value, tbSelMonth.value)' Victor='Won' onclick='self.event.cancelBubble=true' onblur=''>");

//modified for displaying Thai dates
giYear1 = _year3 ;
var k = 0 ;
var tmpYear= giYear -50 ;
yearArray[0] = tmpYear
//
for(i=(giYear1-50);i<(giYear1+150);i++){
	if(	i == giYear1 )
		write("<OPTION selected value='"+i+"'>"+i+"</OPTION>");
		else
		write("<OPTION value='"+i+"'>"+i+"</OPTION>");
	yearArray[ k++] = tmpYear++;
}
write("</SELECT>");
write("&nbsp;<input type='button' name='PrevMonth' value='>' style=\"height:20;width:20;font-family: Tahoma, 'MS Sans Serif', Verdana; font-size: 12px; font-weight: normal; color: #000000; text-decoration: none\" onclick='fNextMonth()' onblur=''>");
write("</td>");
write("</TR><TR>");
write("<td align='center'>");
write("<DIV style='background-color:#3a6ea5'><table width='100%' border='0'>");
fDrawCal(giYear, giMonth, 15, '10');
write("</table></DIV>");
write("</td>");
write("</TR><TR><TD align='center'>");
write("<B style=\"font-family: Tahoma, 'MS Sans Serif', Verdana; font-size: 11px; font-weight: bold; color: #000000; cursor:hand;\" onclick='fSetDate(_year3,giMonth,giDay); self.event.cancelBubble=true' onMouseOver='this.style.color=gcToggle' onMouseOut='this.style.color=0'>" + gToday + ":  "+gMonths[giMonth-1]+" "+giDay+", "+_year3+"</B>");
write("</TD></TR>");write("</TD></TR>");
write("</TABLE>");
write("</Div>");
}


// ********************This is added for drag and drop of calendar ******************************** 
N = (document.all) ? 0 : 1;
var ob;
function MD(e) {
	if (isCalShown) {
		if (N) {
			
		if (e.target.name == "topBar")
		{
			ob = document.layers[e.target.name];
		}
		X=e.x;
		Y=e.y;
		return false;
		}
		else {
				
				//if(event.srcElement.parentElement)
		
				if(event.srcElement != null && document.getElementById("VicPopCal") != null && event.srcElement.id == "topBar") 
				{
				    //ob = event.srcElement.parentElement.style;
				    ob = document.getElementById("VicPopCal").style;
				}
				else
				{
				   //ob= event.srcElement.parentElement;
				   ob = document.getElementById("VicPopCal");
				}
				X=event.offsetX;
				Y=event.offsetY;
		   }
	}
}


function MM(e) {
if (isCalShown) {
	if (ob) {
	if (N) {
	ob.moveTo((e.pageX-X), (e.pageY-Y));
	}
	else {
	ob.pixelLeft = event.clientX-X + document.body.scrollLeft;
	ob.pixelTop = event.clientY-Y + document.body.scrollTop;
	return false;
	      }
	   }
}
}
function MU() {
ob = null;
}

if (N) {
	document.captureEvents(Event.MOUSEDOWN | Event.MOUSEMOVE | Event.MOUSEUP);
}

function MK() {
	if (isCalShown) 
	{
		key=(document.layers)?e.which:window.event.keyCode
		if (key=="27")
		{
			fCloseCal();
	       	}
	}
}
document.onmousedown = MD;
document.onmousemove = MM;
document.onmouseup = MU;
//document.onkeypress=MK;
//************************** End of Drag and Drop ******************************************************

