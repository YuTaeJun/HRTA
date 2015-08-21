<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>

<%
    String eventAdaptorName = request.getParameter("eventFormatterName");
    String action = request.getParameter("action");

    if (eventAdaptorName != null && action != null) {
        EventFormatterAdminServiceStub stub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);
        if ("enableStat".equals(action)) {
            stub.setStatisticsEnabled(eventAdaptorName, true);
        } else if ("disableStat".equals(action)) {
            stub.setStatisticsEnabled(eventAdaptorName, false);
        } else if ("enableTracing".equals(action)) {
            stub.setTracingEnabled(eventAdaptorName, true);
        } else if ("disableTracing".equals(action)) {
            stub.setTracingEnabled(eventAdaptorName, false);
        }
    }

%>