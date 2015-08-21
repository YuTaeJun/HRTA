<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>

<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.EventFormatterPropertyDto" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>
<%@ page import="java.util.List" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.OutputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.types.OutputEventAdaptorConfigurationInfoDto" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.types.EventStreamDefinitionDto" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.types.EventStreamAttributeDto" %>
<%@ page import="org.wso2.carbon.event.formatter.ui.EventFormatterUIConstants" %>

<script type="text/javascript" src="../hrta_eventformatter/js/event_formatter.js"></script>
<script type="text/javascript" src="../hrta_eventformatter/js/registry-browser.js"></script>
<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>

<script type="text/javascript" src="../ajax/js/prototype.js"></script>
<script type="text/javascript" src="../hrta_eventformatter/js/create_eventFormatter_helper.js"></script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        showMappingContext();
    });

</script>

<div id="cols">
<p id="breadCurmb">
	Home &gt; 이벤트 포멧터 &gt; 이벤트 포멧터 생성								
	</p>
	<div class="hgroup">
		<h1>이벤트 포멧터 생성</h1>
	</div>

<div id="workArea" class="act">
<form name="inputForm" action="#" method="post" id="addEventFormatter">
<table id="eventFormatterAdd" class="styledVertical">
<%
    EventFormatterAdminServiceStub eventFormatterAdminServiceStub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);
    OutputEventAdaptorManagerAdminServiceStub outputEventAdaptorManagerAdminServiceStub =
    		ToogramEventFormatterUIUtils.getOutputEventManagerAdminService(config, session, request, response);
    OutputEventAdaptorConfigurationInfoDto[] outputEventAdaptorInfoArray = outputEventAdaptorManagerAdminServiceStub.getAllActiveOutputEventAdaptorConfiguration();
    String streamId = request.getParameter("streamId");
    String redirectPage = request.getParameter("redirectPage");
    if (streamId != null) {
        EventStreamAdminServiceStub eventStreamAdminServiceStub = ToogramEventFormatterUIUtils.getEventStreamAdminService(config, session, request, response);
        EventStreamDefinitionDto streamDefinitionDto = eventStreamAdminServiceStub.getStreamDefinitionDto(streamId);
        EventStreamAttributeDto[] metaAttributeList = streamDefinitionDto.getMetaData();
        EventStreamAttributeDto[] correlationAttributeList = streamDefinitionDto.getCorrelationData();
        EventStreamAttributeDto[] payloadAttributeList = streamDefinitionDto.getPayloadData();

        String attributes = "";

        if (metaAttributeList != null && metaAttributeList.length > 0) {
            for (EventStreamAttributeDto attribute : metaAttributeList) {
                attributes += EventFormatterUIConstants.PROPERTY_META_PREFIX + attribute.getAttributeName() + " " + attribute.getAttributeType() + ", \n";
            }
        }
        if (correlationAttributeList != null) {
            for (EventStreamAttributeDto attribute : correlationAttributeList) {
                attributes += EventFormatterUIConstants.PROPERTY_CORRELATION_PREFIX + attribute.getAttributeName() + " " + attribute.getAttributeType() + ", \n";
            }
        }
        if (payloadAttributeList != null) {
            for (EventStreamAttributeDto attribute : payloadAttributeList) {
                attributes += attribute.getAttributeName() + " " + attribute.getAttributeType() + ", \n";
            }
        }

        if (!attributes.equals("")) {
            attributes = attributes.substring(0, attributes.lastIndexOf(","));
        }

        String streamDefinition = attributes;

        List<String> attributeList = ToogramEventFormatterUIUtils.getAttributeListWithPrefix(streamDefinitionDto);
%>
<thead>
<tr>
    <th>이벤트 포멧터 상세 내역</th>
</tr>
</thead>
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
	    <th>이름<span class="required">*</span>
	    </th>
	    <td><input type="text" name="eventFormatterName" id="eventFormatterId" value="" style="width:80%"/>	
	        <p><small>이벤트 포멧터 명을 입력하세요</small></p>
	    </td>
	</tr>
	
	<tr>
	    <td colspan="2">
	        <b>출처</b>
	    </td>
	</tr>
	
	<tr>
	    <th>
	        스트림 정의
	    </th>
	    <td>
	        <textArea class="expandedTextarea" id="streamDefinitionText" name="streamDefinitionText"
	                  readonly="true" cols="60"><%=streamDefinition%>
	        </textArea>
	
	    </td>
	
	</tr>
	
	<tr>
	    <th>아웃풋 이벤트 어답터 선택<span class="required">*</span></th>
	    <td>    
	    	<select name="eventAdaptorNameFilter" 
	            onchange="loadEventAdaptorRelatedProperties('To')" id="eventAdaptorNameFilter">
	                <%
	                    String firstEventAdaptorName = null;
	
	                    if (outputEventAdaptorInfoArray != null) {
	                        firstEventAdaptorName = outputEventAdaptorInfoArray[0].getEventAdaptorName();
	                        for (OutputEventAdaptorConfigurationInfoDto outputEventAdaptorInfoDto : outputEventAdaptorInfoArray) {
	                %>
	                <option value="<%=outputEventAdaptorInfoDto.getEventAdaptorName() + "$=" + outputEventAdaptorInfoDto.getEventAdaptorType()%>"><%=outputEventAdaptorInfoDto.getEventAdaptorName()%>
	                </option>
	                <%
	                        }
	                    }
	                %>
	
            </select>
            <p><small>이벤트를 전송할 아웃풋 이벤트 아답터를 선택하시오</small></p>
	    </td>
	</tr>
	
	<%
	    EventFormatterPropertyDto[] eventFormatterProperties = eventFormatterAdminServiceStub.getEventFormatterMessageProperties(firstEventAdaptorName);
	    if (eventFormatterProperties != null) {
	%>
	<tr>
	    <td colspan="2">
	        <b>To</b>
	    </td>
	</tr>
	<%
	    for (int index = 0; index < eventFormatterProperties.length; index++) {
	%>
	<tr>
	    <th><%=eventFormatterProperties[index].getDisplayName()%>
	        <%
	            String propertyId = "property_";
	            if (eventFormatterProperties[index].getRequired()) {
	                propertyId = "property_Required_";
	
	        %>
	        <span class="required">*</span>
	        <%
	            }
	        %>
	    </th>
	    <%
	        String type = "text";
	        if (eventFormatterProperties[index].getSecured()) {
	            type = "password";
	        }
	    %>
	
	    <td>
	            <%
	                if (eventFormatterProperties[index].getOptions()[0] != null) {
	            %>
	
	            <select name="<%=eventFormatterProperties[index].getKey()%>"
	                    id="<%=propertyId%><%=index%>">
	
	                <%
	                    for (String property : eventFormatterProperties[index].getOptions()) {
	                        if (property.equals(eventFormatterProperties[index].getDefaultValue())) {
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
	                   name="<%=eventFormatterProperties[index].getKey()%>"
	                   id="<%=propertyId%><%=index%>" style="width:80%"
	                   value="<%= (eventFormatterProperties[index].getDefaultValue()) != null ? eventFormatterProperties[index].getDefaultValue() : "" %>"
	                    />
	
	            <% }
	
	                if (eventFormatterProperties[index].getHint() != null) { %>
	            <p><small>
	                <%=eventFormatterProperties[index].getHint()%>
	            </small></p>
	            <% } %>
	    </td>
	
	</tr>
	<%
	        }
	    }
	%>
	
	<tr>
	    <td colspan="2">
	        <b>매핑 설정</b>
	    </td>
	</tr>
	
	<tr>
	    <th>Output Mapping 타입 
	    	<span class="required">*</span>
    	</th>
	    <td>
	    	<select name="mappingTypeFilter"
	                onchange="showMappingContext()" id="mappingTypeFilter">
	        <%
	            String[] mappingTypes = outputEventAdaptorManagerAdminServiceStub.getSupportedMappingTypes(firstEventAdaptorName);
	
	
	            if (mappingTypes != null) {
	                for (String mappingType : mappingTypes) {
	        %>
	        <option><%=mappingType%>
	        </option>
	        <%
	                }
	            }
	        %>
	
		    </select>
		    <p><small>매핑 타입을 설정 하시오</small></p>
	    </td>	
	</tr>
	<tr>
	    <td style="border-bottom: 0 none!important;">
              <p class="fnc-set">
              	<a href="#" class="btn-add" onclick="handleAdvancedMapping()"><i class="fa fa-plus-circle fa-2"></i>고급설정</a>			
		</p>
		</td>
	</tr>
	
	
	<tr>
	<td colspan="2" style="border-bottom: 0 none!important; border-top: 0 none!important;">
	<div id="outerDiv" style="display:none">
	
	<div id="innerDiv1" style="display:none">
	
	    <table class="line-tb">
	    	<thead>
	        <tr name="outputWSO2EventMapping">
	            <th colspan="2" class="middle-header">
	                WSO2 이벤트 매핑
	            </th>
	        </tr>    	
	    	</thead>
	        <tbody>
	        <tr name="outputWSO2EventMapping">
	            <td colspan="2">
	
	                <h6>메타 데이터 매핑</h6>
	                <table class="styledVertical" id="outputMetaDataTable"
	                       style="display:none">
	                    <thead>
	                    <th>이름</th>
                    	<th>value of</th>
                    	<th>수정</th>
	                    </thead>
	                </table>
	                <div class="act" id="noOutputMetaData">
                    	정의된 매타 데이터가 없습니다
                	</div>
	                <table id="addMetaData" class="styledVertical">
	                    <tbody>
	                    <tr>
	                        <td>프로퍼티 명 :</td>
	                        <td>
	                            <input type="text" id="outputMetaDataPropName"/>
	                        </td>
	                        <td>Value of :
	                        </td>
	                        <td>
	                            <select id="outputMetaDataPropValueOf">
	                                <% for (String attributeData : attributeList) {
	                                    String[] attributeValues = attributeData.split(" ");
	                                %>
	                                <option value="<%=attributeValues[0]%>"><%=attributeValues[0]%>
	                                </option>
	                                <% }%>
	                            </select>
	                        </td>
	                        <td><input type="button" class="btn"
	                                   value="추가"
	                                   onclick="addOutputWSO2EventProperty('Meta')"/>
	                        </td>
	                    </tr>
	                    </tbody>
	                </table>
	            </td>
	        </tr>
	
	
	        <tr name="outputWSO2EventMapping">
	            <td colspan="2">	
	                <h6>Correlation 데이터</h6>
	                <table class="styledVertical"
	                       id="outputCorrelationDataTable" style="display:none">
	                    <thead>
	                    <th>이름</th>
	                    <th>value of</th>
	                    <th>수정</th>
	                    </thead>
	                </table>
	                <div class="act" id="noOutputCorrelationData">
                    	정의된 Correlation 데이터가 없습니다.
                	</div>
	                <table id="addCorrelationData" class="normal">
	                    <tbody>
	                    <tr>
	                        <td class="col-small"><fmt:message key="property.name"/> :</td>
	                        <td>
	                            <input type="text" id="outputCorrelationDataPropName"/>
	                        </td>
	                        <td class="col-small"><fmt:message key="property.value.of"/> :
	                        </td>
	                        <td>
	                            <select id="outputCorrelationDataPropValueOf">
	                                <% for (String attributeData : attributeList) {
	                                    String[] attributeValues = attributeData.split(" ");
	                                %>
	                                <option value="<%=attributeValues[0]%>"><%=attributeValues[0]%>
	                                </option>
	                                <% }%>
	                            </select>
	                        </td>
	                        <td><input type="button" class="button"
	                                   value="<fmt:message key="add"/>"
	                                   onclick="addOutputWSO2EventProperty('Correlation')"/>
	                        </td>
	                    </tr>
	                    </tbody>
	                </table>
	            </td>
	        </tr>
	        <tr name="outputWSO2EventMapping">
	            <td colspan="2">
	
	                <h6>Payload 데이터 매핑</h6>
	                <table class="styledVertical"
	                       id="outputPayloadDataTable" style="display:none">
	                    <thead>
		                    <th>이름</th>
		                    <th>value of</th>
		                    <th>수정</th>
	                    </thead>
	                </table>
	                <div class="act" id="noOutputPayloadData">
                    	정의된 Payload 데이터가 없습니다.
                	</div>
	                <table id="addPayloadData">
	                    <tbody>
	                    <tr>
	                        <td>프로퍼티 명 :</td>
	                        <td>
	                            <input type="text" id="outputPayloadDataPropName"/>
	                        </td>
	                        <td>Value of</td>
	                        <td>
	                            <select id="outputPayloadDataPropValueOf">
	                                <% for (String attributeData : attributeList) {
	                                    String[] attributeValues = attributeData.split(" ");
	                                %>
	                                <option value="<%=attributeValues[0]%>"><%=attributeValues[0]%>
	                                </option>
	                                <% }%>
	                            </select>
	                        </td>
	                        <td><input type="button" class="btn"
	                                   value="추가"
	                                   onclick="addOutputWSO2EventProperty('Payload')"/>
	                        </td>
	                    </tr>
	                    </tbody>
	                </table>
	            </td>
	        </tr>
	
	        </tbody>
	    </table>
	</div>
	
	
	<div id="innerDiv2" style="display:none">
	    <table class="line-tb">
	    	<thead>
	        <tr name="outputTextMapping">
	            <th colspan="3">
	                TEXT 메핑
	            </th>
	        </tr>    	
	    	</thead>
	        <tbody>	        
	        <tr>
	            <td colspan="1">노출 매핑 대상<span
	                    class="required">*</span></td>
	            <td colspan="2">
	                <input id="inline_text" type="radio" checked="checked" value="content"
	                       name="inline_text" onclick="enable_disable_Registry(this)">
	                <label for="inline_text">인라인</label>
	                <input id="registry_text" type="radio" value="reg" name="registry_text"
	                       onclick="enable_disable_Registry(this)">
	                <label for="registry_text">레지스트리에서 선택</label>
	            </td>
	        </tr>
	        <tr name="outputTextMappingInline" id="outputTextMappingInline">
	            <td colspan="3">
	                <p>
	                    <textarea id="textSourceText" name="textSourceText"
	                              style="border:solid 1px rgb(204, 204, 204); width: 99%;
	    							height: 150px; margin-top: 5px;"
	                              name="textSource" rows="30"></textarea>
	                </p>
	            </td>
	        </tr>
	        <tr name="outputTextMappingRegistry" style="display:none" id="outputTextMappingRegistry">
	            <td colspan="1">리소스 경로<span
	                    class="required">*</span></td>
	            <td colspan="1"><input type="text" id="textSourceRegistry" disabled="disabled"
	                                   value=""
	                                   style="width:100%"/></td>
	
	            <td style="border:none" colspan="1">	
	            <p class="fnc-set">                
	               	<a href="#registryBrowserLink" class="btn-add" onclick="showRegistryBrowser('textSourceRegistry','/_system/config');">
	               		<i class="fa fa-plus-circle fa-2"></i>레지스트리 선택</a>	
	                <a class="edit" href="#registryBrowserLink" onclick="showRegistryBrowser('textSourceRegistry', '/_system/governance');">
						<i class="fa fa-pencil-square-o"></i>레지스트리 수정</a>
				</p>
	            </td>
	        </tr>
	        </tbody>
	    </table>
	</div>
	
	<div id="innerDiv3" style="display:none">
	    <table class="line-tb">
	    <thead>
   	        <tr name="outputXMLMapping">
	            <th colspan="3">
	                XML 매핑
	            </th>
	        </tr>
	    
	    </thead>
	        <tbody>
	        <tr>
	            <td colspan="1">매핑 대상 컨탠츠<span
	                    class="required">*</span></td>
	            <td colspan="2">
	                <input id="inline_xml" type="radio" checked="checked" value="content"
	                       name="inline_xml" onclick="enable_disable_Registry(this)">
	                <label for="inline_xml">인라인 컨탠츠</label>
	                <input id="registry_xml" type="radio" value="reg" name="registry_xml"
	                       onclick="enable_disable_Registry(this)">
	                <label for="registry_xml">레지스트에서 획득</label>
	            </td>
	        </tr>
	        <tr name="outputXMLMappingInline" id="outputXMLMappingInline">
	            <td colspan="3">
	                <p>
	                    <textarea id="xmlSourceText"
	                              style="border:solid 1px rgb(204, 204, 204); width: 99%;
	                                     height: 150px; margin-top: 5px;"
	                              name="xmlSource" rows="30"></textarea>
	                </p>
	            </td>
	        </tr>
	        <tr name="outputXMLMappingRegistry" style="display:none" id="outputXMLMappingRegistry">
	            <td colspan="1">Path<span
	                    class="required">*</span></td>
	            <td colspan="1">
	                <input type="text" id="xmlSourceRegistry" disabled="disabled" value=""
	                       style="width:100%"/>
	            </td>
	            <td style="border:none" colspan="1">
	            <p class="fnc-set">
	               	<a href="#registryBrowserLink" class="btn-add" onclick="showRegistryBrowser('xmlSourceRegistry','/_system/config');">
	               		<i class="fa fa-plus-circle fa-2"></i>레지스트리 선택</a>	
	                <a class="edit" href="#registryBrowserLink" onclick="showRegistryBrowser('xmlSourceRegistry', '/_system/governance');">
						<i class="fa fa-pencil-square-o"></i>레지스트리 수정</a>
				</p>	                   
	            </td>
	        </tr>
	        </tbody>
	    </table>
	</div>
	
	
	<div id="innerDiv4" style="display:none">
	    <table class="line-tb">
	    	<thead>
	        <tr name="outputMapMapping">
	            <th colspan="2">
	                MAP 매핑
	            </th>
	        </tr>
	    	</thead>
	        <tbody>	        
	        <tr name="outputMapMapping">
	            <td colspan="2">
	
	                <table class="styledVertical" id="outputMapPropertiesTable" style="display:none">
	                    	<tr>
			                    <th>이름</th>
		                    	<th>Value of</th>
		                    	<th>수정</th>
	                    	</tr>
	                </table>
	                <div class="act" id="noOutputMapProperties">
                    	정의된 Map 속성이 없습니다.
                	</div>
	                <table id="addOutputMapProperties">
	                    <tbody>
	                    <tr>
	                        <td>프로퍼티 명 :</td>
	                        <td>
	                            <input type="text" id="outputMapPropName"/>
	                        </td>
	                        <td>Value of :</td>
	                        <td>
	                            <select id="outputMapPropValueOf">
	                                <% for (String attributeData : attributeList) {
	                                    String[] attributeValues = attributeData.split(" ");
	                                %>
	                                <option value="<%=attributeValues[0]%>"><%=attributeValues[0]%>
	                                </option>
	                                <% }%>
	                            </select>
	                        </td>
	                        <td>
	                        <input type="button" class="btn" value="추가" onclick="addOutputMapProperty()"/>
	                        </td>
	                    </tr>
	                    </tbody>
	                </table>
	            </td>
	        </tr>
	
	        </tbody>
	    </table>
	</div>
	
	<div id="innerDiv5" style="display:none">
	    <table class="line-tb">
	    	<thead>
	        <tr name="outputJSONMapping">
	            <th colspan="3" class="middle-header">
	                json 매핑
	            </th>
	        </tr>
	    	</thead>
	        <tbody>
	        <tr>
	            <td colspan="1">노출 대상 컨탠츠<span
	                    class="required">*</span></td>
	            <td colspan="2">
	                <input id="inline_json" type="radio" checked="checked" value="content"
	                       name="inline_json" onclick="enable_disable_Registry(this)">
	                <label for="inline_json">인라인 추가</label>
	                <input id="registry_json" type="radio" value="reg" name="registry_json"
	                       onclick="enable_disable_Registry(this)">
	                <label for="registry_json">레지스트리에서 지정</label>
	            </td>
	        </tr>
	        <tr name="outputJSONMappingInline" id="outputJSONMappingInline">
	            <td colspan="3">
	                <p>
	                    <textarea id="jsonSourceText"
	                              style="border:solid 1px rgb(204, 204, 204); width: 99%;
	                                     height: 150px; margin-top: 5px;"
	                              name="jsonSource" rows="30"></textarea>
	                </p>
	            </td>
	        </tr>
	        <tr name="outputJSONMappingRegistry" style="display:none" id="outputJSONMappingRegistry">
	            <td colspan="1">Path<span
	                    class="required">*</span></td>
	            <td colspan="1">
	                <input type="text" id="jsonSourceRegistry" disabled="disabled"
	                       value=""
	                       style="width:100%"/>
	            </td>
	            <td style="border:none" colspan="1">
	            <p class="fnc-set">	                   
   	               	<a href="#registryBrowserLink" class="btn-add" onclick="showRegistryBrowser('jsonSourceRegistry','/_system/config');">
	               		<i class="fa fa-plus-circle fa-2"></i>레지스트리 선택</a>	
	                <a class="edit" href="#registryBrowserLink" onclick="showRegistryBrowser('jsonSourceRegistry', '/_system/governance');">
						<i class="fa fa-pencil-square-o"></i>레지스트리 수정</a>	       
	            </p>
	            </td>
	        </tr>
	        </tbody>
	    </table>
	</div>
	
	
	</div>
	</td>
	</tr>	
	</tbody>
	</table>
	</div>
</td>
</tr>
<tr>
    <td class="buttonRow">
        <input type="button" class="btn" value="이벤트 포멧터 추가"
               onclick="addEventFormatterViaPopup(document.getElementById('addEventFormatter') ,'<%=streamId%>','<%=redirectPage%>')"/>
    </td>
</tr>
</tbody>
<% } else { %>
<tbody>
<tr>
    <td>
        <table id="noEventBuilderInputTable"
               style="width:100%">
            <tbody>
            <tr>
                <td colspan="2">
                이벤트 스티림이나 아웃풋 이벤트 어답터가 없습니다. 계속하시려면 아웃풋 이벤트 어답터를 생성하십시오
                </td>
            </tr>
            </tbody>
        </table>
    </td>
</tr>
</tbody>
<% } %>
</table>
</form>
</div>
</div>
