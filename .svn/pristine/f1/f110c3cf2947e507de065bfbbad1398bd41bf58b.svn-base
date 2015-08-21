<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.OutputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.types.OutputEventAdaptorPropertiesDto" %>
<%@ page import="com.toogram.cep.ui.ToogramOutputEventAdaptorUIUtils" %>

<%
    // get Event Adaptor properties
    OutputEventAdaptorManagerAdminServiceStub stub = ToogramOutputEventAdaptorUIUtils.getOutputEventManagerAdminService(config, session, request, response);
    String eventType = request.getParameter("eventType");

%>

<%

    if (eventType != null) {

        OutputEventAdaptorPropertiesDto eventAdaptorPropertiesDto = stub.getOutputEventAdaptorProperties(eventType);
        String propertiesString = "";
        propertiesString = new Gson().toJson(eventAdaptorPropertiesDto);


%>


<%=propertiesString%>
<%
    }

%>
