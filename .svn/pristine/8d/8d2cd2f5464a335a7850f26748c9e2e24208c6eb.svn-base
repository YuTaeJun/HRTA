<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.client.HiveScriptStoreClient" %>

    <script type="text/javascript">
        function deleteRow(name, msg) {
            CARBON.showConfirmationDialog(msg + "' " + name + " ' ?", function() {
                document.location.href = "../hrta_hive-explorer/hrta_deleteScript.jsp?" + "scriptName=" + name;
            });
        }
    </script>
    <%
	    String serverURL = (String)session.getAttribute("serverURL");
	    
	    String sessionCookie = (String)session.getAttribute("authCookie");
	    
	    //여기서 세션 쿠키가 없다면? 아니지 그러면 에초에 이 페이지는 들어오지 않으니, 해당 부분은 이미 safe!

    	ConfigurationContext configContext =
                (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);

        HiveScriptStoreClient client = new HiveScriptStoreClient(sessionCookie, serverURL, configContext);
        String[] scriptNames = null;

        try {
            scriptNames = client.getAllScriptNames();
        } catch (Exception e) {
    %>
    <script type="text/javascript">
        CARBON.showErrorDialog("스크립트 목록을 읽는 중 에러가 발생하였습니다.");
    </script>
    <%
        }
    %>
    <div id="cols">
	<p id="breadCurmb">
		Home &gt; 데이터 분석 &gt; 하이브 쿼리 스크립트 목록						
	</p>
	<div class="hgroup">
		<h1>현재 사용가능한 Scripts</h1>
	</div>

        <div id="workArea">

            <form id="listScripts" name="listScripts" action="" method="POST">
                <table class="styledVertical">
                    <thead>
                    <tr>
                        <th style="width:200px">분석 스크립트</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>

                    <% if (null != scriptNames) {
                        for (String aName : scriptNames) {
                            if ("true".equals(client.getScriptEditability(aName)))
                            {
                    %>
                    <tr>
                        <td style="width:70%">
                        <label>
                            <%=aName%>
                        </label>
                        </td>                        
                        <td class="fnc-btn">
	                        <a class="edit" href="../hrta_hive-explorer/hrta_hiveexplorer.jsp?mode=edit&editability=true&scriptName=<%=aName%>">
									<i class="fa fa-pencil-square-o"></i>수정</a>
			             	<a href="../hrta_hive-explorer/hrta_execute.jsp?scriptName=<%=aName%>" class="statics"><i class="fa fa-line-chart"></i>실행</a>
							<a href="../hrta_hive-explorer/hrta_scheduleAndSave.jsp?editability=true&scriptName=<%=aName%>" class="tracing"><i class="fa fa-search"></i>스케줄링</a>                    
							<a class="delete" onclick="deleteRow('<%=aName%>','삭제 하시겠습니까?')"><i class="fa fa-trash"></i>삭제</a>
						</td>
                    </tr>
                    <%
                            } else {
                    %>
                    <tr>
                        <td style="width:70%">
                        <label>
                            <%=aName%>
                        </label>
                        </td>                        
                        <td class="fnc-btn">
	                        <a class="edit" href="../hrta_hive-explorer/hrta_hiveexplorer.jsp?mode=edit&editability=false&scriptName=<%=aName%>">
									<i class="fa fa-pencil-square-o"></i>새 스크립트로 복사</a>
			             	<a href="../hrta_hive-explorer/hrta_execute.jsp?scriptName=<%=aName%>" class="statics"><i class="fa fa-line-chart"></i>실행</a>
							<a href="../hrta_hive-explorer/hrta_scheduleAndSave.jsp?editability=false&scriptName=<%=aName%>" class="tracing"><i class="fa fa-search"></i>배치 스케줄링</a>                    
							<a class="delete" onclick="deleteRow('<%=aName%>','삭제 하시겠습니까?')"><i class="fa fa-trash"></i>삭제</a>
						</td>

                    </tr>
                    <%
                            }
                        }
                    } else { %>
                    <tr>
                        <td colspan="2">스크립트가 없습니다.</td>
                    </tr>

                    <% }
                    %>
                    </tbody>
                    <input type="hidden" id="driver" name="driver" value="">
                </table>
            </form>
            <br/>
            <div class="act">
            <p class="fnc-set">
			<a href="../hrta_hive-explorer/hrta_hiveexplorer.jsp?editability=true" class="btn-add"><i class="fa fa-plus-circle fa-2"></i>스크립트 추가</a>
			</p>
			</div>
        </div>
    </div>

