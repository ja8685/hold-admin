﻿var target;
var pop_top;
var pop_left;
var cal_Day;
var oPopup = window.createPopup();

function Calendar_Click(e) {
	cal_Day = e.title;
	if (cal_Day.length > 6) {
		target.value = cal_Day
	}
	oPopup.hide();
}

function Calendar_D(obj) {
	var now = obj.value.split("-");
	target = obj;
	pop_top = document.body.clientTop + GetObjectTop(obj) - document.body.scrollTop;
	pop_left = document.body.clientLeft + GetObjectLeft(obj) -  document.body.scrollLeft;

	if (now.length == 3) {
		Show_cal(now[0],now[1],now[2]);					
	} else {
		now = new Date();
		Show_cal(now.getFullYear(), now.getMonth()+1, now.getDate());
	}
}

function Calendar_M(obj) {
	var now = obj.value.split("-");
	target = obj;
	pop_top = document.body.clientTop + GetObjectTop(obj) - document.body.scrollTop;
	pop_left = document.body.clientLeft + GetObjectLeft(obj) -  document.body.scrollLeft;

	if (now.length == 2) {
		Show_cal_M(now[0],now[1]);					
	} else {
		now = new Date();
		Show_cal_M(now.getFullYear(), now.getMonth()+1);
	}
}

function doOver(el) {
	cal_Day = el.title;

	if (cal_Day.length > 7) {
		el.style.borderColor = "#FF0000";
	}
}

function doOut(el) {
	cal_Day = el.title;

	if (cal_Day.length > 7) {
		el.style.borderColor = "#FFFFFF";
	}
}

function day2(d) {	
	
	var str = new String();
	
	if (parseInt(d) < 10) {
		str = "0" + parseInt(d);
	} else {
		str = "" + parseInt(d);
	}
	return str;
}

