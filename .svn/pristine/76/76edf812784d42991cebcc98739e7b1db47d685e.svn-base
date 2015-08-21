<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderConfigurationDto" %>
<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderConfigurationFileDto" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.InputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.types.InputEventAdaptorConfigurationInfoDto" %>

<script type="text/javascript" src="../ajax/js/prototype.js"></script>

<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>


<script type="text/javascript" src="../hrta_eventbuilder/js/event_builders.js"></script>


<%
    String eventStreamWithVersion = request.getParameter("eventStreamWithVersion");
%>

<%
    String eventBuilderName = request.getParameter("eventBuilder");
    int activeEventBuilders = 0;
    int totalNotDeployedEventBuilders = 0;
    EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
    InputEventAdaptorManagerAdminServiceStub inputAdaptorManagerStub = ToogramEventBuilderUIUtils.getInputEventAdaptorManagerAdminService(config, session, request,response);
    InputEventAdaptorConfigurationInfoDto[] inputEventAdaptorConfigurationInfoDtos = inputAdaptorManagerStub.getAllActiveInputEventAdaptorConfiguration();
    int inputAdaptorCount = 0;
    if(inputEventAdaptorConfigurationInfoDtos != null) {
        inputAdaptorCount = inputEventAdaptorConfigurationInfoDtos.length;
    }
    if (stub != null) {
        if (eventBuilderName != null) {
            stub.undeployActiveEventBuilderConfiguration(eventBuilderName);
%>
<script type="text/javascript">CARBON.showInfoDialog('이벤트 빌더가 성공적으로 삭제되었습니다.');</script>
<%
        }

        EventBuilderConfigurationDto[] deployedEventBuilderConfigFiles = stub.getAllStreamSpecificActiveEventBuilderConfiguration(eventStreamWithVersion);
        if (deployedEventBuilderConfigFiles != null) {
            activeEventBuilders = deployedEventBuilderConfigFiles.length;
        }

        EventBuilderConfigurationFileDto[] inactiveEventBuilderConfigurationFiles = stub.getAllInactiveEventBuilderConfigurations();
        if (inactiveEventBuilderConfigurationFiles != null) {
            totalNotDeployedEventBuilders = inactiveEventBuilderConfigurationFiles.length;
        }
    }

%>

<div id="custom_dcontainer" style="display:none"></div>
<br/>
<div class="act">
<% if (inputAdaptorCount > 0) { %>
<p class="fnc-set">
			<a href="#" class="btn-add" onclick="createPopupEventBuilderUI('<%=eventStreamWithVersion%>')">
			<i class="fa fa-plus-circle fa-2"></i>이벤트 빌더를 통한 외부 이벤트 스트림 송신</a>
</p>
<% } else { %>
<p class="fnc-set">
			<a href="#" class="btn-add" 
			onclick="CARBON.showErrorDialog('활성화된 인풋 이벤트 어답터가 없습니다.\n In-flow를 생성하기 전에 활성화된 인풋 어답터가 있어야 합니다.')">
			<i class="fa fa-plus-circle fa-2"></i>이벤트 빌더를 통한 외부 이벤트 스트림 송신</a>
</p>
<% } %>
<br/> <br/>


