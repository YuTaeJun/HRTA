<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventProcessorUIUtils" %>

<%@ page import="org.wso2.carbon.event.processor.stub.EventProcessorAdminServiceStub" %>

<%

    EventProcessorAdminServiceStub eventProcessorAdminServiceStub = ToogramEventProcessorUIUtils.getEventProcessorAdminService(config, session, request, response);
    String strInputStreamDefinitions = request.getParameter("siddhiStreamDefinitions");
    String strQueryExpressions = request.getParameter("queries");

      String resultString = "";
    if (strInputStreamDefinitions != null) {
        String[] definitions = strInputStreamDefinitions.split(";");

        try {
            boolean result = eventProcessorAdminServiceStub.validateSiddhiQueries(definitions, strQueryExpressions);
            if (result) {
                resultString = "success";
            } else {
                // should be handled by the exception.
            }
        } catch (Exception e) {
            resultString = e.getMessage();
        }


%>
<%=resultString%>
<%
    }

%>
