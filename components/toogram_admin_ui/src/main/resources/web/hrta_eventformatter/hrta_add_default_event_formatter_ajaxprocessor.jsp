<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%


    String msg = null;
    try {
        EventFormatterAdminServiceStub stub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);

        String streamNameWithVersion = request.getParameter("eventStreamId");
        stub.deployDefaultEventSender(streamNameWithVersion);
        msg = "true";


    } catch (Exception e) {
        msg = e.getMessage();
    }

%>
<%=msg%>
