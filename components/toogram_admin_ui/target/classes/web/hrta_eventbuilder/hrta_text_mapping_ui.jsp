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
	        <tr fromElementKey="inputTextMapping">
	            <th colspan="2">
	                Text 이벤트 매핑
	            </th>
	        </tr>
    	</thead>
        <tbody>
        <tr fromElementKey="inputTextMapping">
            <td colspan="2">
                <h6>Regular Expression 정의</h6>
                
                <table class="styledVertical" id="inputRegexDefTable"
                       style="display:none">
                    <thead>
                    <th>Regular Expression</th>
                    <th>수정</th>
                    </thead>
                    <tbody id="inputRegexDefTBody"></tbody>
                </table>
                <div class="act" id="noInputRegex">
                	정의된 regular expression이 없습니다.
                </div>
                
                <div class="detail-view">
                <table id="addRegexDefinition" class="detail">
                    <tbody>
                    <tr>
                        <td>Regular Expression : <span
                                class="required">*</span>
                        </td>
                        <td>
                            <input type="text" id="inputRegexDef"/>
                        </td>
                        <td><input type="button" class="btn"
                                   value="추가"
                                   onclick="addInputRegexDef()"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
                </div>
            </td>
        </tr>

        <tr fromElementKey="inputTextMapping">
            <td colspan="2">

                <h6>가능한 텍스트 매핑</h6>
                <table class="styledVertical"
                       id="inputTextMappingTable" style="display:none">
                    <thead>
                    <th>regex</th>
                    <th>valueof</th>
                    <th>type</th>
                    <th>default</th>
                    <th>actions</th>
                    </thead>
                    <tbody id="inputTextMappingTBody"></tbody>
                </table>
                <div class="act" id="noInputProperties">
                    No Text Mappings Available
                </div>
                
                <div class="detail-view">
                <table id="addTextMappingTable" class="detail">
                    <tbody>
                    <tr>
                        <td>regex :
                            <select id="inputPropertyValue">
                                <option value="">정의된 regular expression이 없습니다.</option>
                            </select>
                        </td>
                        <td>valueof :
                        </td>
                        <td>
                            <select id="inputPropertyName">
                                <% for (String attributeData : attributeList) {
                                    String[] attributeValues = attributeData.split(" ");
                                %>
                                <option value="<%=attributeValues[0]%>"><%=attributeValues[0]%>
                                </option>
                                <% }%>
                            </select>

                        </td>
                        <td>type :
                            <select id="inputPropertyType">
                                <option value="int">int</option>
                                <option value="long">long</option>
                                <option value="double">double</option>
                                <option value="float">float</option>
                                <option value="string">string</option>
                                <option value="boolean">boolean</option>
                            </select>
                        </td>
                        <td>default</td>
                        <td><input type="text" id="inputPropertyDefault"/></td>
                        <td><input type="button" class="btn"
                                   value="추가"
                                   onclick="addInputTextProperty()"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
                </div>
            </td>
        </tr>
        </tbody>
    </table>