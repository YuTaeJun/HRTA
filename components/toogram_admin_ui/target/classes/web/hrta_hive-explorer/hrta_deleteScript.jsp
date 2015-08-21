<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.client.HiveScriptStoreClient" %>
    <%
    String serverURL = (String)session.getAttribute("serverURL");
    
    String sessionCookie = (String)session.getAttribute("authCookie");
	
    ConfigurationContext configContext =
                (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
    
    HiveScriptStoreClient client = new HiveScriptStoreClient(sessionCookie, serverURL, configContext);
    
    String scriptName = request.getParameter("scriptName");
    try {
       client.deleteScript(scriptName);
    } catch (Exception e) {
    %>
    <script type="text/javascript">
        location.href = "../hrta_hive-explorer/hrta_listscripts.jsp";
        CARBON.showErrorDialog('스크립트 삭제 중 오류가 발생하였습니다.');
    </script>
    <%
        }

    %>
    <script type="text/javascript">
    location.href = "../hrta_hive-explorer/hrta_listscripts.jsp";
</script>