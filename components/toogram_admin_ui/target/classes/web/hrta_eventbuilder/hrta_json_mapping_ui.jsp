<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>

<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>
<%@ page import="java.util.List" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.types.EventStreamDefinitionDto" %>

<link type="text/css" href="../hrta_eventbuilder/css/cep.css" rel="stylesheet"/>
<script type="text/javascript" src="../hrta_eventbuilder/js/event_builders.js"></script>

    <%
        String streamId = request.getParameter("streamNameWithVersion");
        EventStreamAdminServiceStub eventStreamAdminServiceStub = ToogramEventBuilderUIUtils.getEventStreamAdminService(config, session, request,response);
        EventStreamDefinitionDto streamDefinitionDto = eventStreamAdminServiceStub.getStreamDefinitionDto(streamId);

        List<String> attributeList = ToogramEventBuilderUIUtils.getAttributeListWithPrefix(streamDefinitionDto);

    %>

    <table class="line-tb">
    	<thead>
        <tr fromElementKey="inputJsonMapping">
            <th colspan="2">
                JSon 이벤트 매핑
            </th>
        </tr>
    	</thead>

        <tbody>
        <tr fromElementKey="inputJsonMapping">
            <td colspan="2">

                <h6>사용가능한 json mapping</h6>

				<div class="detail-view">                
                <table id="addJsonpathExprTable" class="detail">
                    <tbody>
                    <%
                        int counter = 0;
                        for (String attributeData : attributeList) {

                            String[] attributeValues = attributeData.split(" ");
                    %>
                    <tr>
                        <td>jsonpath :
                        </td>
                        <td>
                            <input type="text" id="inputPropertyValue_<%=counter%>"/>
                        </td>
                        <td>mappedto :
                        </td>
                        <td>
                            <input type="text" id="inputPropertyName_<%=counter%>"
                                   value="<%=attributeValues[0]%>" readonly="true"/>
                        </td>
                        <td><input type="text" id="inputPropertyType_<%=counter%>"
                                   value="<%=attributeValues[1]%>" readonly="true"/>
                        </td>
                        <td>default</td>
                        <td><input type="text" id="inputPropertyDefault_<%=counter%>"/></td>
                    </tr>
                    <%
                            counter++;
                        } %>
                    </tbody>
                </table>
                </div>
            </td>
        </tr>

        </tbody>
    </table>