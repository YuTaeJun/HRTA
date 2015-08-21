<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="java.text.DateFormatSymbols" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>

<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>
<script type="text/javascript" src="../ajax/js/prototype.js"></script>

<%
    String scriptName = request.getParameter("scriptName");
    if (null == scriptName) {
        scriptName = "";
    }
    String scriptContent = request.getParameter("scriptContent");
    if (null != scriptContent && !"".equals(scriptContent)) {
        session.setAttribute("scriptContent" + scriptName, scriptContent);
    }
    String mode = request.getParameter("mode");
    String editability = request.getParameter("editability");
    String cron = request.getParameter("cron");
    String saveWithCron = request.getParameter("saveWithCron");
    if (null == saveWithCron) saveWithCron = "";
%>
<script type="text/javascript">

    var cronExpSelected = '';

    function saveCron() {
        if (document.getElementById('selectUI').checked) {
            var optionCron = 'selectUI';
            var year = document.getElementById('year').value;
            var month = document.getElementById('month').value;
            var day_month = document.getElementById('dayMonth').value;
            var day_week = document.getElementById('dayWeek').value;
            var selectDay = '';
            if (document.getElementById('selectDayMonth').checked) {
                selectDay = 'selectDayMonth';
            } else {
                selectDay = 'selectDayWeek';
            }
            var hour = document.getElementById('hours').value;
            var minutes = document.getElementById('minutes').value;

            new Ajax.Request('../hive-explorer/SaveCronExpression', {
                        method: 'post',
                        parameters: {yearSelected:year, monthSelected:month,
                            dayMonthSelected:day_month, dayWeekSelected:day_week,
                            selectDay:selectDay,hoursSelected: hour, minutesSelected:minutes,
                            optionCron:optionCron},
                        onSuccess: function(transport) {
                            var result = transport.responseText;
                            var array = result.split('#');
                            var message = array[0];
                            if (message.indexOf("Success") != -1) {
                                cronExpSelected = array[2];
                                CARBON.showInfoDialog(array[0], function() {
                                    location.href = '../hrta_hive-explorer/hrta_hiveexplorer.jsp?cron=' + cronExpSelected
                                            + '&editability=' + '<%=editability%>' + '&scriptName='
                                            + '<%=scriptName%>' + '&mode=' + '<%=mode%>'
                                            + '&saveWithCron=' + '<%=saveWithCron%>';
                                }, function() {
                                    location.href = '../hrta_hive-explorer/hrta_hiveexplorer.jsp?cron=' + cronExpSelected
                                            + '&editability=' + '<%=editability%>' + '&scriptName='
                                            + '<%=scriptName%>' + '&mode=' + '<%=mode%>'
                                            + '&saveWithCron=' + '<%=saveWithCron%>';
                                });

                            } else {
                                CARBON.showErrorDialog(message);
                            }
                        },
                        onFailure: function(transport) {
                            CARBON.showErrorDialog(transport.responseText);
                        }
                    });
        } else if (document.getElementById('cronExpSelect').checked) {
            optionCron = "customCron";
            var customCronVal = document.getElementById('cronExpression').value;
            if (customCronVal == '') {
                CARBON.showErrorDialog('Please enter a cron expression in the text field');
            } else {
                new Ajax.Request('../hrta_hive-explorer/hrta_SaveCronExpression', {
                            method: 'post',
                            parameters: {optionCron:optionCron,
                                customCron:customCronVal},
                            onSuccess: function(transport) {
                                var message = transport.responseText;
                                var array = message.split('#');
                                cronExpSelected = array[2];
                                CARBON.showInfoDialog(array[0], function() {
                                    location.href = '../hrta_hive-explorer/hrta_hiveexplorer.jsp?cron=' + cronExpSelected
                                            + '&editability=' + '<%=editability%>' + '&scriptName=' + '<%=scriptName%>'
                                            + '&mode=' + '<%=mode%>'
                                            + '&saveWithCron=' + '<%=saveWithCron%>';
                                }, function() {
                                    location.href = '../hrta_hive-explorer/hrta_hiveexplorer.jsp?cron=' + cronExpSelected
                                            + '&editability=' + '<%=editability%>' + '&scriptName=' + '<%=scriptName%>'
                                            + '&mode=' + '<%=mode%>'
                                            + '&saveWithCron=' + '<%=saveWithCron%>';
                                });

                                if (message.contains("Success")) {


                                } else {
                                    CARBON.showErrorDialog(message);
                                }
                            },
                            onFailure: function(transport) {
                                CARBON.showErrorDialog(transport.responseText);
                            }
                        });
            }
        } else if (document.getElementById('noSchedule').checked) {
            location.href = '../hrta_hive-explorer/hrta_hiveexplorer.jsp?cron=' + '&scriptName=' + '<%=scriptName%>'
                    + '&editability=' + '<%=editability%>' + '&mode=' + '<%=mode%>'
        } else {
            //when interval -count option is selected..
        }
        return true;
    }


    function cancelConnect() {
        location.href = "../hrta_hive-explorer/hrta_listscripts.jsp";
    }

    function customCronEnable() {
        disableCustomCron(false);
        disableUI(true);
//        disableIntervalSelection(true);
    }

    function simpleUI() {
        disableUI(false);
        disableCustomCron(true);
//        disableIntervalSelection(true);
    }

    function disableUI(value) {
        document.getElementById('year').disabled = value;
        document.getElementById('month').disabled = value;
        document.getElementById('hours').disabled = value;
        document.getElementById('minutes').disabled = value;
        document.getElementById('selectDayMonth').disabled = value;
        document.getElementById('selectDayWeek').disabled = value;
        disableDaySelection(value);
    }

    function disableDaySelection(value) {
        if (!value) {//if enable
            var monthChecked = document.getElementById('selectDayMonth').checked;
            var weekChecked = document.getElementById('selectDayWeek').checked;
            if (monthChecked) {
                dayMonthSelection();
            } else if (weekChecked) {
                dayWeekSelection();
            } else {
                document.getElementById('selectDayMonth').checked = true;
                dayMonthSelection();
            }
        }
        else {
            document.getElementById('dayMonth').disabled = value;
            document.getElementById('dayWeek').disabled = value;
        }
    }

    function disableCustomCron(value) {
        document.getElementById('cronExpression').disabled = value;
    }

    function dayWeekSelection() {
        disableSelectDayWeek(false);
        disableSelectDayMonth(true);
    }

    function disableSelectDayWeek(value) {
        document.getElementById('dayWeek').disabled = value;
    }

    function disableSelectDayMonth(value) {
        document.getElementById('dayMonth').disabled = value;
    }


    function dayMonthSelection() {
        disableSelectDayMonth(false);
        disableSelectDayWeek(true);
    }

    function intervalSelection() {
        disableCustomCron(true);
        disableUI(true);
//        disableIntervalSelection(false);
    }

    function unscheduleSelection() {
        disableCustomCron(true);
        disableUI(true);
    }


    //    function disableIntervalSelection(value) {
    //        document.getElementById('interval').disabled = value;
    //        document.getElementById('count').disabled = value;
    //    }

    function cancelCron() {
        location.href = '../hrta_hive-explorer/hrta_hiveexplorer.jsp?scriptName=' + '<%=scriptName%>' + '&mode=' + '<%=mode%>'
                + '&editability=' + '<%=editability%>' + '&saveWithCron="false"&schedulingCanceled=true';
    }


