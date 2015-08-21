<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.AxisFault" %>
<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.analytics.hive.stub.HiveScriptStoreServiceHiveScriptStoreException" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.client.HiveScriptStoreClient" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>

<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServlet" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>

<%

	String serverURL = (String)session.getAttribute("serverURL");    
	String sessionCookie = (String)session.getAttribute("authCookie");        
	
	ConfigurationContext configContext =
	        (ConfigurationContext) getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
	
	
	
	String scriptName = request.getParameter("scriptName");
	PrintWriter writer = null;
	try {
	    HiveScriptStoreClient client = new HiveScriptStoreClient(sessionCookie, serverURL, configContext);
	    boolean exists = false;
	    if (scriptName != null && !scriptName.equals("")) {
	        String[] allScripts = client.getAllScriptNames();
	        if(null != allScripts){
	            for(String aScript: allScripts){
	                if(aScript.equalsIgnoreCase(scriptName)){
	                   exists = true;
	                }
	            }
	        }
	    }
	    
	    writer = response.getWriter();
	    
	    if(exists){
	    	writer.print("true");
	    }else{
	    	writer.print("false");
	    }
	} catch (IOException e) {
		//msg ="Error validating the script name";
	} catch (HiveScriptStoreServiceHiveScriptStoreException e) {
		//msg ="Error validating the script name";
	}

%>

