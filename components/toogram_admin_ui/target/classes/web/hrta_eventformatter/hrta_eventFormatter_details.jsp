<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>

<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.EventFormatterConfigurationDto" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.EventFormatterPropertyDto" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.EventOutputPropertyDto" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.ToPropertyConfigurationDto" %>

<link type="text/css" href="css/eventFormatter.css" rel="stylesheet"/>

<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>

<script type="text/javascript" src="../hrta_eventformatter/js/event_formatter.js"></script>
<script type="text/javascript" src="../hrta_eventformatter/js/registry-browser.js"></script>

<script type="text/javascript" src="../ajax/js/prototype.js"></script>


<%
    EventFormatterAdminServiceStub stub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);
%>
<script language="javascript">

    function clearTextIn(obj) {
        if (YAHOO.util.Dom.hasClass(obj, 'initE')) {
            YAHOO.util.Dom.removeClass(obj, 'initE');
            YAHOO.util.Dom.addClass(obj, 'normalE');
            textValue = obj.value;
            obj.value = "";
        }
    }
    function fillTextIn(obj) {
        if (obj.value == "") {
            obj.value = textValue;
            if (YAHOO.util.Dom.hasClass(obj, 'normalE')) {
                YAHOO.util.Dom.removeClass(obj, 'normalE');
                YAHOO.util.Dom.addClass(obj, 'initE');
            }
        }
    }
</script>


<div id="cols">
<h2>이벤트 포멧터 상세내역</h2>

<div class="act">

<form name="inputForm" action="../hrta_eventformatter/hrta_eventformatter.jsp?ordinal=1" method="post">
<table class="styledVertical">
<thead>
<tr>
    <th>이벤트 포멧터 상세내역</th>
