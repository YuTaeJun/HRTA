<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.wso2.carbon.event.processor.stub.EventProcessorAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.processor.stub.types.ExecutionPlanConfigurationDto" %>
<%@ page import="org.wso2.carbon.event.processor.stub.types.ExecutionPlanConfigurationFileDto" %>
<%@ page import="com.toogram.cep.ui.ToogramEventProcessorUIUtils" %>


<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>
<script type="text/javascript" src="../hrta_eventprocessor/js/execution_plans.js"></script>


<%
    String eventStreamWithVersion = request.getParameter("eventStreamWithVersion");
    String loadingCondition = request.getParameter("loadingCondition");

%>

<%
    EventProcessorAdminServiceStub stub = ToogramEventProcessorUIUtils.getEventProcessorAdminService(config, session, request, response);
    String executionPlanName = request.getParameter("executionPlan");
    int totalActiveExecutionPlanConfigurations = 0;

    ExecutionPlanConfigurationFileDto[] inactiveExecutionPlanConigurations = stub.getAllInactiveExecutionPlanConigurations();
    int totalInactiveExecutionPlans = 0;
    if (inactiveExecutionPlanConigurations != null) {
        totalInactiveExecutionPlans = inactiveExecutionPlanConigurations.length;
    }

    if (executionPlanName != null) {
        stub.undeployActiveExecutionPlanConfiguration(executionPlanName);
%>
<script type="text/javascript">CARBON.showInfoDialog('쿼리 실행 계획이 성공적으로 삭제되었습니다.');</script>
<%
    }

    ExecutionPlanConfigurationDto[] executionPlanConfigurationDtos = null;
    if(loadingCondition == null) {
        executionPlanConfigurationDtos = stub.getAllActiveExecutionPlanConfigurations();

    }else if(loadingCondition.equals("exportedStreams")){
        executionPlanConfigurationDtos = stub.getAllExportedStreamSpecificActiveExecutionPlanConfiguration(eventStreamWithVersion);
    }else if(loadingCondition.equals("importedStreams")){
        executionPlanConfigurationDtos = stub.getAllImportedStreamSpecificActiveExecutionPlanConfiguration(eventStreamWithVersion);
    }

    if (executionPlanConfigurationDtos != null) {
        totalActiveExecutionPlanConfigurations = executionPlanConfigurationDtos.length;
    }

%>

<div>
<br/>
<div id="act">
<%=totalActiveExecutionPlanConfigurations%> 활성화된 쿼리 실행 계획.
<% if (totalInactiveExecutionPlans > 0) { %><a
        href="../hrta_eventprocessor/hrta_inactive_execution_plan_files_details.jsp?ordinal=1"><%=totalInactiveExecutionPlans%>
    비 활셩화된 쿼리 실행 계획</a><% } else {%><%="0"%>
비 활셩화된 쿼리 실행 계획 <% } %>
<br/><br/>
<table class="styledVertical">
    <%

        if (executionPlanConfigurationDtos != null) {
    %>
    <thead>
    <tr>
        <th>쿼리 실행 계획명</th>
        <th>실행 계획 설명</th>
        <th>수정</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (ExecutionPlanConfigurationDto executionPlanConfigurationDto : executionPlanConfigurationDtos) {
    %>
    <tr>
        <td>
            <a href="../hrta_eventprocessor/hrta_execution_plan_details.jsp?ordinal=1&execPlan=<%=executionPlanConfigurationDto.getName()%>">
                <%=executionPlanConfigurationDto.getName()%>
            </a>
        </td>
        <td><%=executionPlanConfigurationDto.getDescription()%>
        </td>
        
        <td class="fnc-btn">
        
        <% if (executionPlanConfigurationDto.getStatisticsEnabled()) {%>
            <div id="disableStat<%= executionPlanConfigurationDto.getName()%>">
                <a href="#"
                   onclick="disableStat('<%= executionPlanConfigurationDto.getName() %>')"
                   class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
            </div>
            <div id="enableStat<%= executionPlanConfigurationDto.getName()%>"
                 style="display:none;">
                <a href="#"
                   onclick="enableStat('<%= executionPlanConfigurationDto.getName() %>')"
                   class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
            </div>
            <% } else { %>
            <div id="enableStat<%= executionPlanConfigurationDto.getName()%>">
                <a href="#"
                   onclick="enableStat('<%= executionPlanConfigurationDto.getName() %>')"
                   class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
            </div>
            <div id="disableStat<%= executionPlanConfigurationDto.getName()%>"
                 style="display:none">
                <a href="#"
                   onclick="disableStat('<%= executionPlanConfigurationDto.getName() %>')"
                   class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
            </div>
            <% }
            if (executionPlanConfigurationDto.getTracingEnabled()) {%>
            <div id="disableTracing<%= executionPlanConfigurationDto.getName()%>">
                <a href="#"
                   onclick="disableTracing('<%= executionPlanConfigurationDto.getName() %>')"
                   class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
            </div>
            <div id="enableTracing<%= executionPlanConfigurationDto.getName()%>"
                 style="display:none;">
                <a href="#"
                   onclick="enableTracing('<%= executionPlanConfigurationDto.getName() %>')"
                   class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
            </div>
            <% } else { %>
            <div id="enableTracing<%= executionPlanConfigurationDto.getName() %>">
                <a href="#"
                   onclick="enableTracing('<%= executionPlanConfigurationDto.getName() %>')"
                   class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
            </div>
            <div id="disableTracing<%= executionPlanConfigurationDto.getName() %>"
                 style="display:none">
                <a href="#"
                   onclick="disableTracing('<%= executionPlanConfigurationDto.getName() %>')"
                   class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
            </div>

            <% } %>   
        
          	<a class="delete" onclick="doDelete('<%=executionPlanConfigurationDto.getName()%>')">
          	<i class="fa fa-trash"></i>삭제</a>                
              <a class="edit" href="../hrta_eventprocessor/hrta_edit_execution_plan.jsp?ordinal=1&execPlanName=<%=executionPlanConfigurationDto.getName()%>">
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
					사용 가능 쿼리 실행 계획이 없습니다.
				</div>
			</td>		
         </tr>
        <tr>
        </tbody>

    <% } %>

</table>
    <form id="deleteForm" name="input" action="" method="post">
    <input type="HIDDEN" name="executionPlan" value=""/></form>

</div>
</div>
