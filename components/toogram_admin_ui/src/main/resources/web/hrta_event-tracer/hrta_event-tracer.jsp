<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.event.tracer.ui.client.EventTracerAdminServiceClient" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<script src="../carbon/global-params.js" type="text/javascript"></script>
<%

	//url 받아오고, 쿠키 받아오고
	//String backendServerURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
	
	String serverURL = (String)session.getAttribute("serverURL");	    
	String sessionCookie = (String)session.getAttribute("authCookie");
    ConfigurationContext configContext =
            (ConfigurationContext) config.getServletContext()
                    .getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);

    EventTracerAdminServiceClient client;
    String[] logs = new String[0];
    try {
        client = new EventTracerAdminServiceClient(sessionCookie, serverURL, configContext,
                                                  request.getLocale());

        boolean isOperation = request.getParameter("op") != null;
        String opeation = request.getParameter("op");
        if (!isOperation) {
            String []returnLogs = client.getTraceLogs();
            if (!(returnLogs != null && returnLogs.length == 1 && (returnLogs[0] == null ||
                    returnLogs[0].equals("")))) {
                logs = returnLogs;
            }
        } else {
            if (opeation.equals("search")) {
                String key = request.getParameter("key");
                String ignoreCase = request.getParameter("ignoreCase");

                if (key == null) {
                    key = "";
                }

                boolean igCase = false;
                if (ignoreCase != null) {
                    igCase = Boolean.parseBoolean(ignoreCase);
                }
                String []returnLogs = client.searchLogs(key, igCase);
                if (!(returnLogs != null && returnLogs.length == 1 && (returnLogs[0] == null ||
                        returnLogs[0].equals("")))) {
                    logs = returnLogs;
                }
            } else if (opeation.equals("clear")) {
                client.clearLogs();
                String []returnLogs = client.getTraceLogs();
                if (!(returnLogs != null && returnLogs.length == 1 && (returnLogs[0] == null ||
                        returnLogs[0].equals("")))) {
                    logs = returnLogs;
                }
            }
        }
    } catch (Exception e) {
%>
<script type="text/javascript">
   window.location.href = "../cep-admin/error.jsp";
</script>
<%
    }
%>

<script type="text/javascript">

wso2.wsf.Util.initURLs();

var frondendURL = wso2.wsf.Util.getServerURL() + "/";

function getResponseValue(responseXML) {
    var returnElementList = responseXML.getElementsByTagName("ns:return");
        // Older browsers might not recognize namespaces (e.g. FF2)
    if (returnElementList.length == 0)
        returnElementList = responseXML.getElementsByTagName("return");
    var returnElement = returnElementList[0];

    return returnElement.firstChild.nodeValue;
}

function clearAll() {
    var bodyXML = '<ns1:clearTraceLogs xmlns:ns1="http://tracer.event.carbon.wso2.org">' +
                  '</ns1:clearTraceLogs>';
    var callURL = wso2.wsf.Util.getBackendServerURL(frondendURL, "<%=serverURL%>") +
                  "EventTracerAdminService/clearTraceLogs";
    new wso2.wsf.WSRequest(callURL, "urn:clearTraceLogs", bodyXML, clearTraceLogsCallback, undefined, undefined, getProxyAddress(), false);
}

function clearTraceLogsCallback() {
    var data = this.req.responseXML;
    var responseTextValue = getResponseValue(data);
    if (responseTextValue == "true") {
        var tbody = document.getElementById("traceLogsTableBody");
        var table = tbody.parentNode;
        table.removeChild(tbody);
        var newTBody = document.createElement("tbody");
        var idAttr = document.createAttribute('id');
        idAttr.value = "traceLogsTableBody";
        newTBody.attributes.setNamedItem(idAttr);
        table.appendChild(newTBody);
        var tr = document.createElement("tr");
        var td = document.createElement("td");
        tr.appendChild(td);
        td.innerHTML = '<fmt:message key="no.trace.entries"/>';
        newTBody.appendChild(tr);
        alternateTableRows('traceLogsTable', 'tableEvenRow', 'tableOddRow');
    } else {
        CARBON.showWarningDialog('<fmt:message key="unable.to.clear.logs"/>');
    }
}

