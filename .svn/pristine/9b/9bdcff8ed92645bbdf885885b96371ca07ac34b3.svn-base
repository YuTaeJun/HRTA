<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.toogram.cep.ui.ToogramEventFormatterUIUtils" %>

<%@ page import="org.wso2.carbon.event.formatter.stub.EventFormatterAdminServiceStub" %>
<%@ page import="java.util.ResourceBundle" %>

<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

<script type="text/javascript" src="global-params.js"></script>

<script src="../editarea/edit_area_full.js" type="text/javascript"></script>

<link type="text/css" href="../dialog/js/jqueryui/tabs/ui.all.css" rel="stylesheet"/>
<script type="text/javascript" src="../dialog/js/jqueryui/tabs/jquery-1.2.6.min.js"></script>
<script type="text/javascript" src="../dialog/js/jqueryui/tabs/jquery-ui-1.6.custom.min.js"></script>
<script type="text/javascript" src="../dialog/js/jqueryui/tabs/jquery.cookie.js"></script>

<!--Yahoo includes for dom event handling-->
<script src="../yui/build/yahoo-dom-event/yahoo-dom-event.js" type="text/javascript"></script>
<script type="text/javascript" src="../ajax/js/prototype.js"></script>

<%--end of newly added--%>


<%
    String status = request.getParameter("status");

    if ("updated".equals(status)) {
%>
<script type="text/javascript">
    jQuery(document).ready(function () {
        CARBON.showInfoDialog('activated.configuration');
    });
</script>
<%

    }
%>


<%
    String eventFormatterName = request.getParameter("eventFormatterName");
    String eventFormatterPath = request.getParameter("eventFormatterPath");

    String eventFormatterFile = "";
    if (eventFormatterName != null) {
        EventFormatterAdminServiceStub stub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);
        eventFormatterFile = stub.getActiveEventFormatterConfigurationContent(eventFormatterName);

    } else if (eventFormatterPath != null) {
        EventFormatterAdminServiceStub stub = ToogramEventFormatterUIUtils.getEventFormatterAdminService(config, session, request, response);
        eventFormatterFile = stub.getInactiveEventFormatterConfigurationContent(eventFormatterPath);

    }

    Boolean loadEditArea = true;
    String eventFormatterFileFileConfiguration = eventFormatterFile;

%>

<% if (loadEditArea) { %>
<script type="text/javascript">
    editAreaLoader.init({
                            id:"rawConfig"        // text area id
                            , syntax:"xml"            // syntax to be uses for highlighting
                            , start_highlight:true  // to display with highlight mode on start-up
                        });
</script>
<% } %>

<script type="text/javascript">
    function updateConfiguration(form, eventFormatterName) {
        var newEventFormatterConfiguration = ""

        if (document.getElementById("rawConfig") != null) {
            newEventFormatterConfiguration = editAreaLoader.getValue("rawConfig");
        }

        new Ajax.Request('../hrta_eventformatter/hrta_edit_event_formatter_ajaxprocessor.jsp', {
            method:'POST',
            asynchronous:false,
            parameters:{eventFormatterName:eventFormatterName, eventFormatterConfiguration:newEventFormatterConfiguration},
            onSuccess:function (event) {
                if ("true" == event.responseText.trim()) {
                    form.submit();
                } else {
                    if (event.responseText.trim().indexOf("유입 대상 메시지에 대한 인풋 스트림이 없습니다") != -1) {
                        CARBON.showErrorDialog("세션이 타임아웃으로 끊어졌습니다. 시작 페이지로 이동합니다.", function () {
                            window.location.href = "../hrta_eventformatter/hrta_eventformatter.jsp?ordinal=1";
                        });
                    } else {
                        CARBON.showErrorDialog("이벤트 포멧터 수정이 실패하였습니다, Exception: " + event.responseText.trim());
                    }
                }
            }
        })
    }

    function updateNotDeployedConfiguration(form, eventFormatterPath) {
        var newEventFormatterConfiguration = ""

        if (document.getElementById("rawConfig") != null) {
            newEventFormatterConfiguration = editAreaLoader.getValue("rawConfig");
        }

        new Ajax.Request('../hrta_eventformatter/hrta_edit_event_formatter_ajaxprocessor.jsp', {
            method:'POST',
            asynchronous:false,
            parameters:{eventFormatterPath:eventFormatterPath, eventFormatterConfiguration:newEventFormatterConfiguration},
            onSuccess:function (event) {
                if ("true" == event.responseText.trim()) {
                    form.submit();
                } else {
                	if (event.responseText.trim().indexOf("유입 대상 메시지에 대한 인풋 스트림이 없습니다") != -1) {
                        CARBON.showErrorDialog("세션이 타임아웃으로 끊어졌습니다. 시작 페이지로 이동합니다.", function () {
                            window.location.href = "../hrta_eventformatter/hrta_eventformatter.jsp?ordinal=1";
                        });
                    } else {
                        CARBON.showErrorDialog("이벤트 포멧터 수정이 실패하였습니다, Exception: " + event.responseText.trim());
                    }
                }
            }
        })

    }


    function resetConfiguration(form) {

        CARBON.showConfirmationDialog(
                "Reset 하시겠습니까?", function () {
                    editAreaLoader.setValue("rawConfig", document.getElementById("rawConfig").value.trim());
                });

    }

</script>

<div id="cols">
	<p id="breadCurmb">
		Home &gt; 이벤트 포멧터 &gt; 포멧터 수정						
	</p>
	<div class="hgroup">
		<h1>이벤트 포멧터 설정 수정</h1>
	</div>

    <!-- header group -->
	<div class="act">
		<div class="hgroup">
			<p>설정내용에 필요한 수정사항을 적용하신후, "업데이트" 버튼을 클릭하여 적용하십시오. 수정내용을 되돌리시려면 "Reset"을 클릭하십시오</p>
		</div>
		<form name="configform" id="configform" action="../hrta_eventformatter/hrta_eventformatter.jsp?ordinal=1" method="post">
            <table class="styledVertical">
                <thead>
                <tr>
                    <th>
                        <th>이벤트 포멧터 수정</th>
                    </th>
                </tr>
                </thead>
                <tbody>
                <tr>
                   <td id="rawConfigTD">
                       <textarea name="rawConfig" id="rawConfig"
                                 style="border:solid 1px #cccccc; width: 99%; height: 400px; margin-top:5px;"><%=eventFormatterFileFileConfiguration%>
                       </textarea>

                       <% if (!loadEditArea) { %>
                       <div style="padding:10px;color:#444;">
                           <fmt:message key="syntax.disabled"/>
                       </div>
                       <% } %>
                   </td>
                </tr>
                <tr>
                    <td class="buttonRow">
                        <%
                            if (eventFormatterName != null) {
                        %>

                        <button class="btn"
                                onclick="updateConfiguration(document.getElementById('configform'),'<%=eventFormatterName%>'); return false;">
                            	업데이트</button>

                        <%
                        } else if (eventFormatterPath != null) {
                        %>
                        <button class="btn"
                                onclick="updateNotDeployedConfiguration(document.getElementById('configform'),'<%=eventFormatterPath%>'); return false;">
                            	업데이트</button>

                        <%
                            }
                        %>
                        <button class="btn"
                                onclick="resetConfiguration(document.getElementById('configform')); return false;">
                            	리셋</button>
                    </td>
                </tr>
                </tbody>

            </table>

        </form>

    </div>
</div>