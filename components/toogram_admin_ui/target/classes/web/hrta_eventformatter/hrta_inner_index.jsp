<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.EventFormatterConfigurationFileDto" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.EventFormatterConfigurationInfoDto" %>

    <script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
    <script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
    <script type="text/javascript" src="../cep-admin/js/main.js"></script>
    
<script type="text/javascript" src="../hrta_eventformatter/js/event_formatter.js"></script>

<%
    EventFormatterAdminServiceStub stub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);
    String eventFormatterName = request.getParameter("eventFormatter");
    int totalEventFormatters = 0;
    int totalNotDeployedEventFormatters = 0;
    if (eventFormatterName != null) {
        stub.undeployActiveEventFormatterConfiguration(eventFormatterName);
%>
<script type="text/javascript">CARBON.showInfoDialog('Event Formatter successfully deleted.');</script>
<%
    }

    EventFormatterConfigurationInfoDto[] eventFormatterDetailsArray = stub.getAllActiveEventFormatterConfiguration();
    if (eventFormatterDetailsArray != null) {
        totalEventFormatters = eventFormatterDetailsArray.length;
    }

    EventFormatterConfigurationFileDto[] notDeployedEventFormatterConfigurationFiles = stub.getAllInactiveEventFormatterConfiguration();
    if (notDeployedEventFormatterConfigurationFiles != null) {
        totalNotDeployedEventFormatters = notDeployedEventFormatterConfigurationFiles.length;
    }

%>

<div id="act">

    <%=totalEventFormatters%> 횔성화된 이벤트 포멧터 , <% if (totalNotDeployedEventFormatters > 0) { %><a
        href="../hrta_eventformatter/hrta_notdeployed_event_formatter_files_details.jsp?ordinal=1">
        <%=totalNotDeployedEventFormatters%>
    비 활성화된 이벤트 포멧터</a><% } else {%><%=totalNotDeployedEventFormatters%>
    비 활성화된 이벤트 포멧터 <% } %>
    <br/><br/>
    <table class="styledVertical">
        <%

            if (eventFormatterDetailsArray != null) {
        %>
        <thead>
        <tr>
            <th>이벤트 포멧터 명</th>
            <th>이벤트 타입</th>
            <th>아웃품 이벤트 어답터 명</th>
            <th>스트림 아이디</th>
            <th>수정</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (EventFormatterConfigurationInfoDto eventFormatterDetails : eventFormatterDetailsArray) {
        %>
        <tr>
            <td>
                <a href="../hrta_eventformatter/hrta_eventFormatter_details.jsp?ordinal=1&eventFormatterName=<%=eventFormatterDetails.getEventFormatterName()%>"><%=eventFormatterDetails.getEventFormatterName()%>
                </a>

            </td>
            <td><%=eventFormatterDetails.getMappingType()%>
            </td>
            <td><%=eventFormatterDetails.getOutEventAdaptorName()%>
            </td>
            <td><%=eventFormatterDetails.getInputStreamId()%>
            </td>
            <td class="fnc-btn">
            
            <% if (eventFormatterDetails.getEnableStats()) {%>
                    <div id="disableStat<%= eventFormatterDetails.getEventFormatterName()%>">
                        <a href="#"
                           onclick="disableFormatterStat('<%= eventFormatterDetails.getEventFormatterName() %>')"
                           class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
                    </div>
                    <div id="enableStat<%= eventFormatterDetails.getEventFormatterName()%>"
                         style="display:none;">
                        <a href="#"
                           onclick="enableFormatterStat('<%= eventFormatterDetails.getEventFormatterName() %>')"
                           class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
                    </div>
                <% } else { %>
                    <div id="enableStat<%= eventFormatterDetails.getEventFormatterName()%>">
                        <a href="#"
                           onclick="enableFormatterStat('<%= eventFormatterDetails.getEventFormatterName() %>')"
                           class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
                    </div>
                    <div id="disableStat<%= eventFormatterDetails.getEventFormatterName()%>"
                         style="display:none">
                        <a href="#"
                           onclick="disableFormatterStat('<%= eventFormatterDetails.getEventFormatterName() %>')"
                           class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
                    </div>
                <% }
                    if (eventFormatterDetails.getEnableTracing()) {%>
                    <div id="disableTracing<%= eventFormatterDetails.getEventFormatterName()%>">
                        <a href="#"
                           onclick="disableFormatterTracing('<%= eventFormatterDetails.getEventFormatterName() %>')"
                           class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
                    </div>
                    <div id="enableTracing<%= eventFormatterDetails.getEventFormatterName()%>"
                         style="display:none;">
                        <a href="#"
                           onclick="enableFormatterTracing('<%= eventFormatterDetails.getEventFormatterName() %>')"
                           class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
                    </div>
                <% } else { %>
                    <div id="enableTracing<%= eventFormatterDetails.getEventFormatterName()%>">
                        <a href="#"
                           onclick="enableFormatterTracing('<%= eventFormatterDetails.getEventFormatterName() %>')"
                           class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
                    </div>
                    <div id="disableTracing<%= eventFormatterDetails.getEventFormatterName()%>"
                         style="display:none">
                        <a href="#"
                           onclick="disableFormatterTracing('<%= eventFormatterDetails.getEventFormatterName() %>')"
                           class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
                    </div>
                <% } %>
                    
            	<a class="delete" onclick="deleteEventFormatter('<%=eventFormatterDetails.getEventFormatterName()%>')">
            	<i class="fa fa-trash"></i>삭제</a>                
                <a class="edit" href="../hrta_eventformatter/hrta_edit_event_formatter_details.jsp?ordinal=1&eventFormatterName=<%=eventFormatterDetails.getEventFormatterName()%>">
						<i class="fa fa-pencil-square-o"></i>수정</a>						
            </td>
        </tr>
        </tbody>
        <%
            }

        } else {
        %>

        <tbody>
        <tr>
        	<td>	    
				<div class="act">
					사용 가능 포멧터가 없습니다.
				</div>
			</td>		
         </tr>
        <tr>
        </tbody>

        <%
        }
        %>
    </table>
        <form id="deleteForm" name="input" action="" method="post">
        	<input type="HIDDEN" name="eventFormatter" value=""/></form>
</div>