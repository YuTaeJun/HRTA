<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>

<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderConfigurationInfoDto" %>
<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderConfigurationFileDto" %>
<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>

    <script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
    <script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
    <script type="text/javascript" src="../cep-admin/js/main.js"></script>
    <script type="text/javascript" src="../hrta_eventbuilder/js/event_builders.js"></script>

<%
    String eventBuilderName = request.getParameter("eventBuilder");
    int activeEventBuilders = 0;
    int totalNotDeployedEventBuilders = 0;
    EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
    if (stub != null) {
        if (eventBuilderName != null) {
            stub.undeployActiveEventBuilderConfiguration(eventBuilderName);
%>
<script type="text/javascript">CARBON.showInfoDialog('이벤트 빌더가 성공적으로 삭제되었습니다.');</script>
<%
        }

        EventBuilderConfigurationInfoDto[] deployedEventBuilderConfigFiles = stub.getAllActiveEventBuilderConfigurations();
        if (deployedEventBuilderConfigFiles != null) {
            activeEventBuilders = deployedEventBuilderConfigFiles.length;
        }

        EventBuilderConfigurationFileDto[] inactiveEventBuilderConfigurations = stub.getAllInactiveEventBuilderConfigurations();
        if (inactiveEventBuilderConfigurations != null) {
            totalNotDeployedEventBuilders = inactiveEventBuilderConfigurations.length;
        }
    }

%>
  <%=activeEventBuilders%> 횔성화된 이벤트 빌더 , <% if (totalNotDeployedEventBuilders > 0) { %><a
        href="../hrta_eventbuilder/hrta_inactive_event_builder_files_details.jsp?ordinal=1"><%=totalNotDeployedEventBuilders%>
    비 활성화된 이벤트 빌더</a><% } else {%><%=totalNotDeployedEventBuilders%>
    비 활성화된 이벤트 빌더 <% } %>

    <br/> <br/>
    <table class="styledVertical">
        <%
            if (stub != null) {
                EventBuilderConfigurationInfoDto[] eventBuilderConfigurationDtos = stub.getAllActiveEventBuilderConfigurations();
                if (eventBuilderConfigurationDtos != null && eventBuilderConfigurationDtos.length > 0) {

        %>

        <thead>
        <tr>
            <th>이벤트 빌더명</th>
            <th>인풋 이벤트 타입</th>
            <th>인풋 이벤트 어답터 명</th>
            <th>스트림 아이디</th>
            <th>수정</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (EventBuilderConfigurationInfoDto eventBuilderConfigurationDto : eventBuilderConfigurationDtos) {

        %>
        <tr>
            <td>
                <a href="../hrta_eventbuilder/hrta_eventbuilder_details.jsp?ordinal=1&eventBuilderName=<%=eventBuilderConfigurationDto.getEventBuilderName()%>">
                    <%=eventBuilderConfigurationDto.getEventBuilderName()%>
                </a>
            </td>
            <td><%=eventBuilderConfigurationDto.getInputMappingType()%>
            </td>
            <td><%=eventBuilderConfigurationDto.getInputEventAdaptorName()%>
            </td>
            <td><%=eventBuilderConfigurationDto.getToStreamId()%>
            </td>            
            <td class="fnc-btn">
            
              <% if (eventBuilderConfigurationDto.getEnableStats()) {%>
                  <div id="disableStat<%= eventBuilderConfigurationDto.getEventBuilderName()%>">
                      <a href="#"
                         onclick="disableBuilderStat('<%= eventBuilderConfigurationDto.getEventBuilderName() %>')"
                         class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
                  </div>
                  <div id="enableStat<%= eventBuilderConfigurationDto.getEventBuilderName()%>"
                       style="display:none;">
                      <a href="#"
                         onclick="enableBuilderStat('<%= eventBuilderConfigurationDto.getEventBuilderName() %>')"
                         class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
                  </div>
              <% } else { %>
                  <div id="enableStat<%= eventBuilderConfigurationDto.getEventBuilderName()%>">
                      <a href="#"
                         onclick="enableBuilderStat('<%= eventBuilderConfigurationDto.getEventBuilderName() %>')"
                         class="statics"><i class="fa fa-line-chart"></i>통계 활성화</a>
                  </div>
                  <div id="disableStat<%= eventBuilderConfigurationDto.getEventBuilderName()%>"
                       style="display:none">
                      <a href="#"
                         onclick="disableBuilderStat('<%= eventBuilderConfigurationDto.getEventBuilderName() %>')"
                         class="statics"><i class="fa fa-line-chart"></i>통계 비활성화</a>
                  </div>
              <% }
                  if (eventBuilderConfigurationDto.getEnableTracing()) {%>
                  <div id="disableTracing<%= eventBuilderConfigurationDto.getEventBuilderName()%>">
                      <a href="#"
                         onclick="disableBuilderTracing('<%= eventBuilderConfigurationDto.getEventBuilderName() %>')"
                         class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
                  </div>
                  <div id="enableTracing<%= eventBuilderConfigurationDto.getEventBuilderName()%>"
                       style="display:none;">
                      <a href="#"
                         onclick="enableBuilderTracing('<%= eventBuilderConfigurationDto.getEventBuilderName() %>')"
                         class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
                  </div>
              <% } else { %>
                  <div id="enableTracing<%= eventBuilderConfigurationDto.getEventBuilderName()%>">
                      <a href="#"
                         onclick="enableBuilderTracing('<%= eventBuilderConfigurationDto.getEventBuilderName() %>')"
                         class="tracing"><i class="fa fa-search"></i>추적 활성화</a>
                  </div>
                  <div id="disableTracing<%= eventBuilderConfigurationDto.getEventBuilderName()%>"
                       style="display:none">
                      <a href="#"
                         onclick="disableBuilderTracing('<%= eventBuilderConfigurationDto.getEventBuilderName() %>')"
                         class="tracing"><i class="fa fa-search"></i>추적 비활성화</a>
                  </div>                
                <% } %>
            
            	<a class="delete" onclick="deleteEventBuilder('<%=eventBuilderConfigurationDto.getEventBuilderName()%>')">
            	<i class="fa fa-trash"></i>삭제</a>                
                <a class="edit" href="../hrta_eventbuilder/hrta_edit_event_builder_details.jsp?ordinal=1&eventBuilderName=<%=eventBuilderConfigurationDto.getEventBuilderName()%>">
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
    
    <form id="deleteForm" name="input" action="" method="post">
    	<input type="hidden" name="eventBuilder" value=""/></form>

