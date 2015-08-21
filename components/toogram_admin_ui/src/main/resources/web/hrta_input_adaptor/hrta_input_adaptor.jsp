<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.InputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.types.InputEventAdaptorConfigurationInfoDto" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.types.InputEventAdaptorFileDto" %>
<%@ page import="com.toogram.cep.ui.ToogramInputEventAdaptorUIUtils" %>

<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

<script type="text/javascript">
    var ENABLE = "enable";
    var DISABLE = "disable";
    var STAT = "statistics";
    var TRACE = "Tracing";

    function doDelete(eventName) {
        var theform = document.getElementById('deleteForm');
        theform.eventname.value = eventName;
        theform.submit();
    }

    <%--function deactivateInputEventAdaptor(eventAdaptorName) {--%>
        <%--jQuery.ajax({--%>
                        <%--type:'POST',--%>
                        <%--url:'stat_tracing-ajaxprocessor.jsp',--%>
                        <%--data:'eventAdaptorName=' + eventAdaptorName,--%>
                        <%--async:false,--%>
                        <%--success:function (msg) {--%>
                            <%--window.location.href = "../inputeventadaptormanager/index.jsp?ordinal=1";--%>
                        <%--},--%>
                        <%--error:function (msg) {--%>
                            <%--CARBON.showErrorDialog('<fmt:message key="deactivate.adaptor.error"/>' +--%>
                                                   <%--' ' + eventAdaptorName);--%>
                        <%--}--%>
                    <%--});--%>
    <%--}--%>

    function disableStat(eventAdaptorName) {
        jQuery.ajax({
                        type:'POST',
                        url:'../hrta_input_adaptor/hrta_stat_tracing-ajaxprocessor.jsp',
                        data:'eventAdaptorName=' + eventAdaptorName + '&action=disableStat',
                        async:false,
                        success:function (msg) {
                            handleCallback(eventAdaptorName, DISABLE, STAT);
                        },
                        error:function (msg) {
                            CARBON.showErrorDialog('통계 비활성화 에러' +
                                                   ' ' + eventAdaptorName);
                        }
                    });
    }

    function enableStat(eventAdaptorName) {
        jQuery.ajax({
                        type:'POST',
                        url:'../hrta_input_adaptor/hrta_stat_tracing-ajaxprocessor.jsp',
                        data:'eventAdaptorName=' + eventAdaptorName + '&action=enableStat',
                        async:false,
                        success:function (msg) {
                            handleCallback(eventAdaptorName, ENABLE, STAT);
                        },
                        error:function (msg) {
                            CARBON.showErrorDialog('통계 활성화 에러' +
                                                   ' ' + eventAdaptorName);
                        }
                    });
    }

    function handleCallback(eventAdaptor, action, type) {
        var element;
        if (action == "enable") {
            if (type == "statistics") {
                element = document.getElementById("disableStat" + eventAdaptor);
                element.style.display = "";
                element = document.getElementById("enableStat" + eventAdaptor);
                element.style.display = "none";
            } else {
                element = document.getElementById("disableTracing" + eventAdaptor);
                element.style.display = "";
                element = document.getElementById("enableTracing" + eventAdaptor);
                element.style.display = "none";
            }
        } else {
            if (type == "statistics") {
                element = document.getElementById("disableStat" + eventAdaptor);
                element.style.display = "none";
                element = document.getElementById("enableStat" + eventAdaptor);
                element.style.display = "";
            } else {
                element = document.getElementById("disableTracing" + eventAdaptor);
                element.style.display = "none";
                element = document.getElementById("enableTracing" + eventAdaptor);
                element.style.display = "";
            }
        }
    }

    function enableTracing(eventAdaptorName) {
        jQuery.ajax({
                        type:'POST',
                        url:'../hrta_input_adaptor/hrta_stat_tracing-ajaxprocessor.jsp',
                        data:'eventAdaptorName=' + eventAdaptorName + '&action=enableTracing',
                        async:false,
                        success:function (msg) {
                            handleCallback(eventAdaptorName, ENABLE, TRACE);
                        },
                        error:function (msg) {
                            CARBON.showErrorDialog('추적 활성화 에러' +
                                                   ' ' + eventAdaptorName);
                        }
                    });
    }

    function disableTracing(eventAdaptorName) {
        jQuery.ajax({
                        type:'POST',
                        url:'../hrta_input_adaptor/hrta_stat_tracing-ajaxprocessor.jsp',
                        data:'eventAdaptorName=' + eventAdaptorName + '&action=disableTracing',
                        async:false,
                        success:function (msg) {
                            handleCallback(eventAdaptorName, DISABLE, TRACE);
                        },
                        error:function (msg) {
                            CARBON.showErrorDialog('추적 비활성화 에러' +
                                                   ' ' + eventAdaptorName);
                        }
                    });
    }

</script>
<%
    String eventName = request.getParameter("eventname");
    int totalEventAdaptors = 0;
    int totalNotDeployedEventAdaptors = 0;
    if (eventName != null) {
        InputEventAdaptorManagerAdminServiceStub stub = ToogramInputEventAdaptorUIUtils.getInputEventManagerAdminService(config, session, request ,response);
        stub.undeployActiveInputEventAdaptorConfiguration(eventName);
%>
<script type="text/javascript">CARBON.showInfoDialog('이벤트 어답터가 삭제되었습니다.');</script>
<%
    }

    InputEventAdaptorManagerAdminServiceStub stub = ToogramInputEventAdaptorUIUtils.getInputEventManagerAdminService(config, session, request ,response);
    InputEventAdaptorConfigurationInfoDto[] eventDetailsArray = stub.getAllActiveInputEventAdaptorConfiguration();
    if (eventDetailsArray != null) {
        totalEventAdaptors = eventDetailsArray.length;
    }

    InputEventAdaptorFileDto[] notDeployedEventAdaptorConfigurationFiles = stub.getAllInactiveInputEventAdaptorConfigurationFile();
    if (notDeployedEventAdaptorConfigurationFiles != null) {
        totalNotDeployedEventAdaptors = notDeployedEventAdaptorConfigurationFiles.length;
    }

