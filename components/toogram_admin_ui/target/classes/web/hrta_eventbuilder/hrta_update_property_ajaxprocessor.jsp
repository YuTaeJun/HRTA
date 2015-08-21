<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>

<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>
<%
    String eventBuilderName = request.getParameter("eventBuilderName");
    String attribute = request.getParameter("attribute");
    String value = request.getParameter("value");

    if (eventBuilderName != null && attribute != null && value != null) {
        EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
        if ("stat".equals(attribute)) {
            if ("true".equalsIgnoreCase(value)) {
                stub.setStatisticsEnabled(eventBuilderName, true);
            } else {
                stub.setStatisticsEnabled(eventBuilderName, false);
            }
        } else if ("trace".equals(attribute)) {
            if ("true".equalsIgnoreCase(value)) {
                stub.setTraceEnabled(eventBuilderName, true);
            } else {
                stub.setTraceEnabled(eventBuilderName, false);
            }
        }
    }

%>