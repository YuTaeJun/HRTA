<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.InputEventAdaptorManagerAdminServiceStub" %>
<%
    // get Event Stream Definition
    InputEventAdaptorManagerAdminServiceStub stub = ToogramEventBuilderUIUtils.getInputEventAdaptorManagerAdminService(config, session, request ,response);
    String eventAdaptorName = request.getParameter("eventAdaptorName");

%>

<%

    if (eventAdaptorName != null) {
        String supportedMappings;
        String[] mappingTypes = stub.getSupportedInputMappingTypes(eventAdaptorName);
        supportedMappings = new Gson().toJson(mappingTypes);
%>
<%=supportedMappings%>
<%
    }

%>
