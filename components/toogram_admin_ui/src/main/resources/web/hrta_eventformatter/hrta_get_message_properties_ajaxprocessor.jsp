<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>

<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.EventFormatterPropertyDto" %>

<%
    // get Event Adaptor properties
    EventFormatterAdminServiceStub stub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);
    String eventAdaptorName = request.getParameter("eventAdaptorName");

    if (eventAdaptorName != null) {
        EventFormatterPropertyDto[] eventFormatterPropertiesDto = stub.getEventFormatterMessageProperties(eventAdaptorName);
        String propertiesString = "";
        propertiesString = new Gson().toJson(eventFormatterPropertiesDto);


%>


<%=propertiesString%>
<%
    }

%>
