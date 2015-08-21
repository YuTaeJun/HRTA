<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventProcessorUIUtils" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>

<%
    EventStreamAdminServiceStub streamAdminServiceStub = ToogramEventProcessorUIUtils.getEventStreamAdminService(config, session, request, response);
    String strStreamId = request.getParameter("streamId");
    String strStreamAs = request.getParameter("streamAs");


    if (strStreamId != null) {
        String definition = streamAdminServiceStub.getStreamDefinitionAsString(strStreamId);

        StringBuilder formattedDefinition = new StringBuilder("");
        StringBuilder unformattedDefinition = new StringBuilder("");
        String[] attributes = definition.trim().split(",");
        boolean appendComma = false;
        for (String attribute : attributes) {
            attribute = attribute.trim();
            if (attribute.length() > 0) {

                String[] nameType = attribute.split(" ");
                if (appendComma) {
                    formattedDefinition.append(", ");
                    unformattedDefinition.append(", ");
                }
                formattedDefinition.append("<b>");
                formattedDefinition.append(nameType[0].trim());
                formattedDefinition.append("</b>");
                formattedDefinition.append(" ");
                formattedDefinition.append(nameType[1].trim());

                unformattedDefinition.append(attribute);
                appendComma = true;
            }
        }

        String streamDefinitionString = strStreamId + " |= " + strStreamAs + " |= " + formattedDefinition + " |= " + unformattedDefinition;

%>

<%=streamDefinitionString%>
<%
    }

%>
