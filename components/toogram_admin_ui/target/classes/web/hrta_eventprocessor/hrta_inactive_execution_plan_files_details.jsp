<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="com.toogram.cep.ui.ToogramEventProcessorUIUtils" %>
<%@ page import="org.wso2.carbon.event.processor.stub.EventProcessorAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.processor.stub.types.ExecutionPlanConfigurationFileDto" %>

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
            EventProcessorAdminServiceStub stub = ToogramEventProcessorUIUtils.getEventProcessorAdminService(config, session, request, response);
            stub.undeployInactiveExecutionPlanConfiguration(filePath);
    %>
    <script type="text/javascript">CARBON.showInfoDialog('실행 계획이 성공적으로 삭제 되었습니다.');</script>
    <%
        }
    %>

    <div id="cols">
        <h2>비활성 실행 계획</h2>

        <div class="act">
            <table class="styledVertical">

                <%
                    EventProcessorAdminServiceStub stub = ToogramEventProcessorUIUtils.getEventProcessorAdminService(config, session, request, response);
                    ExecutionPlanConfigurationFileDto[] execPlanDetailsArray = stub.getAllInactiveExecutionPlanConigurations();
                    if (execPlanDetailsArray != null) {
                %>
                <thead>
                <tr>
                    <th>이름</th>
                    <th>비활성화 사유</th>
                    <th>수정</th>
                </tr>
                </thead>
                <%
                    for (ExecutionPlanConfigurationFileDto executionPlanConfigurationFileDto : execPlanDetailsArray) {

                %>

                <tbody>
                <tr>
                    <td>
                        <%=executionPlanConfigurationFileDto.getFileName()%>
                    </td>
                    <td><%=stub.getExecutionPlanStatusAsString(executionPlanConfigurationFileDto.getFileName())%>
                    </td>
                    
                     <td class="fnc-btn">
			            	<a class="delete" onclick="doDelete('<%=executionPlanConfigurationFileDto.getFileName()%>')">
			            	<i class="fa fa-trash"></i>삭제</a>
			                
			                <a class="edit" href="../hrta_eventprocessor/hrta_edit_execution_plan.jsp?ordinal=1&execPlanPath=<%=executionPlanConfigurationFileDto.getFileName()%>">
									<i class="fa fa-pencil-square-o"></i>수정</a>
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

