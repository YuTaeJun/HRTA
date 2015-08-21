<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>

<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>

<%
    // get required parameters to add a event builder to back end.
    EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
    String eventBuilderName = request.getParameter("eventBuilderName");
    String eventBuilderFilename = request.getParameter("eventBuilderFilename");
    String eventBuilderConfigurationXml = request.getParameter("eventBuilderConfiguration");
    String msg;
    if (eventBuilderName != null) {
        try {
            // add event builder via admin service
            stub.editActiveEventBuilderConfiguration(eventBuilderName, eventBuilderConfigurationXml);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();
        }
    } else if (eventBuilderFilename != null) {
        try {
            // add event builder via admin service
            stub.editInactiveEventBuilderConfiguration(eventBuilderFilename, eventBuilderConfigurationXml);
            msg = "true";
        } catch (Exception e) {
            msg = e.getMessage();
        }
    } else {
        msg = "이벤트 빌더의 이름이나, 이벤트 빌더 파일 경로를 전달 받지 못했습니다.";
    }
%>  <%=msg%>   <%
%>