<div class="act">
    <%=activeEventBuilders%> 
 	횔성화된 이벤트 빌더 , <% if (totalNotDeployedEventBuilders > 0) { %><a
        href="../hrta_eventbuilder/hrta_inactive_event_builder_files_details.jsp?ordinal=1"><%=totalNotDeployedEventBuilders%>
 	비 활성화된 이벤트 빌더</a><% } else {%><%=totalNotDeployedEventBuilders%>
    	비 활성화된 이벤트 빌더 <% } %>

    <br/> <br/>
    <table class="styledVertical">
        <%
            if (stub != null) {
                EventBuilderConfigurationDto[] eventBuilderConfigurationDtos = stub.getAllStreamSpecificActiveEventBuilderConfiguration(eventStreamWithVersion);
                if (eventBuilderConfigurationDtos != null && eventBuilderConfigurationDtos.length > 0) {

        %>

        <thead>
        <tr>
            <th>이벤트 빌더명</th>
            <th>인풋 이벤트 타입</th>
            <th>인풋 이벤트 어답터 명</th>
            <th>수정</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (EventBuilderConfigurationDto eventBuilderConfigurationDto : eventBuilderConfigurationDtos) {

        %>
        <tr>
            <td>
                <a href="../hrta_eventbuilder/hrta_eventbuilder_details.jsp?ordinal=1&eventBuilderName=<%=eventBuilderConfigurationDto.getEventBuilderConfigName()%>">
                    <%=eventBuilderConfigurationDto.getEventBuilderConfigName()%>
                </a>
            </td>
            <td><%=eventBuilderConfigurationDto.getInputMappingType()%>
            </td>
            <td><%=eventBuilderConfigurationDto.getInputEventAdaptorName()%>
            </td>     
            <td class="fnc-btn">
            
            <% if (eventBuilderConfigurationDto.getStatisticsEnabled()) {%>
                  <div id="disableStat<%= eventBuilderConfigurationDto.getEventBuilderConfigName()%>">
                      <a href="#"
                         onclick="disableBuilderStat('<%= eventBuilderConfigurationDto.getEventBuilderConfigName() %>')"
                         class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
                  </div>
                  <div id="enableStat<%= eventBuilderConfigurationDto.getEventBuilderConfigName()%>"
                       style="display:none;">
                      <a href="#"
                         onclick="enableBuilderStat('<%= eventBuilderConfigurationDto.getEventBuilderConfigName() %>')"
                         class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
                  </div>
              <% } else { %>
                  <div id="enableStat<%= eventBuilderConfigurationDto.getEventBuilderConfigName()%>">
                      <a href="#"
                         onclick="enableBuilderStat('<%= eventBuilderConfigurationDto.getEventBuilderConfigName() %>')"
                         class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
                  </div>
                  <div id="disableStat<%= eventBuilderConfigurationDto.getEventBuilderConfigName()%>"
                       style="display:none">
                      <a href="#"
                         onclick="disableBuilderStat('<%= eventBuilderConfigurationDto.getEventBuilderConfigName() %>')"
                         class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
                  </div>
              <% }
                  if (eventBuilderConfigurationDto.getTraceEnabled()) {%>
                  <div id="disableTracing<%= eventBuilderConfigurationDto.getEventBuilderConfigName()%>">
                      <a href="#"
                         onclick="disableBuilderTracing('<%= eventBuilderConfigurationDto.getEventBuilderConfigName() %>')"
                         class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
                  </div>
                  <div id="enableTracing<%= eventBuilderConfigurationDto.getEventBuilderConfigName()%>"
                       style="display:none;">
                      <a href="#"
                         onclick="enableBuilderTracing('<%= eventBuilderConfigurationDto.getEventBuilderConfigName() %>')"
                         class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
                  </div>
              <% } else { %>
                  <div id="enableTracing<%= eventBuilderConfigurationDto.getEventBuilderConfigName()%>">
                      <a href="#"
                         onclick="enableBuilderTracing('<%= eventBuilderConfigurationDto.getEventBuilderConfigName() %>')"
                         class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
                  </div>
                  <div id="disableTracing<%= eventBuilderConfigurationDto.getEventBuilderConfigName()%>"
                       style="display:none">
                      <a href="#"
                         onclick="disableBuilderTracing('<%= eventBuilderConfigurationDto.getEventBuilderConfigName() %>')"
                         class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
                  </div>                
                <% } %>
            
            
            	<a class="delete" onclick="deleteInFlowEventBuilder('<%=eventStreamWithVersion%>','<%=eventBuilderConfigurationDto.getEventBuilderConfigName()%>')">
            	<i class="fa fa-trash"></i>삭제</a>
                
                <a class="edit" href="../hrta_eventbuilder/hrta_edit_event_builder_details.jsp?ordinal=1&eventBuilderName=<%=eventBuilderConfigurationDto.getEventBuilderConfigName()%>">
						<i class="fa fa-pencil-square-o"></i>수정</a>						
            </td>

        </tr>
        </tbody>

        <%
            }
        } else {
        %>

        <tbody>
        <tr>
        	<td>	    
				<div class="act">
					사용 가능 빌더가 없습니다.
				</div>
			</td>		
         </tr>
        <tr>
        </tbody>

        <%
                }
            }
        %>
    </table>
    <form id="deleteForm1" name="input" action="" method="post">
    	<input type="hidden" name="eventBuilder" value=""/>
        <input type="HIDDEN" name="eventStreamWithVersion" value="<%=eventStreamWithVersion%>"/>
    </form>
</div>    
</div>

