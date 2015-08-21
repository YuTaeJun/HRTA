<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.AxisFault" %>
<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.apache.commons.logging.Log" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.analytics.hive.stub.HiveScriptStoreServiceHiveScriptStoreException" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.client.HiveScriptStoreClient" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>

<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServlet" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.rmi.RemoteException" %>

<%

	String serverURL = (String)session.getAttribute("serverURL");    
	String sessionCookie = (String)session.getAttribute("authCookie");     
	
	ConfigurationContext configContext =
	        (ConfigurationContext) getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
	
	String scriptName = request.getParameter("scriptName");
	String editability = request.getParameter("editability");
	String scriptContent = request.getParameter("queries");
	String cron = request.getParameter("cronExp");
	if(null==cron) cron ="";
	
	PrintWriter writer = null;
	
	try {
		writer = response.getWriter();
        try {
            HiveScriptStoreClient client = new HiveScriptStoreClient(sessionCookie, serverURL, configContext);
            if (null == scriptContent) {
                scriptContent = client.getScript(scriptName);
            }
            client.saveScriptWithEditability(scriptName, scriptContent, cron, editability);
            writer.print("하이브 스크립트 업데이트 완료 : " + scriptName);
        } catch (AxisFault axisFault) {
        	writer.print("스크립트 업데이트 에러");
        } catch (RemoteException e) {
        	writer.print("스크립트 업데이트 에러");
        } catch (HiveScriptStoreServiceHiveScriptStoreException e) {
        	writer.print("스크립트 업데이트 에러");
        } catch (IOException e) {
        	writer.print("스크립트 업데이트 에러");
        }
    } catch (IOException e) {
        //log.error("Error while writing to the response..", e);
    }

%>