function searchTrace() {
    var keyword = document.getElementById("tracekeyword");
    if (keyword != null && keyword != undefined && keyword.value != null &&
        keyword.value != undefined) {
        var ignore_case = document.getElementById("ignore_case");
        var ignoreCase = false;
        if (ignore_case != null) {
            if (ignore_case.checked) {
                ignoreCase = true;
            }
        }
        var bodyXML = '<searchTraceLog xmlns="http://tracer.event.carbon.wso2.org">' +
                      '<keyword>' + keyword.value + '</keyword>' +
                      '<ignoreCase>' + ignoreCase.toString() + '</ignoreCase>' +
                      '</searchTraceLog>';
        var callURL = wso2.wsf.Util.getBackendServerURL(frondendURL, "<%=serverURL%>") +
                      "EventTracerAdminService/searchTraceLog";
        new wso2.wsf.WSRequest(callURL, "urn:searchTraceLog", bodyXML, searchTraceLogsCallback, undefined, undefined, getProxyAddress(), false);
    }
}

function searchTraceLogsCallback() {
    var data = this.req.responseXML;
    var rows = data.getElementsByTagName("ns:return");
    // Older browsers might not recognize namespaces (e.g. FF2)
    if (rows.length == 0) {
        rows = data.getElementsByTagName("return");
    }

    var tbody = document.getElementById("traceLogsTableBody");
    var table = tbody.parentNode;
    table.removeChild(tbody);
    var newTBody = document.createElement("tbody");
    var idAttr = document.createAttribute('id');
    idAttr.value = "traceLogsTableBody";
    newTBody.attributes.setNamedItem(idAttr);
    table.appendChild(newTBody);
    if (rows != null || rows != undefined) {
        for (var i=0; i< rows.length;i++) {
            var tr = document.createElement("tr");
            var td = document.createElement("td");
            tr.appendChild(td);
            td.innerHTML = rows[i].firstChild.nodeValue;
            newTBody.appendChild(tr);
        }
    }
    alternateTableRows('traceLogsTable', 'tableEvenRow', 'tableOddRow');
}

    function searchTraceNew() {
        var key = document.getElementById('tracekeyword').value;
        var ignoreCase = document.getElementById('ignore_case');
        var isIgonreCases = false;
        if (ignoreCase.checked) {
            isIgonreCases = true;
        }
        document.location.href = "../hrta_event-tracer/hrta_event-tracer.jsp?ordinal=1&op=search&key=" + key + "&ignoreCase=" + isIgonreCases;
    }

    function clearAllNew() {
        document.location.href = "../hrta_event-tracer/hrta_event-tracer.jsp?ordinal=1&op=clear";
    }
</script>

<div id="cols">
	<p id="breadCurmb">
		Home &gt; 관리자 Dashboard &gt; 이벤트 추적			
	</p>
	<div class="hgroup">		
		<h1>이벤트 메시지 확인</h1>
	</div>	
    <div id="workArea" class="act">    
	    <div class="detail-view">
	        <table class="detail">
	            <tbody>
	                <tr>
						<th> 이벤트 검색
						</th>
	                    <td><input type="text" id="tracekeyword" value=""/>
	                        <input type="button" class="btn" onclick="searchTraceNew();" value="검색"/>
	                    </td>
	                    <td>
	                    <p class="cls-edt"><input type="checkbox" id="ignore_case" />대/소문자 구분 없음</p>
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	        <div id="tracelogdiv" style="overflow-y:auto;overflow-x:auto;height:500px;margin-top:10px">
	            <table class="detail" id="traceLogsTable" style="width:99% !important">
	                <tbody id="traceLogsTableBody">
	                    <%
	                        for (String log : logs) {
	
	                    %>
	                    <tr>
	                        <td><%=log.replaceAll("\\n","<br/>").replaceAll(" ","&nbsp;")%>
	                        </td>
	                    </tr>
	                    <%
	                        }
	                    %>
	                </tbody>
	            </table>
	        </div>
	        <div class="btn-set">        
	            <input type="button" class="btn" value='목록 지우기' onclick="clearAllNew();"/>
	        </div>
	    </div>
	</div>
</div>
