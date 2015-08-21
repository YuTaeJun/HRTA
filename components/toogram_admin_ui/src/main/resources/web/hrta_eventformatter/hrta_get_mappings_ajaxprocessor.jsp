<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.OutputEventAdaptorManagerAdminServiceStub" %>
<%
    OutputEventAdaptorManagerAdminServiceStub stub = ToogramEventFormatterUIUtils.getOutputEventManagerAdminService(config, session, request, response);
    String eventAdaptorName = request.getParameter("eventAdaptorName");
%>
<%
    if (eventAdaptorName != null) {
        String supportedMappings = "";
        String[] mappingTypes = stub.getSupportedMappingTypes(eventAdaptorName);
        for (String mappingType : mappingTypes) {
            supportedMappings = supportedMappings + "|=" + mappingType;
        }
%>
<%=supportedMappings%>
<%
    }
%>
