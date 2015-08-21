<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>
<%@ page import="com.toogram.cep.ui.ToogramEventStreamUIUtils" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.types.EventStreamDefinitionDto" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.types.EventStreamAttributeDto" %>


<script type="text/javascript" src="../hrta_eventstream/js/event_stream.js"></script>
<script type="text/javascript" src="../hrta_eventstream/js/registry-browser.js"></script>
<link type="text/css" href="../hrta_eventstream/css/eventStream.css" rel="stylesheet"/>

<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>

<script type="text/javascript" src="../hrta_eventstream/js/create_eventStream_helper.js"></script>
<script type="text/javascript" src="../ajax/js/prototype.js"></script>

<% String eventStreamWithVersion = request.getParameter("eventStreamWithVersion");

    EventStreamAdminServiceStub eventStreamAdminServiceStub = ToogramEventStreamUIUtils.getEventStreamAdminService(config, session, request ,response);
    EventStreamDefinitionDto streamDefinitionDto = eventStreamAdminServiceStub.getStreamDefinitionDto(eventStreamWithVersion);

%>

    <div id="cols">
        <p id="breadCurmb">
		Home &gt; 이벤트 스트림 &gt; 이벤트 스트림 수정								
		</p>
		<div class="hgroup">
			<h1>이벤트 스트림 수정</h1>
		</div>
        <div class="act">

<form name="inputForm" action="../hrta_eventstream/hrta_eventStream.jsp? method=" post" id="editEventStream">
<div class="act">
<table id="eventStreamEdit" class="styledVertical">
	<thead>
		<tr>
			<th>이벤트 스트림 상세 내역 입력</th>
		</tr>
	</thead>




<tbody>
<tr>
<td>

<div class="detail-view">
	<table id="eventStreamInputTable" class="detail">
		<colgroup>
			<col style="width: 20%;">
			<col>
		</colgroup>

	<tbody>
		<tr>
    		<th>이벤트 스트림 명
    		<span class="required">*</span></th>    
    		<td>
    			<input type="text" name="eventStreamName" id="eventStreamNameId" value="<%=streamDefinitionDto.getName()%>" style="width:80%"/>
        		<p><small>이벤트 스트림 명을 입력하세요</small></p>
    		</td>
		</tr>
		<tr>
    		<th>이벤트 스트림 Version
    		<span class="required">*</span></th>    
    		<td>
    			<input type="text" name="eventStreamVersion" id="eventStreamVersionId" value="<%=streamDefinitionDto.getVersion()%>" style="width:80%"/>
        		<p><small>이벤트 스트림 버전을 입력하세요</small></p>
    		</td>
		</tr>
		<tr>
    		<th>이벤트 스트림 설명
    		<td>
    			<input type="text" name="eventStreamDescription" id="eventStreamDescription" 
    			value="<%=streamDefinitionDto.getDescription() != null ? streamDefinitionDto.getDescription() : "" %>" style="width:80%"/>
        		<p><small>이벤트 스트림에 대한 상세 설명</small></p>
    		</td>
		</tr>
		<tr>
    		<th>이벤트 스트림 Nick-name
    		<td>
    			<input type="text" name="eventStreamNickName" id="eventStreamNickName" 
    			value="<%=streamDefinitionDto.getNickName() != null ? streamDefinitionDto.getNickName() : "" %>" style="width:80%"/>
        		<p><small>이벤트 스트림에 대한 Nick-name 입력</small></p>
    		</td>
		</tr>

<tr>
<td colspan="2">
<div id="innerDiv4">
<div id="act">
            <table class="line-tb">
            	<thead>
					<tr>
						<th colspan="2">스트림 속성 값 입력</th>
					</tr>
				</thead>         	
                <tbody>
<tr name="streamAttributes">
    <td colspan="2">

        <h3>Meta Data 속성값 입력</h3>
        <% if (streamDefinitionDto.getMetaData() != null && streamDefinitionDto.getMetaData().length > 0) {

        %>
        <table class="styledVertical" id="outputMetaDataTable">
            <thead>
            <th>속셩명</th>
            <th>속성 타입</th>
            <th>수정</th>
            </thead>
            <% for (EventStreamAttributeDto metaData : streamDefinitionDto.getMetaData()) {
            %>
            <tr>
                <td><%=metaData.getAttributeName()%>
                </td>
                <td><%=metaData.getAttributeType()%>
                </td>
                <td class="fnc-btn">
                <a class="delete" onclick="removeStreamAttribute(this,'meta')"><i class="fa fa-trash"></i>삭제</a></td>
            </tr>
            <%}%>
        </table>
        <%
        } else

        {
        %>
        <table class="styledVertical" id="outputMetaDataTable" style="display:none">
	        <thead>
	        <th>속셩명</th>
	        <th>속성 타입</th>
	        <th>수정</th>
	        </thead>
        </table>
        <div id="noOutputMetaData">
                        <p class="desc">Meta Data 속성이 지정되지 않았습니다.</p>
                        </div>
        <% } %>
        <br/>
        <table id="addMetaData" class="styledVertical">
             <tbody>
             <tr>
                 <td>어프리뷰트 명 :</td>
                 <td>
                     <input type="text" id="outputMetaDataPropName"/>
                 </td>
                 <td>어트리뷰트 타입 :</td>
                 <td>
                     <select id="outputMetaDataPropType">
                         <option value="int">int</option>
                         <option value="long">long</option>
                         <option value="double">double</option>
                         <option value="float">float</option>
                         <option value="string">string</option>
                         <option value="boolean">boolean</option>
                     </select>
                 </td>
                 <td><input type="button" class="btn" onclick="addStreamAttribute('Meta')" value="추가"/></td>
             </tr>
             </tbody>
         </table>
    </td>
