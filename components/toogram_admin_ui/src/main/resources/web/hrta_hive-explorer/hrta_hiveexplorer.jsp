<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.client.HiveScriptStoreClient" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<script src="../editarea/edit_area_full.js" type="text/javascript"></script>
<script type="text/javascript" src="../ajax/js/prototype.js"></script>

<link rel="stylesheet" type="text/css" href="../hrta_hive-explorer/css/hive-explorer-styles.css">

<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>

<script type="text/javascript">
    YAHOO.util.Event.onDOMReady(function() {
        editAreaLoader.init({
                    id : "allcommands"
                    ,syntax: "sql"
                    ,start_highlight: true
                });
    });
</script>

<%
    String scriptName = "";
    String scriptContent = "";
    String cron = "";
    String mode = request.getParameter("mode");
    String editability = "true";
    if(request.getParameter("editability") != null && !"".equals(request.getParameter("editability"))){
        editability = request.getParameter("editability");
    }
    String isSchedulingCanceled = "false";
    if("true".equals(request.getParameter("schedulingCanceled"))){
        isSchedulingCanceled  = "true";
    }
    int max = 40;
    boolean scriptNameExists = false;
    if (request.getParameter("scriptName") != null && !request.getParameter("scriptName").equals("")) {
        scriptName = request.getParameter("scriptName");
    }
    if (null != mode && mode.equalsIgnoreCase("edit")) {
        scriptNameExists = true;
    } else {
        scriptNameExists = false;
        mode = "";
    }
    String requestUrl = request.getHeader("Referer");
    boolean isFromScheduling = false;
    if (requestUrl != null && requestUrl.contains("scheduletask.jsp")) {
        isFromScheduling = true;
    }
    if (scriptNameExists && !isFromScheduling) {
        try {
            
            String serverURL = (String)session.getAttribute("serverURL");
            
            String sessionCookie = (String)session.getAttribute("authCookie");

            ConfigurationContext configContext =
                    (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);

            HiveScriptStoreClient client = new HiveScriptStoreClient(sessionCookie, serverURL, configContext);
            scriptContent = client.getScript(scriptName);
            cron = client.getCronExpression(scriptName);
            if (scriptContent != null && !scriptContent.equals("")) {
                scriptContent = scriptContent.replace("'", "\'");
            }
        } catch (Exception e) {
            String errorString = e.getMessage();
            CarbonUIMessage.sendCarbonUIMessage(e.getMessage(), CarbonUIMessage.ERROR, request, e);


%>
<script type="text/javascript">
    location.href = "../cep-admin/error.jsp";
	CARBON.showErrorDialog('<%=errorString%>');
</script>
<%
            return;
        }
    }
    if (isFromScheduling) {
        Object content = session.getAttribute("scriptContent" + scriptName);
        if (null != content) {
            scriptContent = content.toString();
        } else {
            scriptContent = "";
        }
        if (null != request.getParameter("cron")) {
            cron = request.getParameter("cron").toString();
        }
        if (scriptContent != null && !scriptContent.equals("")) {
            scriptContent = scriptContent.replace("'", "\'");
        }
    }


%>
<%!
    private String wrapTextInVisibleWidth(String line) {
        int max = 100;
        if (null != line) {
            line = line.trim();
            if (line.length() <= max) {
                return line;
            } else {
                String newLine = "";
                String[] spaceSplit = line.split(" ");
                int count = 0;
                for (String word : spaceSplit) {
                    if (count + word.length() <= max) {
                        newLine += word + " ";
                        count += word.length() + 1;
                    } else {
                        newLine += "\n\t" + word + " ";
                        count = (word + " ").length();
                    }
                }
                return newLine;
            }
        } else {
            return null;
        }


    }
