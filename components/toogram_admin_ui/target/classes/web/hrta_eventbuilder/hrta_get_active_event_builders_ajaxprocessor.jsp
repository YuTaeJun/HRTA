<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>
<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderConfigurationInfoDto" %>

<%
    // get Event Stream Definition
    EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
    EventBuilderConfigurationInfoDto[] eventBuilders = stub.getAllActiveEventBuilderConfigurations();
    String[] eventBuilderNames = null;
    String responseText = "";
    if (eventBuilders != null && eventBuilders.length > 0) {
        eventBuilderNames = new String[eventBuilders.length];
        int i = 0;
        for (EventBuilderConfigurationInfoDto eventBuilder : eventBuilders) {
            eventBuilderNames[i++] = eventBuilder.getEventBuilderName();
        }
        responseText = new Gson().toJson(eventBuilderNames);
    }
%>
<%=responseText%>
