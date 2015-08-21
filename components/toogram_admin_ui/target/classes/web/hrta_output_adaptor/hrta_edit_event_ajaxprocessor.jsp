<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.OutputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="com.toogram.cep.ui.ToogramOutputEventAdaptorUIUtils" %>

<%
    // get required parameters to add a event adaptor to back end.
    OutputEventAdaptorManagerAdminServiceStub stub = ToogramOutputEventAdaptorUIUtils.getOutputEventManagerAdminService(config, session, request, response);
    String eventName = request.getParameter("eventName");
    String eventPath = request.getParameter("eventPath");
    String eventAdaptorConfiguration = request.getParameter("eventConfiguration");
    String msg = null;
    if (eventName != null) {
        try {
            // add event adaptor via admin service
            stub.editActiveOutputEventAdaptorConfiguration(eventAdaptorConfiguration, eventName);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();

        }
    } else if (eventPath != null) {
        try {
            // add event adaptor via admin service
            stub.editInactiveOutputEventAdaptorConfiguration(eventAdaptorConfiguration, eventPath);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();

        }
    }

%>  <%=msg%>   <%

%>