%>
<script type="text/javascript">
    var cron = '<%=cron%>';
    var scriptName = '<%=scriptName%>';
    var editability = '<%=editability%>';
    var saveWithoutPrompt = '<%=isSchedulingCanceled%>';
    var allQueries = '';
    function executeQuery() {
        document.getElementById('hiveResult').innerHTML = '';
        var allQueries = editAreaLoader.getValue("allcommands");
        allQueries = trim(allQueries);
        if (allQueries != '') {
            document.getElementById('middle').style.cursor = 'wait';
            openProgressBar();
            window.location.hash = "scriptResults";
            new Ajax.Request('../hrta_hive-explorer/hrta_queryresults.jsp', {
                        method: 'post',
                        parameters: {queries:allQueries,
                            scriptName: scriptName},
                        onSuccess: function(transport) {
                            document.getElementById('middle').style.cursor = '';
                            closeProgrsssBar();
                            var allPage = transport.responseText;
                            var divText = '<div id="returnedResults">';
                            var closeDivText = '</div>';
                            var temp = allPage.indexOf(divText, 0);
                            var startIndex = temp + divText.length;
                            var endIndex = allPage.indexOf(closeDivText, temp);
                            var queryResults = allPage.substring(startIndex, endIndex);
                            document.getElementById('hiveResult').innerHTML = queryResults;
                        },
                        onFailure: function(transport) {
                            closeProgrsssBar();
                            document.getElementById('middle').style.cursor = '';
                            CARBON.showErrorDialog(transport.responseText);
                        }
                    });

        } else {
            document.getElementById('middle').style.cursor = '';
            var message = "실행할 쿼리가 없습니다";
            CARBON.showErrorDialog(message);
        }
    }

    function trim(text) {
        return text.replace(/^\s+|\s+$/g, "");
    }

    function saveScriptAfterChecking() {
        allQueries = editAreaLoader.getValue("allcommands");
        scriptName = document.getElementById('scriptName').value;
        allQueries = trim(allQueries);
        if (allQueries != "") {
            if (scriptName != "") {
                if("false" != '<%=editability%>') {
                    saveScript();
                } else {
                    if(scriptName != '<%=scriptName%>') {
                        editability = "true";
                        saveScript();
                    } else {
                        var message = "저장할 다른 스크립트 명을 입력하십시오";
                        CARBON.showErrorDialog(message);
                    }
                }

            } else {
                var message = "스크립트 명을 입력하십시오";
                CARBON.showErrorDialog(message);
            }

        } else {
            var message = "쿼리가 비어있습니다";
            CARBON.showErrorDialog(message);
        }
    }

    function saveScript() {
        if (cron != "" || saveWithoutPrompt == "true") {
            checkExistingNameAndSaveScript();
        }
        else {
            document.getElementById('saveWithCron').value = 'true';
            CARBON.showConfirmationDialog("스크립트에 대한 스케쥴링을 하시겠습니까?", function() {
                scheduleTask();
            }, function() {
                checkExistingNameAndSaveScript();
            }, function() {

            });
        }
    }

    function cancelScript() {
        location.href = "../hrta_hive-explorer/hrta_listscripts.jsp";
    }

    function scheduleTask() {
        var allQueries = editAreaLoader.getValue("allcommands");
        document.getElementById('scriptContent').value = allQueries;
        document.getElementById('commandForm').action = "../hrta_hive-explorer/hrta_scheduletask.jsp?mode=" + '<%=mode%>'
                + '&cron=' + '<%=cron%>' + '&editability=' + '<%=editability%>';
        document.getElementById('commandForm').submit();
    }

    function checkExistingNameAndSaveScript() {
        var mode = '<%=mode%>';
        if (mode != 'edit' || (mode == 'edit' && 'false' == '<%=editability%>')) {
            new Ajax.Request('../hrta_hive-explorer/hrta_scriptNameChecker_ajaxprocessor.jsp', {
                        method: 'post',
                        parameters: {scriptName:scriptName},
                        onSuccess: function(transport) {
                            var result = transport.responseText;
                            if (result.indexOf('true') != -1) {
                                var message = "The script name: " + scriptName + '가 데이터베이스에 이미 존재합니다. 다른 이름을 입력사십시오.';
                                CARBON.showErrorDialog(message);
                            } else {
                                sendRequestToSaveScript();
                            }
                        },
                        onFailure: function(transport) {
                            return true;
                        }
                    });
        } else {
            sendRequestToSaveScript();
        }
    }

    function sendRequestToSaveScript() {
        new Ajax.Request('../hrta_hive-explorer/hrta_saveScriptProcessor_ajaxprocessor.jsp', {
                    method: 'post',
                    parameters: {queries:allQueries, scriptName:scriptName, editability:editability,
                        cronExp:cron},
                    onSuccess: function(transport) {
                        var result = transport.responseText;
                        if (result.indexOf('Success') != -1) {
                            CARBON.showInfoDialog(result, function() {
                                location.href = "../hrta_hive-explorer/hrta_listscripts.jsp";
                            }, function() {
                                location.href = "../hrta_hive-explorer/hrta_listscripts.jsp";
                            });

                        } else {
                            CARBON.showErrorDialog(result);
                        }
                    },
                    onFailure: function(transport) {
                        CARBON.showErrorDialog(result);
                    }
                });
    }

    function openProgressBar() {
        var content = '<div id="overlay"><div id="box"><div class="act">' +
                '하이브 쿼리 실행<a href="#" title="Close" class="ui-dialog-titlebar-close" onclick="closeProgrsssBar();">' +
                '<span style="display: none">x</span></a>' +
                '</div><div class="act"><img src="../layout/images/ajax-loader.gif" />' +
                ' 하이브 쿼리 실행...</div></div></div>';
        document.getElementById('dynamic').innerHTML = content;
    }

    function closeProgrsssBar() {
        document.getElementById('dynamic').innerHTML = '';
    }

