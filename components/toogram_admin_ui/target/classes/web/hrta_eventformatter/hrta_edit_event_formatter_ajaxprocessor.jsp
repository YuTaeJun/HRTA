<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>

<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%
    // get required parameters to add a event formatter to back end.
    EventFormatterAdminServiceStub stub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);
    String eventFormatterName = request.getParameter("eventFormatterName");
    String eventFormatterPath = request.getParameter("eventFormatterPath");
    String eventFormatterConfiguration = request.getParameter("eventFormatterConfiguration");
    String msg = null;
    if (eventFormatterName != null) {
        try {
            // add event formatter via admin service
            stub.editActiveEventFormatterConfiguration(eventFormatterConfiguration, eventFormatterName);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();

        }
    } else if (eventFormatterPath != null) {
        try {
            // add event formatter via admin service
            stub.editInactiveEventFormatterConfiguration(eventFormatterConfiguration, eventFormatterPath);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();

        }
    }
    // Since JSP faithfully replicates all spaces, new lines encountered to HTML,
    // and since msg is output as a response flag, please take care in editing
    // the snippet surrounding print of msg.
%><%=msg%><%%>
