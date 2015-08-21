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
    		<tr>
	    		<th colspan="2">
	                XML 이벤트 매핑
	            </th>
    		</tr>
    	</thead>
        <tbody>
        <tr>
            <td colspan="2">
                <h6>XPath 사전 설정</h6>                
                <table class="styledVertical" id="inputXpathPrefixTable"
                       style="display:none">
                    <thead>
	                    <th>이벤트 빌더 xpath prefix</th>
	                    <th>이벤트 빌더 xpath 네임스페이스</th>
	                    <th>수정</th>
                    </thead>
                    <tbody id="inputXpathPrefixTBody"></tbody>
                </table>
                <div class="act" id="noInputPrefixes">
                    XPath 정의가 설정되지 않았습니다.
                </div>
                
                <div class="detail-view">                
                <table id="addXpathDefinition" class="detail">
                    <tbody>
                    <tr>
                        <td>xpath prefix<td>
                            <input type="text" id="inputPrefixName"/>
                        </td>
                        <td>xpath namespace :</td>
                        <td>
                            <input type="text" id="inputXpathNs"/>
                        </td>
                        <td><input type="button" class="btn"
                                   value="추가"
                                   onclick="addInputXpathDef()"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
                </div>
            </td>
        </tr>


        <tr>
            <td colspan="2">
            	<div class="detail-view">                
                <table class="detail">
                    <tbody>
                    <tr>
                        <td> xpath 이벤트 빌더 parent 선택:</td>
                        <td><input type="text" id="parentSelectorXpath"></td>
                    </tr>
                    </tbody>
                </table>
                </div>
        </tr>

        <tr>
            <td colspan="2">
				
                <h6>xpath 프로퍼티</h6>

                    <%--<div class="noDataDiv-plain" id="noInputProperties">--%>
                    <%--No XPath expressions properties Defined--%>
                    <%--</div>--%>
                <div class="detail-view">
                <table id="addXpathExprTable" class="detail">
                    <tbody>
                    <%
                        int counter = 0;
                        for (String attributeData : attributeList) {
                            String attributeValues[] = attributeData.split(" ");
                    %>
                    <tr>
                        <td>xpath:</td>
                        <td>
                            <input type="text" id="inputPropertyValue_<%=counter%>"/>
                        </td>
                        <td>대상:
                        </td>
                        <td>
                            <input type="text" id="inputPropertyName_<%=counter%>"
                                   value="<%=attributeValues[0]%>" readonly="true"/>
                        </td>
                        <td>타입:</td>
                        <td>
                            <input type="text" id="inputPropertyType_<%=counter%>"
                                   value="<%=attributeValues[1]%>" readonly="true"/>
                        </td>
                        <td>기본값:
                        </td>
                        <td><input type="text" id="inputPropertyDefault_<%=counter%>"/></td>
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