</script>


<script type="text/javascript">
    $(document).ready(function() {
        document.getElementById('allcommands').focus();
    });
</script>


<div id="middle">
    <div id="dynamic"></div>
    
    <div id="cols">
	<p id="breadCurmb">
		Home &gt; 데이터 분석 &gt; 하이브 쿼리 스크립트 작성						
	</p>
	<div class="hgroup">		
    <%
        if (scriptNameExists) {
    %>
    <h1>Script 에디터<%=" - " + scriptName%>
        <%
        } else {
        %>
        <h1>Script 에디터</h1>
        <%
            }
        %>
    </h1>
   </div>
    <div id="workArea" class="act">
        <form id="commandForm" name="commandForm" action="" method="POST">        
            <table class="styledVertical">
                <thead>
                <tr>
                    <th>스크립트 </th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td style="border-bottom: 0 none!important; border-top: 0 none!important;">
	                   	<p class="fnc-set">
							<span class="side-btn">
								<a href="javascript: scheduleTask();" class="btn-build"><i class="fa fa-bug fa-2"></i>스케줄링</a>
							</span>
						</p>	
					</td>
                </tr>
                <%
                    if (!scriptNameExists) {
                %>
                <tr>
                    <td style="border-bottom: 0 none!important; border-top: 0 none!important;">
                    	<div class="detail-view">
                        <table class="detail">
                            <tbody>
                            <tr>
                                <th>스크립트 명
                                	<span class="required">*</span>
                                </th>
                                <td>
                                    <input type="text" id="scriptName" name="scriptName" size="60"
                                           value="<%=scriptName%>"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        </div>
                    </td>
                </tr>
                <%
                } else if (scriptNameExists && "false".equals(editability)) {
                %>
                <tr>
                    <td style="border-bottom: 0 none!important; border-top: 0 none!important;">
                        <div class="detail-view">
                        <table class="detail">
                            <tbody>
                            <tr>
                                <th>저장할 파일명 
                                <span class="required">*</span>
                                </th>
                                <td>
                                    <input type="text" id="scriptName" name="scriptName" size="60"
                                           value=""/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        </div>
                    </td>
                </tr>
                <%
                } else { %>
                <input type="hidden" value="<%=scriptName%>" name="scriptName" id="scriptName">
                <% }
                %>
                <tr>
                    <td>
                        <table class="styledVertical">
                            <tbody>
                            <tr>
                                <td>
                                    <textarea id="allcommands" name="allcommands" rows="25"
                                              style="width:99%"><%=scriptContent%>
                                    </textarea>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <input class="btn" type="button" onclick="executeQuery()"
                                           value="실행" />
                                    <input class="btn" type="button" onclick="saveScriptAfterChecking()"
                                           value="저장" />
                                    <input type="button" value="취소" onclick="cancelScript()"
                                           class="btn"/>
                                </td>
                            </tr>

                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a name="scriptResults"> 수행 결과</a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="hiveResult" class="scrollable" style="width:99%">
                        </div>
                        <input type="hidden" name="scriptContent" id="scriptContent"/>
                		<input type="hidden" name="saveWithCron" id="saveWithCron"/>
                    </td>                    
                </tr>
                </tbody>                
            </table>
        </form>
    </div>
    </div>
</div>

<script type="text/javascript">
    <%--var commands = '<%=scriptContent%>';--%>
    //  editAreaLoader.setValue('allcommands', commands.replace(/#*#/g, '\'').replace(/$*$/g, '\"'));
    <%--editAreaLoader.setValue('allcommands', '<%=scriptContent%>');--%>
</script>

<%
    String saveWithCron = request.getParameter("saveWithCron");
    if (null != saveWithCron && !saveWithCron.equals("")) {
%>

<script type="text/javascript">
    saveScriptAfterChecking();
</script>
<%
    }
%>