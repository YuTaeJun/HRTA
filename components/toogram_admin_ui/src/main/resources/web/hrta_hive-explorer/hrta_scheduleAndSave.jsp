<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.client.HiveScriptStoreClient" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%@ page import="java.util.Calendar" %>

    <script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
    <script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
    <script type="text/javascript" src="../cep-admin/js/main.js"></script>
    <script type="text/javascript" src="../ajax/js/prototype.js"></script>
    
<%
    String scriptName = request.getParameter("scriptName");
    String editability = request.getParameter("editability");
    
    String serverURL = (String)session.getAttribute("serverURL");    
    String sessionCookie = (String)session.getAttribute("authCookie");
    
    ConfigurationContext configContext =
            (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
    
    HiveScriptStoreClient client = new HiveScriptStoreClient(sessionCookie, serverURL, configContext);
    
    String cron = client.getCronExpression(scriptName);
%>
<script type="text/javascript">
    var cronExpSelected = '';
    var scriptName = '<%=scriptName%>';
    var editability = '<%=editability%>';

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
            
            new Ajax.Request('../hrta_hive-explorer/hrta_saveCronExpression_ajaxprocessor.jsp', {
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
                                
                                sendRequestToSaveScript(cronExpSelected);
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
                new Ajax.Request('../hrta_hive-explorer/hrta_saveCronExpression_ajaxprocessor.jsp', {
                            method: 'post',
                            parameters: {optionCron:optionCron,
                                customCron:customCronVal},
                            onSuccess: function(transport) {
                                var message = transport.responseText;
                                var array = message.split('#');
                                cronExpSelected = array[2];
                                sendRequestToSaveScript(cronExpSelected);

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
            sendRequestToSaveScript(cronExpSelected);
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


    function cancelCron() {
        history.go(-1);
    }

    function sendRequestToSaveScript(cron) {
        new Ajax.Request('../hrta_hive-explorer/hrta_saveScriptProcessor_ajaxprocessor.jsp', {
                    method: 'post',
                    parameters: {scriptName:scriptName, editability:editability,
                        cronExp:cron},
                    onSuccess: function(transport) {
                        var result = transport.responseText;
                        if (result.indexOf('Success') != -1) {
                            CARBON.showInfoDialog(result, function() {
                                location.href = "../hrta_hive-explorer/hrta_listscripts.jsp";
                            }, function() {
                                location.href = "../hrta_hive-explorer/hrta_listscripts.jsp";
                            });

                        } else {
                            CARBON.showErrorDialog(result);
                        }
                    },
                    onFailure: function(transport) {
                        CARBON.showErrorDialog(result);
                    }
                });
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
	               checked="true" onclick="customCronEnable();" >
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
	                <td>Cron Expression
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
	               onclick="simpleUI()"><label>단순 스케줄링:</label>
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
	        </div>
	    </td>
	</tr>
	</tbody>
	<thead>
	<tr>
	    <th>
	        <input TYPE=RADIO NAME="cronExpSelect" id="noSchedule" VALUE="noSchedule" onclick="unscheduleSelection();">
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