</script>

<style type="text/css">
    table.day {
        border-width: 1px;
        border-style: solid;
        border-color: white;
        background-color: white;
        width: 100%;
    }

</style>


<div id="cols">
	<p id="breadCurmb">
		Home &gt; 데이터 분석 &gt; 하이브 쿼리 스크립트 스케줄링						
	</p>
	<div class="hgroup">
		<h1>스크립트 스케줄링(batch)</h1>
	</div>
	<div id="workArea" class="act">

	<form id="cronForm" name="cronForm" action="" method="POST">
		<div class="detail-view">     
			<table class="detail">
			<thead>
			<tr>
			    <th>
			        <input TYPE=RADIO NAME="cronExpSelect" id="cronExpSelect" VALUE="cronExpSelect"
			               checked="true" onclick="customCronEnable();">
			        <label>클론 등록으로 스케줄링: </label>
			    </th>
			</tr>
			</thead>
		<tbody>
		<tr>
		    <td>
		        <div class="detail-view">         
	        	<table class="detail">
		            <tbody>
		            <tr>
		                <td width="250px">Cron Expression
		                    <span class="required">*</span></td>
		                <td><input name="cronExpression"
		                           id="cronExpression"
		                        <%
		                            if (cron != null && !cron.equals("")) {
		                        %>
		                           value='<%=cron%>'
		                        <%
		                        } else {
		                        %>
		                           value="1 * * * * ? *"
		                        <%
		                            }
		                        %>
		                           size="60"/>
		                </td>
		            </tr>
		            </tbody>
		        </table>
		        </div>
		    </td>
		</tr>
		</tbody>
		<thead>
		<tr>
		    <th>
		        <input TYPE=RADIO NAME="cronExpSelect" id="selectUI" VALUE="selectUI"
		               onclick="simpleUI()">
		               <label>단순 스케줄링:</label>
		    </th>
		</tr>
		</thead>
		<tbody>
		<tr>
		    <td>
		    	<div class="detail-view">   
		        <table class="detail" id='allSimpleConf'>
		            <tbody>
		            <tr>
		                <td>year</td>
		                <td>
		                    <select name="year" id="year">
		                        <%
		                            int year = Calendar.getInstance().get(Calendar.YEAR);
		                        %>
		                        <option value="All">Every Year</option>
		                        <%
		                            for (int i = year; i <= 2099; i++) {
		                        %>
		                        <option value="<%=i%>"><%=i%>
		                        </option>
		                        <%
		                            }
		                        %>
		                    </select>
		
		                </td>
		            </tr>
		            <tr>
		                <td>month</td>
		                <td>
		                    <select name="month" id="month">
		                        <%
		                            String[] months = new DateFormatSymbols().getMonths();
		                        %>
		                        <option value="All">Every Month</option>
		                        <%
		                            for (int i = 0; i < 12; i++) {
		                        %>
		                        <option value="<%=i+1%>"><%=months[i]%>
		                        </option>
		                        <%
		                            }
		                        %>
		                    </select>
		
		                </td>
		            </tr>
		            <tr>
		                <td>
		                    <input TYPE=RADIO NAME="selectDay" id="selectDayMonth"
		                           VALUE="selectDayMonth"
		                           checked="true" onclick="dayMonthSelection()">
		                           <label>스케줄링을 위하여 월의 해당 일 지정 </label><br>
		                </td>
		
		                <td>
		                    <select name="dayMonth" id="dayMonth">
		                        <option value="All">Every Days of a Month</option>
		
		                        <%
		                            for (int i = 1; i <= 31; i++) {
		                        %>
		                        <option value="<%=i%>">Day - <%=i%> of Selected Month
		                        </option>
		                        <%
		                            }
		                        %>
		
		                    </select>
		
		                </td>
		            </tr>
		            <tr>
		                <td>
		                    <input TYPE=RADIO NAME="selectDay" id="selectDayWeek"
		                           VALUE="selectDayWeek"
		                           onclick="dayWeekSelection();">
		                           <label>일주일 중 특정 요일을 사용</label><br>
		
		                </td>
		                <td>
		                    <select name="dayWeek" id="dayWeek" onclick="">
		                        <%
		                            String[] weekdays = new DateFormatSymbols().getWeekdays();
		                        %>                 scriptName != null && !scriptName.equals("")
		                        <option value="All">Every Days of a week</option>
		                        <%
		                            for (int i = 1; i <= 7; i++) {
		                        %>
		
		                        <option value="<%=i%>"><%=weekdays[i]%>
		                        </option>
		                        <%
		                            }
		                        %>
		                    </select>
		                </td>
		            </tr>
		            <tr>
		                <td>hours</td>
		                <td>
		                    <select name="hours" id="hours">
		                        <option value="All">매 시간</option>
		                        <%
		                            for (int i = 0; i <= 23; i++) {
		                        %>
		                        <option value="<%=i%>"><%=i%>
		                        </option>
		                        <%
		                            }
		                        %>
		                    </select>
		
		                </td>
		            </tr>
		            <tr>
		                <td>minutes</td>
		                <td>
		                    <select name="minutes" id="minutes">
		                        <option value="All">매 분</option>
		                        <%
		                            for (int i = 0; i <= 59; i++) {
		                        %>
		                        <option value="<%=i%>"><%=i%>
		                        </option>
		                        <%
		                            }
		                        %>
		                    </select>
		
		                </td>
		            </tr>
		            </tbody>
		        </table>
		    </td>
		</tr>
		</tbody>
		<thead>
		<tr>
		    <th>
		        <input TYPE=RADIO NAME="cronExpSelect" id="noSchedule" VALUE="noSchedule" onclick="unscheduleSelection()">
		        <label>스케줄링 하지 않음</label>
		    </th>
		</tr>
		</thead>
		
		<tbody>
		<tr>		
		    <td>
		    	<div class="btn-set">
			        <input class="btn" type="button" value="Save" onclick="saveCron()"/>
			        <input class="btn" type="button" value="Cancel" onclick="cancelCron()"/>
		        </div>
		    </td>
		</tr>
		<input type="hidden" name="scriptContent" id="scriptContent"/>
		<input type="hidden" name="cron" id="cron"/>
		<input type="hidden" name="scriptName" id="scriptName"/>
		<input type="hidden" name="mode" id="mode"/>
		</tbody>
		</table>
	</div>	
	</form>
	</div>
</div>

<script type="text/javascript">
    <%
    if(null != cron && !cron.isEmpty()){
    %>
    customCronEnable();
    <%
    }else {
    %>
    document.getElementById('noSchedule').checked = 'true';
    unscheduleSelection();
    <%
    }
    %>

</script>
