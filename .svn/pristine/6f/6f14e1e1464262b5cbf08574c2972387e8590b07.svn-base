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
	        <tr fromElementKey="inputMapMapping">
	            <th colspan="2">
	                <fmt:message key="event.builder.mapping.map"/>
	                Map 이벤트 매핑
	            </th>
	        </tr>
    	</thead>
   
        <tbody>
        <tr fromElementKey="inputMapMapping">
            <td colspan="2">

                <h6>사용가능한 key/value 매핑</h6>
                <div class="detail-view">
                <table id="addMapDataTable" class="detail">
                    <tbody>
                    <%
                        int counter = 0;
                        for (String attributeData : attributeList) {
                            String[] attributeDataValues = attributeData.split(" ");
                    %>
                    <tr>
                        <td>프로퍼티 명 :
                        </td>
                        <td>
                            <input type="text" id="inputMapPropName_<%=counter%>"/>
                        </td>
                        <td>프로퍼티 값 :
                        </td>
                        <td>
                            <input type="text" id="inputMapPropValueOf_<%=counter%>"
                                   value="<%=attributeDataValues[0]%>" readonly="true"/>
                        </td>
                        <td>타입 :

                            <input type="text" id="inputMapPropType_<%=counter%>"
                                   value="<%=attributeDataValues[1]%>" readonly="true"/>
                        </td>
                    </tr>
                    <% counter++;
                    } %>
                    </tbody>
                </table>
                </div>
            </td>
        </tr>

        </tbody>
    </table>