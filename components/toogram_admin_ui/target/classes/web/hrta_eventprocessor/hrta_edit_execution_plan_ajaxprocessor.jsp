<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventProcessorUIUtils" %>

<%@ page import="org.wso2.carbon.event.processor.stub.EventProcessorAdminServiceStub" %>
<%
    EventProcessorAdminServiceStub stub = ToogramEventProcessorUIUtils.getEventProcessorAdminService(config, session, request, response);
    String executionPlanName = request.getParameter("execPlanName");
    String executionPlanPath = request.getParameter("execPlanPath");
    String executionPlanConfiguration = request.getParameter("execPlanConfig");
    String msg = null;
    if (executionPlanName != null) {
        try {
            stub.editActiveExecutionPlanConfiguration(executionPlanConfiguration, executionPlanName);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();

        }
    } else if (executionPlanPath != null) {
        try {
            // assuming file to be not yet deployed.
            stub.editInactiveExecutionPlanConfiguration(executionPlanConfiguration, executionPlanPath);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();

        }
    }

%><%=msg%><%
%>