function Show_cal(sYear, sMonth, sDay) {
	var Months_day = new Array(0,31,28,31,30,31,30,31,31,30,31,30,31)
	var Month_Val = new Array("01","02","03","04","05","06","07","08","09","10","11","12");
	var intThisYear = new Number(), intThisMonth = new Number(), intThisDay = new Number();

	datToday = new Date();													
	
	
	intThisYear = parseInt(sYear,10);
	intThisMonth = parseInt(sMonth,10);
	intThisDay = parseInt(sDay,10);
	
	if (intThisYear == 0) intThisYear = datToday.getFullYear();				
	
	if (intThisMonth == 0) intThisMonth = parseInt(datToday.getMonth(),10)+1;	
	if (intThisDay == 0) intThisDay = datToday.getDate();
	
	switch(intThisMonth) {
		case 1:
				intPrevYear = intThisYear -1;
				intPrevMonth = 12;
				intNextYear = intThisYear;
				intNextMonth = 2;
				break;
		case 12:
				intPrevYear = intThisYear;
				intPrevMonth = 11;
				intNextYear = intThisYear + 1;
				intNextMonth = 1;
				break;
		default:
				intPrevYear = intThisYear;
				intPrevMonth = parseInt(intThisMonth,10) - 1;
				intNextYear = intThisYear;
				intNextMonth = parseInt(intThisMonth,10) + 1;
				break;
	}
	intPPyear = intThisYear-1
	intNNyear = intThisYear+1

	NowThisYear = datToday.getFullYear();									
		
	NowThisMonth = datToday.getMonth()+1;									
	
	NowThisDay = datToday.getDate();											
	
	
	datFirstDay = new Date(intThisYear, intThisMonth-1, 1);			
	
	intFirstWeekday = datFirstDay.getDay();									
	
	
	
	intThirdWeekday = intFirstWeekday;
	
	datThisDay = new Date(intThisYear, intThisMonth, intThisDay);	
	
	
	
	
	intPrintDay = 1;																
	
	secondPrintDay = 1;
	thirdPrintDay = 1;

	Stop_Flag = 0
	
	if ((intThisYear % 4)==0) {												
		
		if ((intThisYear % 100) == 0) {
			if ((intThisYear % 400) == 0) {
				Months_day[2] = 29;
			}
		} else {
			Months_day[2] = 29;
		}
	}
	intLastDay = Months_day[intThisMonth];						
	

	Cal_HTML = "<form name='calendar'>";
	Cal_HTML += "<table id=Cal_Table border=0 bgcolor='#f4f4f4' cellpadding=1 cellspacing=1 width=100% onmouseover='parent.doOver(window.event.srcElement)' onmouseout='parent.doOut(window.event.srcElement)' style='font-size : 12;font-family:굴림;'>";
	Cal_HTML += "<tr height='35' align=center bgcolor='#f4f4f4'>";
	Cal_HTML += "<td colspan=7 align=center>";
	Cal_HTML += "	<select name='selYear' STYLE='font-size:11;' OnChange='parent.fnChangeYearD(calendar.selYear.value, calendar.selMonth.value, "+intThisDay+")';>";
	for (var optYear=(intThisYear-2); optYear<(intThisYear+2); optYear++) {
		Cal_HTML += "		<option value='"+optYear+"' ";
		if (optYear == intThisYear) Cal_HTML += " selected>\n";
		else Cal_HTML += ">\n";
		Cal_HTML += optYear+"</option>\n";
	}
	Cal_HTML += "	</select>";
	Cal_HTML += "&nbsp;&nbsp;&nbsp;<a style='cursor:hand;' OnClick='parent.Show_cal("+intPrevYear+","+intPrevMonth+","+intThisDay+");'>◀</a> ";
	Cal_HTML += "<select name='selMonth' STYLE='font-size:11;' OnChange='parent.fnChangeYearD(calendar.selYear.value, calendar.selMonth.value, "+intThisDay+")';>";
	for (var i=1; i<13; i++) {	
		Cal_HTML += "		<option value='"+Month_Val[i-1]+"' ";
		if (intThisMonth == parseInt(Month_Val[i-1],10)) Cal_HTML += " selected>\n";
		else Cal_HTML += ">\n";
		Cal_HTML += Month_Val[i-1]+"</option>\n";
	}
	Cal_HTML += "	</select>&nbsp;";
	Cal_HTML += "<a style='cursor:hand;' OnClick='parent.Show_cal("+intNextYear+","+intNextMonth+","+intThisDay+");'>▶</a>";
	Cal_HTML += "</td></tr>";
	Cal_HTML += "<tr align=center bgcolor='#FFB85C' style='color:#2065DA;' height='25'>";
	Cal_HTML += "	<td style='padding-top:3px;' width='24'><font color=red>일</font></td>";
	Cal_HTML += "	<td style='padding-top:3px;' width='24'><font color=black>월</font></td>";
	Cal_HTML += "	<td style='padding-top:3px;' width='24'><font color=black>화</font></td>";
	Cal_HTML += "	<td style='padding-top:3px;' width='24'><font color=black>수</font></td>";
	Cal_HTML += "	<td style='padding-top:3px;' width='24'><font color=black>목</font></td>";
	Cal_HTML += "	<td style='padding-top:3px;' width='24'><font color=black>금</font></td>";
	Cal_HTML += "	<td style='padding-top:3px;' width='24'><font color=blue>토</font></td>";
	Cal_HTML += "</tr>";
		
	for (intLoopWeek=1; intLoopWeek < 7; intLoopWeek++) {	
		
		Cal_HTML += "<tr height='24' align=right bgcolor='white'>"
		for (intLoopDay=1; intLoopDay <= 7; intLoopDay++) {	
			
			if (intThirdWeekday > 0) {											
				
				Cal_HTML += "<td>";
				intThirdWeekday--;
			} else {
				if (thirdPrintDay > intLastDay) {								
					
					Cal_HTML += "<td>";
				} else {																
					
					Cal_HTML += "<td onClick=parent.Calendar_Click(this); title="+intThisYear+"-"+day2(intThisMonth).toString()+"-"+day2(thirdPrintDay).toString()+" style=\"cursor:Hand;border:1px solid white;";
					if (intThisYear == NowThisYear && intThisMonth==NowThisMonth && thirdPrintDay==intThisDay) {
						Cal_HTML += "background-color:#C6F2ED;";
					}
					
					switch(intLoopDay) {
						case 1:															
						
							Cal_HTML += "color:red;"
							break;
						case 7:
							Cal_HTML += "color:blue;"
							break;
						default:
							Cal_HTML += "color:black;"
							break;
					}
					Cal_HTML += "\">"+thirdPrintDay;
				}
				thirdPrintDay++;
				
				if (thirdPrintDay > intLastDay) {								
					
					Stop_Flag = 1;
				}
			}
			Cal_HTML += "</td>";
		}
		Cal_HTML += "</tr>";
		if (Stop_Flag==1) break;
	}
	Cal_HTML += "</table></form>";

	var oPopBody = oPopup.document.body;
	oPopBody.style.backgroundColor = "lightyellow";
	oPopBody.style.border = "solid black 1px";
	oPopBody.innerHTML = Cal_HTML;

	var calHeight = oPopBody.document.all.Cal_Table.offsetHeight;
	
	
	if (intLoopWeek == 6)	calHeight = 214;
	else	calHeight = 189;
	
	oPopup.show(pop_left, (pop_top + target.offsetHeight), 170, calHeight, document.body);
}



function fnChangeYearD(sYear,sMonth,sDay){
	Show_cal(sYear, sMonth, sDay);
}



function fnChangeYearM(sYear,sMonth){
	Show_cal_M(sYear, sMonth);
}



function GetObjectTop(obj)
{
	if (obj.offsetParent == document.body)
		return obj.offsetTop;
	else
		return obj.offsetTop + GetObjectTop(obj.offsetParent);
}

function GetObjectLeft(obj)
{
	if (obj.offsetParent == document.body)
		return obj.offsetLeft;
	else
		return obj.offsetLeft + GetObjectLeft(obj.offsetParent);
}

