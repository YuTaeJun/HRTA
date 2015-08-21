<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.wso2.carbon.event.builder.stub.EventBuilderAdminServiceStub" %>
<%@ page import="com.toogram.cep.ui.ToogramEventBuilderUIUtils" %>

<%@ page import="org.wso2.carbon.event.builder.stub.types.EventBuilderConfigurationFileDto" %>


<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>


    <script type="text/javascript">
        function doDelete(ebFilename) {
            var theform = document.getElementById('deleteForm');
            theform.filename.value = ebFilename;
            theform.submit();
        }
    </script>

    <%
        String filename = request.getParameter("filename");
        if (filename != null) {
            EventBuilderAdminServiceStub stub = ToogramEventBuilderUIUtils.getEventBuilderAdminService(config, session, request,response);
            stub.undeployInactiveEventBuilderConfiguration(filename);
    %>
    <script type="text/javascript">CARBON.showInfoDialog('이벤트 빌더가 성공적으로 삭제되었습니다.');</script>
    <%
        }
    %>


    <div id="act">
        <h2>비활성화 이벤트 빌더 목록</h2>

        <div id="act">
            <table class="styledVertical">
                <%
                    EventBuilderAdminServiceStub stub = EventBuilderUIUtils.getEventBuilderAdminService(config, session, request);
                    EventBuilderConfigurationFileDto[] inactiveEventBuilderConfigurations = stub.getAllInactiveEventBuilderConfigurations();
                    if (inactiveEventBuilderConfigurations != null) {
                %>
                <thead>
                <tr>
                    <th>파일명</th>
                    <th>비 활성화 사유</th>
                    <th>수정</th>
                </tr>
                </thead>
                <%
                    for (EventBuilderConfigurationFileDto eventBuilderConfigurationFileDto : inactiveEventBuilderConfigurations) {
                %>
                <tbody>
                <tr>
                    <td>
                        <%=eventBuilderConfigurationFileDto.getFilename()%>
                    </td>
                    <td>
                        <%=eventBuilderConfigurationFileDto.getDeploymentStatusMsg()%>
                    </td>                    
                    <td class="fnc-btn">
		            	<a class="delete" onclick="doDelete('<%=eventBuilderConfigurationFileDto.getFilename()%>')">
		            	<i class="fa fa-trash"></i>삭제</a>
		                
		                <a class="edit" href="../hrta_eventbuilder/hrta_edit_inactive_event_builder_details.jsp?ordinal=1&eventBuilderFilename=<%=eventBuilderConfigurationFileDto.getFilename()%>">
								<i class="fa fa-pencil-square-o"></i>소스보기</a>						
		            </td>

                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
            <div>
                <form id="deleteForm" name="input" action="" method="post">
                	<input type="HIDDEN" name="filename" value=""/></form>
            </div>
        </div>
       </div>