</tr>
</thead>
<% String eventFormatterName = request.getParameter("eventFormatterName");
    if (eventFormatterName != null) {
        EventFormatterConfigurationDto eventFormatterConfigurationDto = stub.getActiveEventFormatterConfiguration(eventFormatterName);
%>
<tbody>
<tr>
<td>
<div class="detail-view">
<table id="eventFormatterInputTable" class="detail">
  	<colgroup>	
		<col style="width: 20%;">
		<col>
	</colgroup>
<tbody>
<tr>
    <th"><fmt:message key="event.formatter.name"/><span class="required">*</span>
    </th>
    <td><input type="text" name="eventFormatterName" id="eventFormatterId"
               value="<%= eventFormatterConfigurationDto.getEventFormatterName()%>"
               style="width:75%" disabled="disabled"/>
    </td>
</tr>


<tr>
    <th><fmt:message key="event.stream.name"/><span class="required">*</span></th>
    <td><select name="streamNameFilter" id="streamNameFilter" disabled="disabled">
        <%

        %>
        <option><%=eventFormatterConfigurationDto.getFromStreamNameWithVersion()%>
        </option>


    </select>

    </td>

</tr>
<tr>
    <th>
        <fmt:message key="stream.attributes"/>
    </th>
    <td>
        <textArea class="expandedTextarea" id="streamDefinitionText" name="streamDefinitionText"
                  readonly="true"
                  cols="60"
                  disabled="disabled"><%=eventFormatterConfigurationDto.getStreamDefinition()%>
        </textArea>
    </td>

</tr>

<tr>
    <th><fmt:message key="event.adaptor.name"/><span class="required">*</span></th>
    <td><select name="eventAdaptorNameFilter"
                id="eventAdaptorNameFilter" disabled="disabled">
        <option><%=eventFormatterConfigurationDto.getToPropertyConfigurationDto().getEventAdaptorName()%>
        </option>
    </select>
    </td>
</tr>

<tr>
    <th><fmt:message key="mapping.type"/><span class="required">*</span></th>
    <td><select name="mappingTypeFilter"
                id="mappingTypeFilter" disabled="disabled">
        <option><%=eventFormatterConfigurationDto.getMappingType()%>
        </option>
    </select>
    </td>

</tr>

<tr>
<td colspan="2">
<div id="outerDiv">
<%
    if (eventFormatterConfigurationDto.getMappingType().equalsIgnoreCase("wso2event")) {
%>
<div id="innerDiv1" class="detail-view">
    <table class="detail">
        <tbody>
        <tr name="outputWSO2EventMapping">
            <td colspan="2">
                WSO2 매핑
            </td>
        </tr>
        <tr name="outputWSO2EventMapping">
            <td colspan="2">

                <h6>메타 데이터 매핑</h6>
                <% if (eventFormatterConfigurationDto.getWso2EventOutputMappingDto().getMetaWSO2EventOutputPropertyConfigurationDto() != null && eventFormatterConfigurationDto.getWso2EventOutputMappingDto().getMetaWSO2EventOutputPropertyConfigurationDto()[0] != null) { %>
                <table class="styledVertical" id="outputMetaDataTable">
                    <thead>
                    <th>이름</th>
                    <th>value of</th>
                    <th>유형</th>
                    </thead>
                    <% EventOutputPropertyDto[] eventOutputPropertyDtos = eventFormatterConfigurationDto.getWso2EventOutputMappingDto().getMetaWSO2EventOutputPropertyConfigurationDto();
                        for (EventOutputPropertyDto eventOutputPropertyDto : eventOutputPropertyDtos) { %>
                    <tr>
                        <td><%=eventOutputPropertyDto.getName()%>
                        </td>
                        <td><%=eventOutputPropertyDto.getValueOf()%>
                        </td>
                        <td><%=eventOutputPropertyDto.getType()%>
                        </td>
                    </tr>
                    <% } %>

                </table>
                <% } else { %>
                <div class="act" id="noOutputMetaData">
                    	정의된 매타 데이터가 없습니다
                </div>
                <% } %>
            </td>
        </tr>


        <tr name="outputWSO2EventMapping">
            <td colspan="2">

                <h6>Correlation 데이터 매핑</h6>
                <% if (eventFormatterConfigurationDto.getWso2EventOutputMappingDto().getCorrelationWSO2EventOutputPropertyConfigurationDto() != null && eventFormatterConfigurationDto.getWso2EventOutputMappingDto().getCorrelationWSO2EventOutputPropertyConfigurationDto()[0] != null) { %>
                <table class="styledVertical"
                       id="outputCorrelationDataTable">
                    <thead>
                    <th>이름</th>
                    <th>value of</th>
                    <th>유형</th>
                    </thead>
                    <% EventOutputPropertyDto[] eventOutputPropertyDtos = eventFormatterConfigurationDto.getWso2EventOutputMappingDto().getCorrelationWSO2EventOutputPropertyConfigurationDto();
                        for (EventOutputPropertyDto eventOutputPropertyDto : eventOutputPropertyDtos) { %>
                    <tr>
                        <td><%=eventOutputPropertyDto.getName()%>
                        </td>
                        <td><%=eventOutputPropertyDto.getValueOf()%>
                        </td>
                        <td><%=eventOutputPropertyDto.getType()%>
                        </td>
                    </tr>
                    <% } %>
                </table>
                <% } else {%>
                <div class="act" id="noOutputCorrelationData">
                    	정의된 Correlation 데이터가 없습니다.
                </div>
                <% } %>
            </td>
        </tr>

        <tr name="outputWSO2EventMapping">
            <td colspan="2">
                <h6>Payload 데이터 매핑</h6>
                <% if (eventFormatterConfigurationDto.getWso2EventOutputMappingDto().getPayloadWSO2EventOutputPropertyConfigurationDto() != null && eventFormatterConfigurationDto.getWso2EventOutputMappingDto().getPayloadWSO2EventOutputPropertyConfigurationDto()[0] != null) { %>
                <table class="styledVertical"
                       id="outputPayloadDataTable">
                    <thead>
                    <th>이름</th>
                    <th>value of</th>
                    <th>유형</th>
                    </thead>
                    <% EventOutputPropertyDto[] eventOutputPropertyDtos = eventFormatterConfigurationDto.getWso2EventOutputMappingDto().getPayloadWSO2EventOutputPropertyConfigurationDto();
                        for (EventOutputPropertyDto eventOutputPropertyDto : eventOutputPropertyDtos) { %>
                    <tr>
                        <td><%=eventOutputPropertyDto.getName()%>
                        </td>
                        <td><%=eventOutputPropertyDto.getValueOf()%>
                        </td>
                        <td><%=eventOutputPropertyDto.getType()%>
                        </td>
                    </tr>
                    <% } %>
                </table>
                <% } else { %>
                <div class="act" id="noOutputPayloadData">
                    	정의된 Payload 데이터가 없습니다.
                </div>
                <% } %>
            </td>
        </tr>

        </tbody>
    </table>
</div>

<%
} else if (eventFormatterConfigurationDto.getMappingType().equalsIgnoreCase("text")) {
%>

<div id="innerDiv2" class="detail-view">
    <table class="detail">
        <tbody>
        <tr name="outputTextMapping">
            <td colspan="3">
                TEXT 매핑
            </td>
        </tr>
        <% if (!(eventFormatterConfigurationDto.getTextOutputMappingDto().getRegistryResource())) {%>
        <tr>
            <td colspan="1">노출 매핑 대상<span
                    class="required">*</span></td>
            <td colspan="2">
                <input id="inline_text" type="radio" checked="checked" value="content"
                       name="inline_text" disabled="disabled">
                <label for="inline_text">콘텐츠</label>
                <input id="registry_text" type="radio" value="reg" name="registry_text"
                       disabled="disabled">
                <label for="registry_text">레지스트리 택스트</label>
            </td>
        </tr>
        <tr name="outputTextMappingInline" id="outputTextMappingInline">
            <td colspan="3">
                <p>
                    <textarea id="textSourceText" name="textSourceText"
                              style="border:solid 1px rgb(204, 204, 204); width: 99%;
    						  height: 150px; margin-top: 5px;"
                              name="textSource"
                              rows="30"
                              disabled="disabled"><%= eventFormatterConfigurationDto.getTextOutputMappingDto().getMappingText() %>
                    </textarea>
                </p>
            </td>
        </tr>
        <% } else { %>
        <tr>
            <td colspan="1">노출 매핑 대상<span
                    class="required">*</span></td>
            <td colspan="2">
                <input id="inline_text_reg" type="radio" value="content"
                       name="inline_text" disabled="disabled">
                <label for="inline_text_reg">콘텐츠</label>
                <input id="registry_text_reg" type="radio" value="reg" name="registry_text"
                       disabled="disabled" checked="checked">
                <label for="registry_text_reg">레지스트리 택스트</label>
            </td>
        </tr>
        <tr name="outputTextMappingRegistry" id="outputTextMappingRegistry">
            <td colspan="1">리소스 경로<span
                    class="required">*</span></td>
            <td colspan="1">
                <input type="text" id="textSourceRegistry" disabled="disabled"
                       value="<%=eventFormatterConfigurationDto.getTextOutputMappingDto().getMappingText() !=null ? eventFormatterConfigurationDto.getTextOutputMappingDto().getMappingText() : ""%>"
                       style="width:100%"/>
            </td>

            <td style="border:none" colspan="1">
                <a href="#registryBrowserLink" class="registry-picker-icon-link"
                   style="padding-left:20px">컨피그 레지스트리</a>
                <a href="#registryBrowserLink"
                   class="registry-picker-icon-link"
                   style="padding-left:20px">Gov 레지스트리</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<%
} else if (eventFormatterConfigurationDto.getMappingType().equalsIgnoreCase("xml")) {
%>

<div id="innerDiv3" class="detail-view">
    <table class="detail">
        <tbody>
        <tr name="outputXMLMapping">
            <td colspan="3">
                XML매핑
            </td>
        </tr>
        <% if (!eventFormatterConfigurationDto.getXmlOutputMappingDto().getRegistryResource()) { %>
        <tr>
            <td colspan="1">매핑 대상<span
                    class="required">*</span></td>
            <td colspan="2">
                <input id="inline_xml" type="radio" checked="checked" value="content"
                       name="inline_xml" disabled="disabled">
                <label for="inline_xml">컨탠츠</label>
                <input id="registry_xml" type="radio" value="reg" name="registry_xml"
                       disabled="disabled">
                <label for="registry_xml">Registry XML</label>
            </td>
        </tr>
        <tr name="outputXMLMappingInline" id="outputXMLMappingInline">
            <td colspan="3">
                <p>
                    <textarea id="xmlSourceText"
                              style="border:solid 1px rgb(204, 204, 204); width: 99%;
                                     height: 150px; margin-top: 5px;"
                              name="xmlSource"
                              rows="30"
                              disabled="disabled"><%=eventFormatterConfigurationDto.getXmlOutputMappingDto().getMappingXMLText() != null ? eventFormatterConfigurationDto.getXmlOutputMappingDto().getMappingXMLText() : ""%>
                    </textarea>
                </p>
            </td>
        </tr>
        <% } else { %>
        <tr>
            <td colspan="1">매핑 대상<span
                    class="required">*</span></td>
            <td colspan="2">
                <input id="inline_xml_reg" type="radio" value="content"
                       name="inline_xml" disabled="disabled">
                <label for="inline_xml_reg">컨텐츠</label>
                <input id="registry_xml_reg" type="radio" value="reg" name="registry_xml"
                       disabled="disabled" checked="checked">
                <label for="registry_xml_reg">Registry XML</label>
            </td>
        </tr>
        <tr name="outputXMLMappingRegistry" id="outputXMLMappingRegistry">
            <td colspan="1">resource 경로<span
                    class="required">*</span></td>
            <td colspan="1">
                <input type="text" id="xmlSourceRegistry" disabled="disabled" value=""
                       style="width:100%"/>
            </td>
            <td  style="border:none" colspan="1">
                <a href="#registryBrowserLink" class="registry-picker-icon-link"
                   style="padding-left:20px">컨피그 레지스트리</a>
                <a href="#registryBrowserLink"
                   class="registry-picker-icon-link"
                   style="padding-left:20px">Gov 레지스트리</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<%
} else if (eventFormatterConfigurationDto.getMappingType().equalsIgnoreCase("map")) {
%>

<div id="innerDiv4" class="detail-view">
    <table class="detail>
        <tbody>
        <tr name="outputMapMapping">
            <td colspan="2">
                MAP 매핑
            </td>
        </tr>
        <% if (eventFormatterConfigurationDto.getMapOutputMappingDto().getOutputPropertyConfiguration() != null && eventFormatterConfigurationDto.getMapOutputMappingDto().getOutputPropertyConfiguration()[0] != null) { %>
        <tr name="outputMapMapping">
            <td colspan="2">
                <table class="styledVertical" id="outputMapPropertiesTable">
                    <thead>
                    <th>이름</th>
                    <th>Value of</th>
                    </thead>
                    <% EventOutputPropertyDto[] eventOutputPropertyDtos = eventFormatterConfigurationDto.getMapOutputMappingDto().getOutputPropertyConfiguration();
                        for (EventOutputPropertyDto eventOutputPropertyDto : eventOutputPropertyDtos) { %>
                    <tr>
                        <td><%=eventOutputPropertyDto.getName()%>
                        </td>
                        <td><%=eventOutputPropertyDto.getValueOf()%>
                        </td>
                    </tr>
                    <% } %>
                </table>
                <% } else { %>
                <div class="act" id="noOutputMapProperties">
                    	정의된 Map 속성이 없습니다.
                </div>
                <% } %>
            </td>
        </tr>

        </tbody>
    </table>
</div>
<%
} else if (eventFormatterConfigurationDto.getMappingType().equalsIgnoreCase("json")) {
%>

<div id="innerDiv5" class="detail-view">
    <table class="detail">
        <tbody>
        <tr name="outputJSONMapping">
            <td colspan="3">
                JSON 매핑
            </td>
        </tr>
        <% if (!eventFormatterConfigurationDto.getJsonOutputMappingDto().getRegistryResource()) { %>
        <tr>
            <td colspan="1">아웃품 매핑 컨탠츠<span
                    class="required">*</span></td>
            <td colspan="2">
                <input id="inline_json" type="radio" checked="checked" value="content"
                       name="inline_json" disabled="disabled">
                <label for="inline_json">컨탠츠</label>
                <input id="registry_json" type="radio" value="reg" name="registry_json"
                       disabled="disabled">
                <label for="registry_json">JSon 등록</label>
            </td>
        </tr>
        <tr name="outputJSONMappingInline" id="outputJSONMappingInline">
            <td colspan="3">
                <p>
                    <textarea id="jsonSourceText"
                              style="border:solid 1px rgb(204, 204, 204); width: 99%;
                                     height: 150px; margin-top: 5px;"
                              name="jsonSource"
                              rows="30"
                              disabled="disabled"><%=eventFormatterConfigurationDto.getJsonOutputMappingDto().getMappingText()!=null ? eventFormatterConfigurationDto.getJsonOutputMappingDto().getMappingText() : ""%>
                    </textarea>
                </p>
            </td>
        </tr>
        <% } else { %>
        <tr>
            <td colspan="1">아웃품 매핑 컨탠츠<span
                    class="required">*</span></td>
            <td colspan="2">
                <input id="inline_json_text" type="radio" value="content"
                       name="inline_json_text" disabled="disabled">
                <label for="inline_json_text">컨탠츠</label>
                <input id="registry_json_reg" type="radio" value="reg" name="registry_json"
                       disabled="disabled" checked="checked">
                <label for="registry_json_reg">JSon 등록</label>
            </td>
        </tr>
        <tr name="outputJSONMappingRegistry" id="outputJSONMappingRegistry">
            <td colspan="1">Path<span
                    class="required">*</span></td>
            <td colspan="1">
                <input type="text" id="jsonSourceRegistry" disabled="disabled"
                       value="<%=eventFormatterConfigurationDto.getJsonOutputMappingDto().getMappingText() != null ? eventFormatterConfigurationDto.getJsonOutputMappingDto().getMappingText() : ""%>"
                       style="width:100%"/>
            </td>
            <td colspan="1" class="nopadding" style="border:none">
                <a href="#registryBrowserLink" class="registry-picker-icon-link"
                   style="padding-left:20px">conf.registry</a>
                <a href="#registryBrowserLink"
                   class="registry-picker-icon-link"
                   style="padding-left:20px">gov.registry</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<%
    }
%>

</div>
</td>
</tr>

<%
    ToPropertyConfigurationDto toPropertyConfigurationDto = eventFormatterConfigurationDto.getToPropertyConfigurationDto();
    if (toPropertyConfigurationDto != null && toPropertyConfigurationDto.getOutputEventAdaptorMessageConfiguration()[0] != null) {

        for (int index = 0; index < toPropertyConfigurationDto.getOutputEventAdaptorMessageConfiguration().length; index++) {
            EventFormatterPropertyDto[] eventFormatterPropertyDto = toPropertyConfigurationDto.getOutputEventAdaptorMessageConfiguration();
%>
<tr>


    <td><%=eventFormatterPropertyDto[index].getDisplayName()%>
        <%
            String propertyId = "property_";
            if (eventFormatterPropertyDto[index].getRequired()) {
                propertyId = "property_Required_";

        %>
        <span class="required">*</span>
        <%
            }
        %>
    </td>
    <%
        String type = "text";
        if (eventFormatterPropertyDto[index].getSecured()) {
            type = "password";
        }
    %>

    <td>
        <div class="act">
            <%
                if (eventFormatterPropertyDto[index].getOptions()[0] != null) {
            %>

            <select name="<%=eventFormatterPropertyDto[index].getKey()%>"
                    id="<%=propertyId%><%=index%>" disabled="disabled">

                <%
                    for (String property : eventFormatterPropertyDto[index].getOptions()) {
                        if (property.equals(eventFormatterPropertyDto[index].getValue())) {
                %>
                <option selected="selected"><%=property%>
                </option>
                <% } else { %>
                <option><%=property%>
                </option>
                <% }
                } %>
            </select>

            <% } else { %>
            <input type="<%=type%>"
                   name="<%=eventFormatterPropertyDto[index].getKey()%>"
                   id="<%=propertyId%><%=index%>" class="initE"
                   style="width:75%"
                   value="<%= eventFormatterPropertyDto[index].getValue() != null ? eventFormatterPropertyDto[index].getValue() : "" %>" disabled="disabled"/>

            <% } %>


        </div>
    </td>

</tr>
<%
        }
    }
%>
</tbody>
</table>
</td>
</tr>
<%
    }
%>
</tbody>
</table>
</form>
</div>
</div>