%>
<div id="cols">
	<p id="breadCurmb">
		Home &gt; 인풋어답터 &gt; 어답터 추가						
	</p>
	<div class="hgroup">
		<h1>현재 사용가능한 인풋 이벤트 어답터 목록</h1>
	</div>					
	
	<!-- header group -->
	<div class="act">
		<h2>아답터 생성</h2>
		<p class="fnc-set">
			<a href="../hrta_input_adaptor/hrta_create_eventAdaptor.jsp?ordinal=1" class="btn-add"><i class="fa fa-plus-circle fa-2"></i>Input Event Adaptor 추가</a>							
		</p>
		<p class="lead-t"><%=totalEventAdaptors%> Active 상태 Input Adaptor
		 <% if (totalNotDeployedEventAdaptors > 0) { %><a
    				href="../hrta_input_adaptor/hrta_event_adaptor_files_details.jsp?ordinal=1"><%=totalNotDeployedEventAdaptors%>
					Inactive 상태 Input Adaptor</a><% } else {%><%=totalNotDeployedEventAdaptors%>
					Inactive 상태 Input Adaptor <% } %>
					</p>
					<br/>
		<table class="styledVertical">
		
		<%
            if (eventDetailsArray != null) {
        %>
			
			<thead>
				<tr>
					<th>이벤트 명</th>
					<th>구분</th>
					<th>수정</th>
				</tr>
			</thead>
			<tbody>
			<%
				for (InputEventAdaptorConfigurationInfoDto eventDetails : eventDetailsArray) {
			%>    
           		<tr class="tableOddRow">
					<th><a href="../hrta_input_adaptor/hrta_event_details.jsp?ordinal=1&eventName=<%=eventDetails.getEventAdaptorName()%>&eventType=<%=eventDetails.getEventAdaptorType()%>"><%=eventDetails.getEventAdaptorName()%>
					</a></th>
					<td><%=eventDetails.getEventAdaptorType().trim()%></td>
					<td class="fnc-btn">
					<% if (eventDetails.getEnableStats()) {%>						
							                
	                    <div id="disableStat<%= eventDetails.getEventAdaptorName()%>">
	                        <a href="#" onclick="disableStat('<%= eventDetails.getEventAdaptorName() %>')"
	                           class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
	                    </div>
	                    <div id="enableStat<%= eventDetails.getEventAdaptorName()%>"
	                         style="display:none;">
	                        <a href="#" onclick="enableStat('<%= eventDetails.getEventAdaptorName() %>')"
	                           class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
	                    </div>
	                <% } else { %>
	                    <div id="enableStat<%= eventDetails.getEventAdaptorName()%>">
	                        <a href="#"
	                           onclick="enableStat('<%= eventDetails.getEventAdaptorName() %>')"
	                           class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
	                    </div>
	                    <div id="disableStat<%= eventDetails.getEventAdaptorName()%>"
	                         style="display:none">
	                        <a href="#"
	                           onclick="disableStat('<%= eventDetails.getEventAdaptorName() %>')"
	                           class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
	                    </div>
	                <% }
	                    if (eventDetails.getEnableTracing()) {%>
	                    <div id="disableTracing<%= eventDetails.getEventAdaptorName()%>">
	                        <a href="#"
	                           onclick="disableTracing('<%= eventDetails.getEventAdaptorName() %>')"
	                           class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
	                    </div>
	                    <div id="enableTracing<%= eventDetails.getEventAdaptorName()%>"
	                         style="display:none;">
	                        <a href="#"
	                           onclick="enableTracing('<%= eventDetails.getEventAdaptorName() %>')"
	                           class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
	                    </div>
	                <% } else { %>
	                    <div id="enableTracing<%= eventDetails.getEventAdaptorName()%>">
	                        <a href="#"
	                           onclick="enableTracing('<%= eventDetails.getEventAdaptorName() %>')"
	                           class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
	                    </div>
	                    <div id="disableTracing<%= eventDetails.getEventAdaptorName()%>"
	                         style="display:none">
	                        <a href="#"
	                           onclick="disableTracing('<%= eventDetails.getEventAdaptorName() %>')"
	                           class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
	                    </div>
						<% } %>
						<a class="delete" onclick="doDelete('<%=eventDetails.getEventAdaptorName()%>')"><i class="fa fa-trash"></i>삭제</a>
						<a class="edit" href="../hrta_input_adaptor/hrta_edit_event_details.jsp?ordinal=1&eventName=<%=eventDetails.getEventAdaptorName()%>">
						<i class="fa fa-pencil-square-o"></i>수정</a>
					</td>
				</tr>
			<%
				}
			%>
			</tbody>
		<%
			}
		%>							
		</table>
	</div>
	<div>
        <br/>
        <form id="deleteForm" name="input" action="" method="post"><input type="HIDDEN"
                                                                         name="eventname"
                                                                         value=""/></form>
	</div>
	<!-- header group -->
</div>
	
