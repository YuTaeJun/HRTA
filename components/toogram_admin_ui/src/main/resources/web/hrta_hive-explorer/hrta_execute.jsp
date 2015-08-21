<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.client.HiveScriptStoreClient" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>


<script src="../editarea/edit_area_full.js" type="text/javascript"></script>
<script type="text/javascript" src="../ajax/js/prototype.js"></script>

<link rel="stylesheet" type="text/css" href="../hrta_hive-explorer/css/hive-explorer-styles.css">

<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>

    <%
        String scriptName = "";
        String scriptContent = "";
        scriptName = request.getParameter("scriptName");

        try {
        	String serverURL = (String)session.getAttribute("serverURL");
    	    
    	    String sessionCookie = (String)session.getAttribute("authCookie");
			
    	    ConfigurationContext configContext =
                    (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
            HiveScriptStoreClient client = new HiveScriptStoreClient(sessionCookie, serverURL, configContext);
        } catch (Exception e) {
            String errorString = e.getMessage();
            CarbonUIMessage.sendCarbonUIMessage(e.getMessage(), CarbonUIMessage.ERROR, request, e);
    %>
    <script type="text/javascript">
        location.href = "../cep-admin/error.jsp";
        CARBON.showErrorDialog('<%=errorString%>');
    </script>
    <%
        }
    %>
    <script type="text/javascript">
        jQuery(document).ready(function() {
            executeQuery();
        });
    </script>


    <script type="text/javascript">

        function executeQuery() {
                var execScriptName = '<%=scriptName%>';
                document.getElementById('middle').style.cursor = 'wait';
                openProgressBar();
                new Ajax.Request('../hrta_hive-explorer/hrta_executeQuery.jsp', {
                            method: 'post',
                            parameters: {scriptName:execScriptName},
                            onSuccess: function(transport) {
                                closeProgrsssBar();
                                document.getElementById('middle').style.cursor = '';
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
        }

        function openProgressBar() {
          var content = '<div id="overlay"><div id="box"><div class="ui-dialog-title-bar">'+
                  '하이브 쿼리 실행<a href="#" title="Close" class="ui-dialog-titlebar-close" onclick="closeProgrsssBar();">'+
                    '<span style="display: none">x</span></a>'+
                  '</div><div class="dialog-content"><img src="../layout/images/ajax-loader.gif" />'+
                  ' 하이브 쿼리 실행...</div></div></div>';
        document.getElementById('dynamic').innerHTML = content;
        }

        function closeProgrsssBar() {
            document.getElementById('dynamic').innerHTML = '';
        }

    </script>



    <div id="middle">
       <div id="cols">
			<p id="breadCurmb">
				Home &gt; 데이터 분석 &gt; 하이브 쿼리 스크립트 목록						
			</p>
			<div class="hgroup">
				<h1>스크립트 에디트<%=" - " + scriptName%></h1>
			</div>
	
	        <div id="workArea" class="act">
	
	            <form id="commandForm" name="commandForm" action="" method="POST">
	                <table class="styledVertical">
	                	<thead>
	                		<tr>
	                		<th>수행결과</th>
	                		</tr>
	                	</thead>
	                    <tbody>
	                    <tr>
	                        <td>
	                            <div id="hiveResult" class="scrollable" style="width:99%">
	                                    <%--the results goes here...--%>
	                            </div>
	                        </td>
	                    </tr>
	                    </tbody>
	                </table>
	            </form>
	        </div>
    	</div>
    </div>

