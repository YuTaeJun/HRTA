<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.wso2.carbon.event.builder.ui.EventBuilderUIConstants" %>

<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>

<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.types.EventStreamAttributeDto" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.types.EventStreamDefinitionDto" %>

    <%
        String streamId = request.getParameter("streamNameWithVersion");
        EventStreamAdminServiceStub eventStreamAdminServiceStub = ToogramEventBuilderUIUtils.getEventStreamAdminService(config, session, request,response);
        EventStreamDefinitionDto streamDefinitionDto = eventStreamAdminServiceStub.getStreamDefinitionDto(streamId);
    %>

    <table class="line-tb">
    	<thead>
	        <tr fromElementKey="inputWso2EventMapping">
	            <th colspan="2">
	                WSO2 이벤트 매핑
	            </th>
	        </tr>
    	</thead>
        <tbody>
        <tr id="metaMappingRow">
            <td colspan="2">
                <h6>메타 데이터</h6>
                
                <div class="detail-view">
                <table id="addMetaEventDataTable" class="detail">
                    <tbody>
                    <%
                        if (streamDefinitionDto.getMetaData() != null) {
                            int counter = 0;
                            for (EventStreamAttributeDto metaAttribute : streamDefinitionDto.getMetaData()) {
                    %>

                    <tr>
						
                        <td>입력 어트리뷰트 명 : </td>
                        <td>
                            <input type="text" id="metaEventPropertyName_<%=counter%>"/>
                        </td>
                        <td>매핑 대상 :
                        </td>
                        <td>
                            <input type="text" id="metaEventMappedValue_<%=counter%>"
                                   value="<%=EventBuilderUIConstants.META_PREFIX + metaAttribute.getAttributeName()%>"
                                   readonly="true"/>
                        </td>
                        <td>어트리뷰트 Type :
                        </td>
                        <td>
                            <input type="text" id="metaEventType_<%=counter%>"
                                   value="<%=metaAttribute.getAttributeType()%>" readonly="true"/>
                        </td>
                    </tr>
                    <%
                            counter++;
                        }
                    } else {
                    %>
	                    <div class="act" id="noInputMetaEventData">
	                        	설정 대상 메타 데이터가 없습니다
	                    </div>
                    <%
                        }
                    %>
                    </tbody>
                </table>
                </div>
            </td>
        </tr>

        <tr id="correlationMappingRow">
            <td colspan="2">
                <h6>Correlation 데이터</h6>
				<div class="detail-view">
                <table id="addCorrelationEventDataTable" class="detail">
                    <tbody>
                    <%
                        if (streamDefinitionDto.getCorrelationData() != null) {
                            int counter = 0;
                            for (EventStreamAttributeDto correlationAttribute : streamDefinitionDto.getCorrelationData()) {
                    %>

                    <tr>

                        <td>입력 어트리뷰트 명 : 
                        </td>
                        <td>
                            <input type="text" id="correlationEventPropertyName_<%=counter%>"
                                    />
                        </td>
                        <td>매핑 대상 :
                        </td>
                        <td>
                            <input type="text" id="correlationEventMappedValue_<%=counter%>"
                                   value="<%=EventBuilderUIConstants.CORRELATION_PREFIX + correlationAttribute.getAttributeName()%>"
                                   readonly="true"/>
                        </td>
                        <td>어트리뷰트 Type :
                        </td>
                        <td>
                            <input type="text" id="correlationEventType_<%=counter%>"
                                   value="<%=correlationAttribute.getAttributeType()%>" readonly="true"/>
                        </td>
                    </tr>
                    <%
                            counter++;
                        }
                    } else {
                    %>
	                    <div class="act" id="noInputCorrelationEventData">
	                        	설정 대상 Correlation 데이터가 없습니다
	                    </div>
                    <%
                        }
                    %>
                    </tbody>
                </table>
                </div>
            </td>
        </tr>


        <tr id="PayloadMappingRow">
            <td colspan="2">
                <h6>Payload 데이터</h6>

				<div class="detail-view">
                <table id="addPayloadEventDataTable" class="detail">
                    <tbody>
                    <%
                        if (streamDefinitionDto.getPayloadData() != null) {
                            int counter = 0;
                            for (EventStreamAttributeDto payloadAttribute : streamDefinitionDto.getPayloadData()) {
                    %>

                    <tr>

                        <td>입력 어트리뷰트 명 : 
                        </td>
                        <td>
                            <input type="text" id="payloadEventPropertyName_<%=counter%>"
                                    />
                        </td>
                        <td>매핑 대상 :
                        </td>
                        <td>
                            <input type="text" id="payloadEventMappedValue_<%=counter%>"
                                   value="<%=payloadAttribute.getAttributeName()%>" readonly="true"/>
                        </td>
                        <td>어트리뷰트 Type :
                        </td>
                        <td>
                            <input type="text" id="payloadEventType_<%=counter%>"
                                   value="<%=payloadAttribute.getAttributeType()%>" readonly="true"/>
                        </td>
                    </tr>
                    <%
                            counter++;
                        }
                    } else {
                    %>
                    <div class="act" id="noInputPayloadEventData">
                        	설정 대상 Payload 데이터가 없습니다
                    </div>
                    <%
                        }
                    %>
                    </tbody>
                </table>
                </div>
            </td>
        </tr>


        </tbody>
    </table>