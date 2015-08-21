<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>

<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderConfigurationDto" %>
<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderMessagePropertyDto" %>
<%@ page import="org.wso2.carbon.event.builder.stub.types.EventInputPropertyConfigurationDto" %>

<link type="text/css" href="../hrta_eventbuilder/css/cep.css" rel="stylesheet"/>

<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>
<script type="text/javascript" src="../hrta_eventbuilder/js/subscriptions.js"></script>
<script type="text/javascript" src="../hrta_eventbuilder/js/eventing_utils.js"></script>
<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>
<script type="text/javascript" src="../hrta_eventbuilder/js/event_builders.js"></script>



<div id="cols">
<h2>이벤트 빌더 상세내역</h2>

<div class="act">
<%
    String eventBuilderName = request.getParameter("eventBuilderName");
    EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
    if (eventBuilderName != null) {
        EventBuilderConfigurationDto eventBuilderConfigurationDto = stub.getActiveEventBuilderConfiguration(eventBuilderName);
        if (eventBuilderConfigurationDto != null) {
            String eventAdaptorName = eventBuilderConfigurationDto.getInputEventAdaptorName();
%>
<form name="inputForm" action="../hrta_eventbuilder/hrta_eventbuilder.jsp?ordinal=1" method="post" id="addEventBuilder">
<table id="ebAdd" class="styledVertical">
<thead>
<tr>
    <th>이벤트 빌더 상세 내역</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<div class="detail-view">
<table id="eventBuilderInputTable" class="detail">
	<colgroup>	
		<col style="width: 20%;">
		<col>
	</colgroup>

<tbody>
<tr>
    <th>이벤트 빌더 명<span class="required">*</span></th>
    <td><input type="text" name="configName" id="eventBuilderNameId"
               value="<%=eventBuilderConfigurationDto.getEventBuilderConfigName()%>"
               disabled/>

        <p><small>이벤트 빌더 명을 입력하세요</small></p>

    </td>
</tr>
<tr>
    <td colspan="2"><b>이벤트 유입쳐</b></td>
</tr>
<tr>
    <th>인풋 이벤트 어답터<span class="required">*</span></th>
    <td><select name="eventAdaptorNameSelect"
                id="eventAdaptorNameSelect" disabled>
        <option><%=eventAdaptorName%>
        </option>
    </select>

        <p><small>이벤트가 유입되는 이벤트 인풋 어답터 선택</small></p>
    </td>

</tr>
<tr>

    <% //Input fields for message configuration properties
        if (eventAdaptorName != null && !eventAdaptorName.isEmpty()) {
            EventBuilderMessagePropertyDto[] eventBuilderMessageProperties = eventBuilderConfigurationDto.getEventBuilderMessageProperties();

            if (eventBuilderMessageProperties != null) {
                for (int index = 0; index < eventBuilderMessageProperties.length; index++) {
                    EventBuilderMessagePropertyDto msgConfigProperty = eventBuilderMessageProperties[index];
    %>

    <th>
        <%=msgConfigProperty.getDisplayName()%>
        <%
            String propertyId = "msgConfigProperty_";
            if (msgConfigProperty.getRequired()) {
                propertyId = "msgConfigProperty_Required_";

        %>
        <span class="required">*</span>
        <%
            }
        %>

    </th>
    <%
        String type = "text";
        if (msgConfigProperty.getSecured()) {
            type = "password";
        }
    %>
    <td><input type="<%=type%>"
               name="<%=msgConfigProperty.getKey()%>"
               id="<%=propertyId%><%=index%>"
               value="<%=msgConfigProperty.getValue() %>"
               disabled/>
        <%
            if (msgConfigProperty.getHint() != null) {
        %>
        <p><small><%=msgConfigProperty.getHint()%></small></p>
        <%
            }
        %>
    </td>

</tr>
<%
            }
        }
    }

%>
<tr>
    <td colspan="2"><b>매핑 설정</b>
    </td>
</tr>
<tr>
    <th>인풋 매핑 Type<span class="required">*</span></th>
    <td><select name="inputMappingTypeSelect" id="inputMappingTypeSelect"
                disabled>
        <%
            String mappingType = eventBuilderConfigurationDto.getInputMappingType();
            if (mappingType != null) {
        %>
        <option><%=mappingType%>
        </option>
        <%
            }
        %>
    </select>

        <p><small>인풋 매핑 타입을 선택하시오</small></p>
    </td>
</tr>
<%
    boolean customMappingEnabled = eventBuilderConfigurationDto.getCustomMappingEnabled();
%>
<tr>
<td colspan="2">
<div class="detail-view">
<table class="detail">
<tbody>
<tr>
    <td>커스텀 매핑</td>
    <td>
        <% if (customMappingEnabled) { %>
        <input name="customMapping" type="radio" value="enable"
               onclick="enableMapping(true);" checked disabled>Enable</input>
        <input name="customMapping" type="radio" value="disable" onclick="enableMapping(false);"
               disabled>Disable</input>
        <% } else { %>
        <input name="customMapping" type="radio" value="enable"
               onclick="enableMapping(true);" disabled>Enable</input>
        <input name="customMapping" type="radio" value="disable" onclick="enableMapping(false);"
               checked disabled>Disable</input>

        <% } %>
    </td>
</tr>
<%
    if (customMappingEnabled) {
%>

<%
    if (mappingType != null) {
        if (mappingType.equals("wso2event")) {
%>
<tr fromElementKey="inputWso2EventMapping">
    <th colspan="2">
        WSO2매핑
    </th>
</tr>

<tr fromElementKey="inputWso2EventMapping">
    <td colspan="2">

        <h6>사용 가능한 wso2 속성 매핑</h6>
        <table class="styledVertical"
               id="inputWso2EventDataTable">
            <thead>
            <th>속성명</th>
            <th>인풋 타입</th>
            <th>속성값</th>
            <th>유형</th>
            </thead>
            <tbody>
            <%
                for (EventInputPropertyConfigurationDto metaEbProperties : eventBuilderConfigurationDto.getMetaEventBuilderProperties()) {
            %>
            <tr id="mappingRow">
                <td><%=metaEbProperties.getName()%>
                </td>
                <td">
                    <%="meta"%>
                </td>
                <td"><%=metaEbProperties.getValueOf()%>
                </td>
                <td"><%=metaEbProperties.getType()%>
                </td>
            </tr>
            <%
                }
            %>
            <%
                for (EventInputPropertyConfigurationDto correlationEbProperties : eventBuilderConfigurationDto.getCorrelationEventBuilderProperties()) {
            %>
            <tr id="mappingRow">
                <td><%=correlationEbProperties.getName()%>
                </td>
                <td>
                    <%="correlation"%>
                </td>
                <td><%=correlationEbProperties.getValueOf()%>
                </td>
                <td><%=correlationEbProperties.getType()%>
                </td>
            </tr>
            <%
                }
            %>
            <%
                for (EventInputPropertyConfigurationDto payloadEbProperties : eventBuilderConfigurationDto.getPayloadEventBuilderProperties()) {
            %>
            <tr id="mappingRow">
                <td><%=payloadEbProperties.getName()%>
                </td>
                <td>
                    <%="payload"%>
                </td>
                <td><%=payloadEbProperties.getValueOf()%>
                </td>
                <td><%=payloadEbProperties.getType()%>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </td>
</tr>
<%
} else if (mappingType.equals("xml")) {
%>
<tr fromElementKey="inputXmlMapping">
    <th colspan="2">
        XML 매핑
    </th>
</tr>
<tr fromElementKey="inputXmlMapping">
    <td colspan="2">

        <h6>사용 가능한 XML 속성 매핑</h6>
        <table class="styledVertical" id="inputXpathPrefixTable">
            <thead>
	            <th>이벤트 빌더 xpath prefix</th>
	            <th>이벤트 빌더 xpath 네임스페이스</th>
            </thead>
            <tbody id="inputXpathPrefixTBody">
            <%
                for (EventInputPropertyConfigurationDto xpathDefinition : eventBuilderConfigurationDto.getXpathDefinitions()) {
            %>
            <tr>
                <td><%=xpathDefinition.getName()%>
                </td>
                <td><%=xpathDefinition.getValueOf()%>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </td>
</tr>

<tr fromElementKey="inputXmlMapping">
    <td colspan="2">

        <h6>XPath Expression</h6>
        <table class="styledVertical"
               id="inputXpathExprTable">
            <thead>
            <th>대상</th>
            <th>프로퍼티</th>
            <th>Type</th>
            <th>기본값</th>
            </thead>
            <tbody id="inputXpathExprTBody">
            <%
                String parentSelectorXpathProperty = eventBuilderConfigurationDto.getParentSelectorXpath();
                for (EventInputPropertyConfigurationDto xpathExpressions : eventBuilderConfigurationDto.getPayloadEventBuilderProperties()) {
            %>
            <tr>
                <td><%=xpathExpressions.getValueOf()%>
                </td>
                <td><%=xpathExpressions.getName()%>
                </td>
                <td><%=xpathExpressions.getType()%>
                </td>
                <td><%=xpathExpressions.getDefaultValue() != null ? xpathExpressions.getDefaultValue() : ""%>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </td>
</tr>
<tr>
    <td colspan="2">
        <table>
            <tbody>
            <tr>
                <td> xpath 이벤트 빌더 parent 선택:</td>
                <td><input type="text" id="batchProcessingEnabled"
                           value="<%=parentSelectorXpathProperty%>"
                           disabled/>
                </td>
            </tr>
            </tbody>
        </table>
</tr>
<%
} else if (mappingType.equals("map")) {
%>
<tr fromElementKey="inputMapMapping">
    <td colspan="2">
        MAP 매핑
    </td>
</tr>
<tr fromElementKey="inputMapMapping">
    <td colspan="2">

        <h6>사용가능한 Map 속성 매핑</h6>
        <table class="styledVertical"
               id="inputMapDataTable">
            <thead>
            <th>아룸</th>
            <th>대상</th>
            <th>유형</th>
            <th>기본값</th>
            </thead>
            <tbody>
            <%
                for (EventInputPropertyConfigurationDto getMappingProperties : eventBuilderConfigurationDto.getPayloadEventBuilderProperties()) {
            %>
            <tr>
                <td><%=getMappingProperties.getName()%>
                </td>
                <td><%=getMappingProperties.getValueOf()%>
                </td>
                <td><%=getMappingProperties.getType()%>
                </td>
                <td><%=getMappingProperties.getDefaultValue() != null ? getMappingProperties.getDefaultValue() : ""%>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </td>
</tr>
<%

} else if (mappingType.equals("text")) {
%>
<tr fromElementKey="inputTextMapping">
    <td colspan="2">
        TEXT 매핑
    </td>
</tr>
<tr fromElementKey="inputTextMapping">
    <td colspan="2">

        <h6>사용가능한 TEXT 속성 매핑</h6>
        <table class="styledVertical"
               id="inputTextMappingTable">
            <thead>
            <th>Regular Expression</th>
            <th>대상</th>
            <th>유형</th>
            <th>기본값</th>
            </thead>
            <tbody id="inputTextMappingTBody">
            <%
                for (EventInputPropertyConfigurationDto eventBuilderMessagePropertyDto : eventBuilderConfigurationDto.getPayloadEventBuilderProperties()) {
            %>
            <tr>
                <td><%=eventBuilderMessagePropertyDto.getValueOf()%>
                </td>
                <td><%=eventBuilderMessagePropertyDto.getName()%>
                </td>
                <td><%=eventBuilderMessagePropertyDto.getType()%>
                </td>
                <td><%=eventBuilderMessagePropertyDto.getDefaultValue() != null ? eventBuilderMessagePropertyDto.getDefaultValue() : ""%>
                </td>
            </tr>
            <%
                }
            %>

            </tbody>
        </table>
    </td>
</tr>
<%
} else if (mappingType.equals("json")) {
%>
<tr fromElementKey="inputJsonMapping">
    <td colspan="2" class="middle-header">
        JSON 매핑
    </td>
</tr>
<tr fromElementKey="inputJsonMapping">
    <td colspan="2">

        <h6>사용가능한 JSON 속성 매핑</h6>
        <table class="styledVertical"
               id="inputJsonpathExprTable">
            <thead>
            <th>jsonpath</th>
            <th>대상</th>
            <th>유형</th>
            <th>기본값</th>
            </thead>
            <tbody id="inputJsonpathExprTBody">
            <%
                for (EventInputPropertyConfigurationDto jsonpathExpressions : eventBuilderConfigurationDto.getPayloadEventBuilderProperties()) {
            %>
            <tr>
                <td><%=jsonpathExpressions.getValueOf()%>
                </td>
                <td><%=jsonpathExpressions.getName()%>
                </td>
                <td><%=jsonpathExpressions.getType()%>
                </td>
                <td><%=jsonpathExpressions.getDefaultValue() != null ? jsonpathExpressions.getDefaultValue() : ""%>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </td>
</tr>
<%
            }
        }
    }
%>
</tbody>
</table>
</div>
</td>
</tr>
<tr>
    <td colspan="2"><b>대상</b></td>
</tr>
<tr>
    <td>스트림명<span class="required">*</span></td>
    <td><input type="text" name="toStreamName" id="toStreamName"
               value="<%=eventBuilderConfigurationDto.getToStreamName()%>"
               disabled/>
		<p><small>대상 스트림 명을 입력하세요</small></p>        
    </td>

</tr>
<tr>
    <td>스트림 버전</td>
    <td><input type="text" name="toStreamVersion" id="toStreamVersion"
               value="<%=eventBuilderConfigurationDto.getToStreamVersion()%>"
               disabled/>

        <p><small>대상 스트림 버전을 입력하세요</small></p>
    </td>

</tr>
</tbody>
</table>
</div>
</table>
</form>
<%

} else {
%>
<table id="ebNoAdd" class="styledVertical">
    <thead>
    <tr>
        <th>이벤트 빌더 없음</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>
            <table id="noEventBuilderInputTable">
                <tbody>
                <tr>
                    <td colspan="2">이름
                        '<%=eventBuilderName%>' 에 해당하는 이벤트 빌더가 없습니다.
                    </td>
                </tr>
                </tbody>
            </table>
        </td>
    </tr>
    </tbody>
</table>
<%

        }
    }
%>
</div>
</div>
