<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>
<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminService" %>
<%


    String msg = null;
    try {
        EventBuilderAdminService stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);

        String streamNameWithVersion = request.getParameter("eventStreamId");
        stub.deployDefaultEventReceiver(streamNameWithVersion);
        msg = "true";


    } catch (Exception e) {
        msg = e.getMessage();
    }

%>
<%=msg%>
