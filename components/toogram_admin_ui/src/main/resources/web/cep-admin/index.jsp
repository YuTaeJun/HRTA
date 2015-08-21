<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@page import="org.apache.commons.httpclient.HttpMethod"%>
<%@page import="org.apache.axis2.transport.http.HTTPConstants"%>

<%@ page import="org.wso2.carbon.ui.CarbonUIUtil"%>
<%@ page import="org.wso2.carbon.ui.util.CharacterEncoder" %>
<%@ page import="com.toogram.cep.ui.ToogramAuthentificationUtils" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.CarbonError" %>
<%@ page import="org.wso2.carbon.server.admin.common.IServerAdmin" %>
<%@ page import="org.wso2.carbon.server.admin.common.ServerData" %>
<%@ page import="org.wso2.carbon.server.admin.ui.ServerAdminClient" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.utils.multitenancy.MultitenantConstants" %>


<%@ page import="java.net.*" %> 


<%
	//id-password를 전달 받는다.
	
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	
	//server URL을 일단 수동으로 setting 해 준다.
	String serverURL;
	serverURL = "error";
    try {
    	
    	//이해 할 수 없지만 아래 InetAddress 부분이 진행되지 않으면 unknownhostexception이 발생된다.
        InetAddress inetAddress;
        inetAddress = InetAddress.getLocalHost();
       
        serverURL = request.getServerName().toString();

    } catch (UnknownHostException e) {
        e.printStackTrace();
    }
    
    boolean isGetAuthed = ToogramAuthentificationUtils.getAuthnficationResult(session, 
    		username, password, serverURL);
    
    if(isGetAuthed) {
    	
    	//server_admin 속성 정보를 이용하여 파일을 뿌리면 된다.
    	//이 단계는 쿠키에 데이터가 들어가 있는 단계로, 쿠키를 이용하여 받아오면 된다.
    	serverURL = (String)session.getAttribute("serverURL");	    
	    String sessionCookie = (String)session.getAttribute("authCookie");
    	
	    response.setHeader("Cache-Control", "no-cache");

	    //Obtaining the client-side ConfigurationContext instance.
	    ConfigurationContext configContext = (ConfigurationContext) config.getServletContext()
	            .getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
	    ServerData data;
	    try {
	        IServerAdmin proxy = new ServerAdminClient(configContext, serverURL, sessionCookie, session);
	        data = proxy.getServerData();
	    } catch (Exception e) {
	        CarbonError error = new CarbonError();
	        error.addError(e.getMessage());
	        request.setAttribute(CarbonError.ID, error);
%>
	<jsp:forward page="../cep-admin/error.jsp"/>
<%
	        return;
	    }
%>

<div id="cols">	
	<div class="act">
		<h2>시스템 정보</h2>
		<table class="styledLeft">
			<colgroup>
				<col style="width: 20%;" />
				<col style="width: 80%;" />
			</colgroup>
			<tbody>
				<tr class="tableOddRow">
					<th>Host</th>
					<td><%= data.getServerIp()%></td>
				</tr>
				<tr class="tableEvenRow">
					<th>Server URL</th>
					<td><%= serverURL%></td>
				</tr>
				<tr class="tableOddRow">
					<th>Server Start Time</th>
					<td><%= data.getServerStartTime()%></td>
				</tr>
				<tr class="tableEvenRow">
					<th>System Up Time</th>
					<td>
						<%= data.getServerUpTime().getDays()%>&nbsp;일&nbsp;
			            <%= data.getServerUpTime().getHours()%>&nbsp;시간&nbsp;
			            <%= data.getServerUpTime().getMinutes()%>&nbsp;분&nbsp;
			            <%= data.getServerUpTime().getSeconds()%>&nbsp;초&nbsp;
					</td>
				</tr>
				<tr class="tableOddRow">
					<th>Version</th>
					<td>1.0.0</td>
				</tr>
				<tr class="tableEvenRow">
					<th>Repository Location</th>
					<td><%= data.getRepoLocation()%></td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<%
    } else {
%>    
<div id="cols">	
	<div class="act">
		<div class="hgroup">
			<h1>header</h1>
			<p>페이지를 사용하실 권한이 없습니다.</p>
		</div>
	</div>
</div>
 <%
    }
%>