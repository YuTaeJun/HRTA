<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventProcessorUIUtils" %>

<%@ page import="org.wso2.carbon.event.processor.stub.EventProcessorAdminServiceStub" %>

<%
    String executionPlanName = request.getParameter("execPlanName");
    String action = request.getParameter("action");

    if (executionPlanName != null && action != null) {
        EventProcessorAdminServiceStub stub = ToogramEventProcessorUIUtils.getEventProcessorAdminService(config, session, request, response);
        if ("enableStat".equals(action)) {
            stub.setStatisticsEnabled(executionPlanName, true);
        } else if ("disableStat".equals(action)) {
            stub.setStatisticsEnabled(executionPlanName, false);
        } else if ("enableTracing".equals(action)) {
            stub.setTracingEnabled(executionPlanName, true);
        } else if ("disableTracing".equals(action)) {
            stub.setTracingEnabled(executionPlanName, false);
        }
    }

%>