</tr>


<tr name="streamAttributes">
    <td colspan="2">

        <h3>Correlation Data 속성값 입력</h3>
        <% if (streamDefinitionDto.getCorrelationData() != null && streamDefinitionDto.getCorrelationData().length > 0) {

        %>
        <table class="styledVertical"
               id="outputCorrelationDataTable">
            <thead>
                            <th>속셩명</th>
                            <th>속성 타입</th>
                            <th>수정</th>
                            </thead>
            <% for (EventStreamAttributeDto correlationData : streamDefinitionDto.getCorrelationData()) {
            %>
            <tr>
                <td><%=correlationData.getAttributeName()%>
                </td>
                <td><%=correlationData.getAttributeType()%>
                </td>
                <td class="fnc-btn">
                <a class="delete" onclick="removeStreamAttribute(this,'Correlation')"><i class="fa fa-trash"></i>삭제</a></td>
                </td>
            </tr>
            <%}%>
        </table>
        <% } else { %>
        <table class="styledVertical" id="outputCorrelationDataTable" style="display: none">
            <thead>
            	<th>속셩명</th>
                <th>속성 타입</th>
                <th>수정</th>
            </thead>
        </table>
        <div id="noOutputCorrelationData">
                        	<p class="desc">Correlation Data 속성이 지정되지 않았습니다.</p>
                        </div>	
        <% } %>
        <br/>
        <table id="addCorrelationData" class="styledVertical">
            <tbody>
                            <tr>
                                <td>어프리뷰트 명 :</td>
                                <td>
                                    <input type="text" id="outputCorrelationDataPropName"/>
                                </td>
                                <td>어트리뷰트 타입 :</td>
                                <td>
                                    <select id="outputCorrelationDataPropType">
                                        <option value="int">int</option>
                                        <option value="long">long</option>
                                        <option value="double">double</option>
                                        <option value="float">float</option>
                                        <option value="string">string</option>
                                        <option value="boolean">boolean</option>
                                    </select>
                                </td>
                                <td><input type="button" class="btn" onclick="addStreamAttribute('Correlation')" value="추가"/></td>                               
                            </tr>
                            </tbody>
        </table>
    </td>
</tr>

<tr name="streamAttributes">
    <td colspan="2">

        <h3>Payload Data 속성값 입력</h3>
        <% if (streamDefinitionDto.getPayloadData() != null && streamDefinitionDto.getPayloadData().length > 0) {

        %>
        <table class="styledVertical" id="outputPayloadDataTable">
            <thead>
            <th>속셩명</th>
            <th>속성 타입</th>
            <th>수정</th
            </thead>

            <% for (EventStreamAttributeDto payloadData : streamDefinitionDto.getPayloadData()) {
            %>
            <tr>
                <td><%=payloadData.getAttributeName()%>
                </td>
                <td><%=payloadData.getAttributeType()%>
                </td>
                <td class="fnc-btn">
                <a class="delete" onclick="removeStreamAttribute(this,'Payload')"><i class="fa fa-trash"></i>삭제</a></td>
                </td>
            </tr>
            <%}%>

        </table>
        <% } else { %>
        <table class="styledVertical"
               id="outputPayloadDataTable" style="display: none;">
            <thead>
            <th>속셩명</th>
            <th>속성 타입</th>
            <th>수정</th
            </thead>
        </table>
        <div id="noOutputPayloadData">
       		<p class="desc">Payload Data 속성이 지정되지 않았습니다.</p>
       </div>
        <% } %>
		<br/>
        <table id="addPayloadData" class="styledVertical">
            <tbody>
                            <tr>
                                <td>어프리뷰트 명 :</td>
                                <td>
                                    <input type="text" id="outputPayloadDataPropName"/>
                                </td>
                                <td>어트리뷰트 타입 :</td>
                                <td>
                                    <select id="outputPayloadDataPropType">
                                        <option value="int">int</option>
                                        <option value="long">long</option>
                                        <option value="double">double</option>
                                        <option value="float">float</option>
                                        <option value="string">string</option>
                                        <option value="boolean">boolean</option>
                                    </select>
                                </td>
                                <td><input type="button" class="btn" onclick="addStreamAttribute('Payload')" value="추가"/></td>
                            </tr>
                            </tbody>
                        </table>
        </td>
                </tr>
                </tbody>
            </table>
        </div>
    </td>
</tr>
</tbody>
</table>
</div>
</td>
							</tr>					
						</tbody>
					</table>
				</div>				
                
	            <input type="button" class="btn" value="추가" onclick="addEventStream(document.getElementById('editEventStream'),'edit', '<%=eventStreamWithVersion%>')"/>
				
            </form>
        </div>
    </div>
