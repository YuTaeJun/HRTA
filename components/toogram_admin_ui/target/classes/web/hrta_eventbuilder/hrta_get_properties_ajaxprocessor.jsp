<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>
<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderMessagePropertyDto" %>

<%
    // get Event Builder properties
    EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
    String eventName = request.getParameter("eventName");
    if (eventName != null) {

        EventBuilderMessagePropertyDto[] eventBuilderProperties = stub.getEventBuilderMessageProperties(eventName);
        String propertiesString;
        propertiesString = new Gson().toJson(eventBuilderProperties);
%>
<%=propertiesString%>
<%
    }
%>
