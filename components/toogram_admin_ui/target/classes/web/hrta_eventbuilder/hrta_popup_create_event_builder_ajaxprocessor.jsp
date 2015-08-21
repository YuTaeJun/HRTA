<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>

<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>

<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.InputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.types.InputEventAdaptorConfigurationInfoDto" %>
<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderMessagePropertyDto" %>


<link type="text/css" href="../hrta_eventbuilder/css/cep.css" rel="stylesheet"/>
<link rel="stylesheet" href="../layout/css/screen.css" />

<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>
<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>

<script type="text/javascript" src="../hrta_eventbuilder/js/event_builders.js"></script>
<script type="text/javascript" src="../hrta_eventbuilder/js/create_event_builder_helper.js"></script>

<div id="cols">
<p id="breadCurmb">
	Home &gt; 이벤트 빌더 &gt; 이벤트 빌더 생성								
	</p>
	<div class="hgroup">
		<h1>이벤트 빌더 생성</h1>
	</div>

<%
    EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
    InputEventAdaptorManagerAdminServiceStub eventAdaptorManagerAdminServiceStub = ToogramEventBuilderUIUtils.getInputEventAdaptorManagerAdminService(
            config, session, request,response);
    InputEventAdaptorConfigurationInfoDto[] inputEventAdaptorInfoDtos = eventAdaptorManagerAdminServiceStub.getAllActiveInputEventAdaptorConfiguration();
    String streamNameWithVersion = request.getParameter("streamNameWithVersion");
    String redirectPage = request.getParameter("redirectPage");
    if (inputEventAdaptorInfoDtos != null) {
%>
<h4><%=streamNameWithVersion%> : 스트림에 대한 이벤트를 받기 위한 이벤트 빌더 생성</h4>
<br/>
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
                <th>이벤트 빌더 명<span class="required">*</span>
                </th>
                <td><input type="text" name="configName" id="eventBuilderNameId"
                           onclick="clearTextIn(this)" onblur="fillTextIn(this)"
                           value=""/>
					<p><small>이벤트 빌더 명을 입력하세요</small></p>
                </td>
            </tr>

            <tr id="eventAdaptorSelectTr">
                <th>인풋 이벤트 어답터 선택<span class="required">*</span></th>
                <!-- The element positioning of the select is important since showMessageConfigProperties uses the first
  ancestral 'tr' to determine where to insert the message configuration properties on loading ajax -->
                <td style="padding-left: 0px !important;">
                   
                                <select name="eventAdaptorNameSelect"
                                        id="eventAdaptorNameSelect"
                                        onchange="showMessageConfigProperties('<%=streamNameWithVersion%>')">
                                    <%
                                        String firstEventAdaptorName = inputEventAdaptorInfoDtos[0].getEventAdaptorName();
                                        for (InputEventAdaptorConfigurationInfoDto InputEventAdaptorInfoDto : inputEventAdaptorInfoDtos) {
                                    %>
                                    <option value="<%=InputEventAdaptorInfoDto.getEventAdaptorName() + "$=" + InputEventAdaptorInfoDto.getEventAdaptorType()%>"><%=InputEventAdaptorInfoDto.getEventAdaptorName()%>
                                    </option>
                                    <%
                                        }
                                    %>
                                </select>
								
								<p><small>유입되는 이벤트를 받을 인풋 이벤트 아답터를 선택하시오</small></p>

                </td>
            </tr>
            <tr>

                <% //Input fields for message configuration properties
                    if (firstEventAdaptorName != null && !firstEventAdaptorName.isEmpty()) {
                        EventBuilderMessagePropertyDto[] messageConfigurationProperties = stub.getEventBuilderMessageProperties(firstEventAdaptorName);

                        //Need to add other types of properties also here
                        if (messageConfigurationProperties != null) {
                            for (int index = 0; index < messageConfigurationProperties.length; index++) {
                %>

                <th>
                    <%=messageConfigurationProperties[index].getDisplayName()%>
                    <%
                        String propertyId = "msgConfigProperty_";
                        if (messageConfigurationProperties[index].getRequired()) {
                            propertyId = "msgConfigProperty_Required_";

                    %>
                    <span class="required">*</span>
                    <%
                        }
                    %>

                </th>
                <%
                    String type = "text";
                    if (messageConfigurationProperties[index].getSecured()) {
                        type = "password";
                    }
                %>
                <td><input type="<%=type%>"
                           name="<%=messageConfigurationProperties[index].getKey()%>"
                           id="<%=propertyId%><%=index%>"
                           value="<%= (messageConfigurationProperties[index].getDefaultValue()) != null ? messageConfigurationProperties[index].getDefaultValue() : "" %>"/>
                    <%
                        if (messageConfigurationProperties[index].getHint() != null) {
                    %>
                    <p><small><%=messageConfigurationProperties[index].getHint()%></small></p>
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
                <td colspan="2"><b>매핑 설정</b></td>
            </tr>
            <tr>
                <th>Input Mapping Type<span class="required">*</span></th>
                <td><select name="inputMappingTypeSelect"
                            id="inputMappingTypeSelect"
                            onchange="loadMappingUiElements('<%=streamNameWithVersion%>')">
                    <%
                        String[] mappingTypeNames = eventAdaptorManagerAdminServiceStub.getSupportedInputMappingTypes(firstEventAdaptorName);
                        String firstMappingTypeName = null;
                        if (mappingTypeNames != null) {
                            firstMappingTypeName = mappingTypeNames[0];
                            for (String mappingTypeName : mappingTypeNames) {
                    %>
                    <option><%=mappingTypeName%>
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
                <td id="mappingUiTd" colspan="2" style="border-bottom: 0 none!important; border-top: 0 none!important;">
                        <div id="outerDiv" style="display:none">
                        <%
                            if (firstMappingTypeName != null) {
                                if (firstMappingTypeName.equals("wso2event")) {
                        %>
			                        <jsp:include page="../hrta_eventbuilder/hrta_wso2event_mapping_ui.jsp" flush="true">
			                            <jsp:param name="eventStreamWithVersion"
			                                       value="<%=streamNameWithVersion%>"/>
			                        </jsp:include>
                        <%
                        		} else if (firstMappingTypeName.equals("xml")) {
                        %>
			                        <jsp:include page="../hrta_eventbuilder/hrta_xml_mapping_ui.jsp" flush="true">
			                            <jsp:param name="eventStreamWithVersion"
			                                       value="<%=streamNameWithVersion%>"/>
			                        </jsp:include>
                        <%
                        		} else if (firstMappingTypeName.equals("map")) {
                        %>
			                        <jsp:include page="../hrta_eventbuilder/hrta_map_mapping_ui.jsp" flush="true">
			                            <jsp:param name="eventStreamWithVersion"
			                                       value="<%=streamNameWithVersion%>"/>
			                        </jsp:include>
                        <%
                        		} else if (firstMappingTypeName.equals("text")) {
                        %>
			                        <jsp:include page="../hrta_eventbuilder/hrta_text_mapping_ui.jsp" flush="true">
			                            <jsp:param name="eventStreamWithVersion"
			                                       value="<%=streamNameWithVersion%>"/>
			                        </jsp:include>
                        <%
                        		} else if (firstMappingTypeName.equals("json")) {
                        %>
			                        <jsp:include page="../hrta_eventbuilder/hrta_json_mapping_ui.jsp" flush="true">
			                            <jsp:param name="eventStreamWithVersion"
			                                       value="<%=streamNameWithVersion%>"/>
			                        </jsp:include>
                        <%
                                }
                            }
                        %>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
        </div>
    </td>
</tr>
<tr>
    <td colspan="2" class="buttonRow">
        <input type="button" value="이벤트 빌더 추가"
               onclick="addEventBuilderViaPopup(document.getElementById('addEventBuilder'),'<%=streamNameWithVersion%>','<%=redirectPage%>')"/>
    </td>
</tr>
</tbody>

</table>
</form>
<% } %>

<div>
    <form id="hiddenForm" name="input" action="" method="post"><input type="HIDDEN"
                                                                     name="streamId"
                                                                     value="<%=streamNameWithVersion%>"/>
    </form>
</div>
</div>
