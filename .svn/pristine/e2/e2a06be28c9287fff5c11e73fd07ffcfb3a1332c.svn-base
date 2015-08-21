<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.types.EventStreamInfoDto" %>
<%@ page import="com.toogram.cep.ui.ToogramEventStreamUIUtils" %>

<%
    // get Event Stream Definition
    EventStreamAdminServiceStub stub = ToogramEventStreamUIUtils.getEventStreamAdminService(config, session, request ,response);
    EventStreamInfoDto[] streamDefinitions = stub.getAllEventStreamInfoDto();
    String[] streamDefIds = null;
    String responseText = "";
    if (streamDefinitions != null && streamDefinitions.length > 0) {
        streamDefIds = new String[streamDefinitions.length];
        int i = 0;
        for (EventStreamInfoDto streamInfoDto : streamDefinitions) {
            streamDefIds[i++] = streamInfoDto.getStreamName() + ":" + streamInfoDto.getStreamVersion();
        }
        responseText = new Gson().toJson(streamDefIds);
    }
%>
<%=responseText%>
