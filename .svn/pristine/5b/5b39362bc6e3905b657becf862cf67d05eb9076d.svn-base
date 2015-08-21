<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>

<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.EventFormatterConfigurationInfoDto" %>
<%@ page import="org.wso2.carbon.event.formatter.ui.EventFormatterUIUtils" %>

<%
    // get Event Stream Definition
    EventFormatterAdminServiceStub stub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);
    EventFormatterConfigurationInfoDto[] eventFormatters = stub.getAllActiveEventFormatterConfiguration();
    String[] eventFormatterNames = null;
    String responseText = "";
    if (eventFormatters != null && eventFormatters.length > 0) {
        eventFormatterNames = new String[eventFormatters.length];
        int i = 0;
        for (EventFormatterConfigurationInfoDto eventFormatter : eventFormatters) {
            eventFormatterNames[i++] = eventFormatter.getEventFormatterName();
        }
        responseText = new Gson().toJson(eventFormatterNames);
    }
%>
<%=responseText%>
