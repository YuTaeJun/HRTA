<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventProcessorUIUtils" %>

<%@ page import="org.wso2.carbon.event.processor.stub.EventProcessorAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.processor.stub.types.StreamDefinitionDto" %>
<%@ page import="java.util.Arrays" %>

<%

    EventProcessorAdminServiceStub eventProcessorAdminServiceStub = ToogramEventProcessorUIUtils.getEventProcessorAdminService(config, session, request, response);
    String strInputStreamDefinitions = request.getParameter("siddhiStreamDefinitions");
    String strQueryExpressions = request.getParameter("queries");
    String strTargetStream = request.getParameter("targetStream");

    String resultString = "";
    if (strInputStreamDefinitions != null) {
        String[] definitions = strInputStreamDefinitions.split(";");
        try {
            StreamDefinitionDto[] siddhiStreams = eventProcessorAdminServiceStub.getSiddhiStreams(definitions, strQueryExpressions);
            StreamDefinitionDto targetDto = null;
            for (StreamDefinitionDto dto : siddhiStreams) {
                if (strTargetStream.equals(dto.getName())) {
                    targetDto = dto;
                    break;
                }
            }

            resultString = ToogramEventProcessorUIUtils.getJsonStreamDefinition(targetDto);

        } catch (Exception e) {
            e.printStackTrace();
        }


%>
<%=resultString%>
<%
    }

%>
