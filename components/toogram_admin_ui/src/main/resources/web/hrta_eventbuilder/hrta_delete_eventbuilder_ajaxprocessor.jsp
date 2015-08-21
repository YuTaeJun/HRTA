<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>
<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>

<%
    // get required parameters to delete an event builder from back end.
    EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
    String eventBuilderName = request.getParameter("eventBuilderName");
    String msg = null;
    if (stub != null) {
        try {
            stub.undeployActiveEventBuilderConfiguration(eventBuilderName);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();
        }
    }
%>  <%=msg%>   <%

%>
