<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>

<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.formatter.stub.types.EventFormatterConfigurationFileDto" %>

<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

    <script type="text/javascript">
        function doDelete(filePath) {
            var theform = document.getElementById('deleteForm');
            theform.filePath.value = filePath;
            theform.submit();
        }
    </script>
    <%
        String filePath = request.getParameter("filePath");
        if (filePath != null) {
            EventFormatterAdminServiceStub stub = EventFormatterUIUtils.getEventFormatterAdminService(config, session, request);
            stub.undeployInactiveEventFormatterConfiguration(filePath);
    %>
    <script type="text/javascript">CARBON.showInfoDialog('이벤트 포멧터가 성공적으로 삭제되었습니다.');</script>
    <%
        }
    %>


    <div id="act">
        <h2>비활성화 이벤트 포멧터 목록</h2>
        
        <div id="act">
            <table class="styledVertical">

                <%
                    EventFormatterAdminServiceStub stub = EventFormatterUIUtils.getEventFormatterAdminService(config, session, request);
                    EventFormatterConfigurationFileDto[] eventFormatterDetailsArray = stub.getAllInactiveEventFormatterConfiguration();
                    if (eventFormatterDetailsArray != null) {
                %>
                <thead>
                <tr>
                    <th>파일명</th>
                    <th>비 활성화 사유</th>
                    <th>수정</th>
                </tr>
                </thead>
                <%
                    for (EventFormatterConfigurationFileDto eventFormatterFile : eventFormatterDetailsArray) {

                %>

                <tbody>
                <tr>
                    <td>
                        <%=eventFormatterFile.getFileName()%>
                    </td>
                    <td><%=eventFormatterFile.getDeploymentStatusMsg()%>
                    </td>
                    
                    <td class="fnc-btn">
		            	<a class="delete" onclick="doDelete('<%=eventFormatterFile.getFileName()%>')">
		            	<i class="fa fa-trash"></i>삭제</a>		                
		                <a class="edit" 
		                href="../hrta_edit_event_formatter_details.jsp?ordinal=1&eventFormatterPath=<%=eventFormatterFile.getFileName()%>">
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
                	<input type="HIDDEN" name="filePath" value=""/></form>
            </div>
        </div>
       </div>


        