<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="com.toogram.cep.ui.ToogramOutputEventAdaptorUIUtils" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.OutputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.types.OutputEventAdaptorFileDto" %>

    <script type="text/javascript" src="../admin/js/breadcrumbs.js"></script>
    <script type="text/javascript" src="../admin/js/cookies.js"></script>
    <script type="text/javascript" src="../admin/js/main.js"></script>

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
            OutputEventAdaptorManagerAdminServiceStub stub = ToogramOutputEventAdaptorUIUtils.getOutputEventManagerAdminService(config, session, request, response);
            stub.undeployInactiveOutputEventAdaptorConfiguration(filePath);
    %>
    <script type="text/javascript">CARBON.showInfoDialog('Event File successfully deleted.');</script>
    <%
        }
    %>


    <div id="cols">
		<p id="breadCurmb">
			Home &gt; 아웃풋어답터 &gt; 어답터 추가						
		</p>
		<div class="hgroup">
			<h1>비 활성화된 아웃풋 이벤트 어답터 목록</h1>
		</div>		
	
        <div id="workArea" class="act">

            <table class="styledVertical">

                <%
                    OutputEventAdaptorManagerAdminServiceStub stub = ToogramOutputEventAdaptorUIUtils.getOutputEventManagerAdminService(config, session, request, response);
                    OutputEventAdaptorFileDto[] eventDetailsArray = stub.getAllInactiveOutputEventAdaptorConfiguration();
                    if (eventDetailsArray != null) {
                %>
                <thead>
                <tr>
                    <th>파일명</th>
                    <th>이벤트 명</th>
                    <th>수정</th>
                </tr>
                </thead>
                <%
                    for (OutputEventAdaptorFileDto outputEventAdaptorFile : eventDetailsArray) {

                %>

                <tbody>
                <tr>
                    <td>
                        <%=outputEventAdaptorFile.getFileName()%>
                    </td>
                    <td><%=outputEventAdaptorFile.getEventAdaptorName()%>
                    </td>
                    <td class="fnc-btn">
                        <a class="delete" onclick="doDelete('<%=outputEventAdaptorFile.getFileName()%>')"><i class="fa fa-trash"></i>삭제</a>
						<a class="edit" href="../hrta_output_adaptor/hrta_edit_event_details.jsp?ordinal=1&eventPath=<%=outputEventAdaptorFile.getFileName()%>">
						<i class="fa fa-pencil-square-o"></i>수정</a>
                    </td>

                </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>

        <div>
            <form id="deleteForm" name="input" action="" method="get">
            	<input type="HIDDEN" name="filePath" value=""/>
           	</form>
        </div>
        
	</div>