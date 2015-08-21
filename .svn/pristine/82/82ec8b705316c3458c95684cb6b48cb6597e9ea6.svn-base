<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.analytics.hive.stub.HiveExecutionServiceStub.QueryResult" %>
<%@ page import="org.wso2.carbon.analytics.hive.stub.HiveExecutionServiceStub.QueryResultRow" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.client.HiveExecutionClient" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.client.HiveScriptStoreClient" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>

<%
	String serverURL = (String)session.getAttribute("serverURL");
	
	String sessionCookie = (String)session.getAttribute("authCookie");

	ConfigurationContext configContext =
	            (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
    
    String scriptName = request.getParameter("scriptName");
    try {
        HiveExecutionClient client = new HiveExecutionClient(sessionCookie, serverURL, configContext);
        
        HiveScriptStoreClient storeClient = new HiveScriptStoreClient(sessionCookie, serverURL, configContext);
        
   if (null == scriptName || scriptName.trim().isEmpty() || !storeClient.isTaskRunning(scriptName)) {
        String scriptContent = storeClient.getScript(scriptName);
        QueryResult[] results = null;
        if (scriptContent != null && !scriptContent.equals("")) {
            Pattern regex = Pattern.compile("[^\\s\"']+|\"([^\"]*)\"|'([^']*)'");
            Matcher regexMatcher = regex.matcher(scriptContent);
            String formattedScript = "";
            while (regexMatcher.find()) {
                String temp = "";
                if (regexMatcher.group(1) != null) {
                    // Add double-quoted string without the quotes
                    temp = regexMatcher.group(1).trim().replaceAll(";", "%%");
                    temp = "\"" + temp + "\"";
                } else if (regexMatcher.group(2) != null) {
                    // Add single-quoted string without the quotes
                    temp = regexMatcher.group(2).trim().replaceAll(";", "%%");
                    temp = "\'" + temp + "\'";
                } else {
                    temp = regexMatcher.group().trim();
                }
                formattedScript += temp + " ";
            }
            String[] queries = formattedScript.split(";");
            scriptContent = "";
            for (String aquery : queries) {
                aquery = aquery.trim();
                if (!aquery.equals("")) {
                    aquery = aquery.replaceAll("%%\n", ";");
                    aquery = aquery.replaceAll("%% ", ";");
                    aquery = aquery.replaceAll(" %% ", ";");
                    aquery = aquery.replaceAll("%%", ";");
                    scriptContent = scriptContent + aquery + ";" + "\n";
                }
            }
            results = client.executeScript(scriptName, scriptContent);
        }


%>
<div id="returnedResults">

    <% if (null != results) {
        for (QueryResult result : results) {
    %>

    Query: <span class="queryView"><%=result.getQuery()%></span>
    <%
        QueryResultRow[] rows = result.getResultRows();
        if (null != rows && rows.length > 0) {
            String[] columnNames = result.getColumnNames();
    %>
    <b>Results:
        <table class="styledVertical">
            <tbody>

            <tr>
                <% for (String aColumnName : columnNames) {
                %>

                <td><b><%=aColumnName%>
                </b>
                </td>

                <% }

                %>
            </tr>
            <%
                for (QueryResultRow aRow : rows) {

            %>
            <tr>

                <%
                    String[] colValues = aRow.getColumnValues();
                    for (String aValue : colValues) {
                %>
                <td><%=aValue%>
                </td>

                <% }
                %>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
        <br/>
        <br/>
        <span><%=rows.length%> 개의 결과값이 있습니다.</span><br/>
            <% } else {
        %>
        <br/>
        <br/>
        <span>쿼리 수행되었습니다.</span>
        <br/>
            <%
                }  %>
        <hr color="#888888"/>
            <%
            }
            }
        %>
</div>
<%
} else {
%>
<div id="returnedResults">
    <span class="errorView"> <b>WARNING: </b> Scheduled task for the script : <%=scriptName%> is already running.
        Please try again after the scheduled task is completed.</span>
</div>
<% }
} catch (Exception e) {
%>
<div id="returnedResults">
    <span class="errorView"> <b>ERROR: </b><%=e.getMessage()%> </span>
</div>

<% }
%>
