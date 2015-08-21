<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.InputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.types.InputEventAdaptorFileDto" %>
<%@ page import="com.toogram.cep.ui.ToogramInputEventAdaptorUIUtils" %>


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
            InputEventAdaptorManagerAdminServiceStub stub = ToogramInputEventAdaptorUIUtils.getInputEventManagerAdminService(config, session, request,response);
            stub.undeployInactiveInputEventAdaptorConfiguration(filePath);
    %>
    <script type="text/javascript">CARBON.showInfoDialog('이벤트 파일이 삭제되었습니다.');</script>
    <%
        }
    %>
    
    <div id="cols">
	<p id="breadCurmb">
		Home &gt; 인풋어답터 &gt; 어답터 추가						
	</p>
	<div class="hgroup">
		<h1>비 활성화된 인풋 이벤트 어답터 목록</h1>
	</div>					

        <div id="workArea" class="act">

            <table class="styledVertical">

                <%
                    InputEventAdaptorManagerAdminServiceStub stub = ToogramInputEventAdaptorUIUtils.getInputEventManagerAdminService(config, session, request,response);
                    InputEventAdaptorFileDto[] eventDetailsArray = stub.getAllInactiveInputEventAdaptorConfigurationFile();
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
                    for (InputEventAdaptorFileDto inputEventAdaptorFile : eventDetailsArray) {

                %>

                <tbody>
                <tr>
                    <td>
                        <%=inputEventAdaptorFile.getFileName()%>
                    </td>
                    <td><%=inputEventAdaptorFile.getEventAdaptorName()%>
                    </td>
                    <td class="fnc-btn">
                        <a class="delete" onclick="doDelete('<%=inputEventAdaptorFile.getFileName()%>')"><i class="fa fa-trash"></i>삭제</a>
						<a class="edit" href="../hrta_input_adaptor/hrta_edit_event_details.jsp?ordinal=1&eventPath=<%=inputEventAdaptorFile.getFileName()%>">
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
            <form id="deleteForm" name="input" action="" method="post">
            	<input type="HIDDEN" name="filePath" value=""/>
          	</form>
        </div>
	</div>        

