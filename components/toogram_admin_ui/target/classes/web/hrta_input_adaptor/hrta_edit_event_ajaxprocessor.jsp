<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ pageimport="org.wso2.carbon.event.input.adaptor.manager.stub.InputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="com.toogram.cep.ui.ToogramInputEventAdaptorUIUtils" %>

<%
    // get required parameters to add a event adaptor to back end.
    InputEventAdaptorManagerAdminServiceStub stub = ToogramInputEventAdaptorUIUtils.getInputEventManagerAdminService(config, session, request ,response);
    String eventName = request.getParameter("eventName");
    String eventPath = request.getParameter("eventPath");
    String eventAdaptorConfiguration = request.getParameter("eventConfiguration");
    String msg = null;
    if (eventName != null) {
        try {
            // add event adaptor via admin service
            stub.editActiveInputEventAdaptorConfiguration(eventAdaptorConfiguration, eventName);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();

        }
    } else if (eventPath != null) {
        try {
            // add event adaptor via admin service
            stub.editInactiveInputEventAdaptorConfiguration(eventAdaptorConfiguration, eventPath);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();

        }
    }
%>  <%=msg%>   <%

%>
