<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.OutputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.types.OutputEventAdaptorPropertiesDto" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.types.OutputEventAdaptorPropertyDto" %>
<%@ page import="com.toogram.cep.ui.ToogramOutputEventAdaptorUIUtils" %>
<%@ page import="com.toogram.cep.ui.utils.ToogramBundleUtils" %>

<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>


<div id="cols">
	<p id="breadCurmb">
		Home &gt; 아웃풋어답터 &gt; 어답터 내용						
	</p>
	<div class="hgroup">
		<h1>이벤트 아답터 상세 내역 보기</h1>
	</div>					

        <div class="act">
            <div class="detail-view">
    			<table id="eventOutputTable" class="detail">
    				<colgroup>
						<col style="width: 20%;">
						<col>
					</colgroup>  
	                <tbody>
	                <%
	                    String eventName = request.getParameter("eventName");
	                    String eventType = request.getParameter("eventType");
	                    if (eventName != null) {
	                        OutputEventAdaptorManagerAdminServiceStub stub = ToogramOutputEventAdaptorUIUtils.getOutputEventManagerAdminService(config, session, request, response);
	
	
	                        OutputEventAdaptorPropertiesDto eventAdaptorPropertiesDto = stub.getActiveOutputEventAdaptorConfiguration(eventName);
	                        OutputEventAdaptorPropertyDto[] outputEventProperties = eventAdaptorPropertiesDto.getOutputEventAdaptorPropertyDtos();
	
	
	                %>
	                <tr>
	                    <th>이벤트 아답터 명</th>
	                    <td><input type="text" name="eventName" id="eventNameId"
	                               value=" <%=eventName%>"
	                               disabled="true"
	                               style="width:80%"/></td>
	
	                    </td>
	                </tr>
	                <tr>
	                    <th>이벤트 어답터 타입</th>
	                    <td><select name="eventTypeFilter"
	                                disabled="true">
	                        <option><%=eventType%>
	                        </option>
	                    </select>
	                    </td>
	                </tr>
	                <%
	
	                    if (outputEventProperties != null) {
	                        for (OutputEventAdaptorPropertyDto eventAdaptorPropertyDto : outputEventProperties) {
	
	                %>
	
	                <tr>
	                    <th><%=ToogramBundleUtils.getOutputAdaptorBundleText(eventAdaptorPropertyDto.getDisplayName())%></td>
	                    <%
	                        if (!eventAdaptorPropertyDto.getSecured()) {
	                    %>
	                    <td><input type="input" value="<%=eventAdaptorPropertyDto.getValue()!=null?eventAdaptorPropertyDto.getValue():""%>"
	                               disabled="true"
	                               style="width:80%"/>
	                    </td>
	                    <%
	                    } else { %>
	                    <td><input type="password" value="<%=eventAdaptorPropertyDto.getValue()!=null?eventAdaptorPropertyDto.getValue():""%>"
	                               disabled="true"
	                               style="width:80%"/>
	                    </td>
	                    <%
	                        }
	                    %>
	                </tr>
	                <%
	
	                            }
	                        }
	                    }
	
	                %>
	
	                </tbody>
	            </table>
        </div>
    </div>
</div>