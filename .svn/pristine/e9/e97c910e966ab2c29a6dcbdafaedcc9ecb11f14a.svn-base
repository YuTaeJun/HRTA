<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="com.toogram.cep.ui.ToogramEventProcessorUIUtils" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>

<script type="text/javascript" src="../hrta_eventprocessor/js/execution_plans.js"></script>
<script type="text/javascript" src="../hrta_eventprocessor/js/create_execution_plan_helper.js"></script>
<script type="text/javascript" src="../ajax/js/prototype.js"></script>

<%--code mirror code--%>

<link rel="stylesheet" href="../hrta_eventprocessor/css/codemirror.css"/>
<link rel="stylesheet" href="../hrta_eventprocessor/css/event-processor.css"/>
<script src="../hrta_eventprocessor/js/codemirror.js"></script>
<script src="../hrta_eventprocessor/js/sql.js"></script>

<style>
    .CodeMirror {
        border-top: 1px solid #cccccc;
        border-bottom: 1px solid black;
    }
</style>


<script>
    var init = function () {
        var mime = 'text/siddhi-sql-db';

        // get mime type
        if (window.location.href.indexOf('mime=') > -1) {
            mime = window.location.href.substr(window.location.href.indexOf('mime=') + 5);
        }

        window.queryEditor = CodeMirror.fromTextArea(document.getElementById('queryExpressions'), {
            mode: mime,
            indentWithTabs: true,
            smartIndent: true,
            lineNumbers: true,
            matchBrackets: true,
            autofocus: true
        });
    };
</script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        init();
    });
</script>

<%--Code mirror code end--%>

<%
    EventStreamAdminServiceStub streamAdminServiceStub = ToogramEventProcessorUIUtils.getEventStreamAdminService(config, session, request, response);
    String[] streamNames = streamAdminServiceStub.getStreamNames();
%>
<tr>
<td>
<div class="detail-view">
<table class="detail">
	<colgroup>	
		<col style="width: 20%;">
		<col>
	</colgroup>
<tbody>
<tr>
    <th>실행 계획 명<span class="required">*</span></th>
    <td><input type="text" name="executionPlanName" id="executionPlanId"
               style="width:80%"/>
        
        <p><small>실행 계획 명을 입력하세요</small></p>
    </td>
</tr>
<tr>
    <th>설명</th>
    <td>
        <textarea name="executionPlanDescription" id="executionPlanDescId"
                  style="width:80%"></textarea>

        <p><small>실행 계획 설명을 입력하세요</small></p>
    </td>
</tr>


<tr name="siddhiConfigsHeader">
    <td colspan="2">
        <b>Siddhi 설정</b>
    </td>
</tr>
<tr>
    <th>Snapshot 시간 단위</th>
    <td>
        <input type="text" name="siddhiSnapshotTime" id="siddhiSnapshotTime"
               value="0"
               style="width:80%"/>

        <p><small>스넵샷 타임을 분 단위로 입력하십시오. 0입력시 사용 불가 처리 됩니다.</small></p>
    </td>
</tr>

<tr>
    <th>분산 처리</th>
    <td>
        <select name="distributedProcessing" id="distributedProcessing">
            <option value="RedundantNode">Redundant Node</option>
            <option value="DistributedCache">Distributed Cache</option>
            <option value="false" selected="selected">Disabled</option>
        </select>
    </td>
</tr>

<tr>
    <td colspan="2">
        <b>query expressions</b>
    </td>
</tr>

<!-- imported stream definitions-->


<tr>
    <th>
		Import 스트림<span class="required">*</span>
    </th>
    <td>    
    <div class="line-frm">
	스트림 ID : <select id="importedStreamId" onfocus="this.selectedIndex = 0;" onchange="createImportedStreamDefinition(this)"
	                        onclick="importedStreamDefSelectClick(this)">
	                <%
	                    if (streamNames != null) {
	                        for (String streamName : streamNames) {
	
	                %>
	                <option value= <%= "\"" + streamName + "\""%>><%= streamName %>
	                </option>
	                <%
	                        }
	                    }
	                %>
	                <option value="createStreamDef">-- Create Stream Definition --</option>
	            </select> 
	을 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="text" id="importedStreamAs"/> 으로 Import &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" class="btn" value="Import" onclick="addImportedStreamDefinition()" />
	<div id="addEventStreamTD"> </div>
	</div>
    </td>
</tr>


    <%--query expressions--%>


<tr>
    <td colspan="2">
        <style>
            div#workArea table#streamDefinitionsTable tbody tr td {
                padding-left: 45px !important;
            }
        </style>
        <table width="100%" style="border: 1px solid #cccccc">
            <tr>
                <td>
                    <table id="streamDefinitionsTable" width="100%" class="line-tb">
                        <tbody>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <textarea class="queryExpressionsTextArea" style="width:100%; height: 150px"
                              id="queryExpressions"
                              name="queryExpressions" onblur="window.queryEditor.save()"></textarea>
                </td>
            </tr>

            <tr>
                <td>
                    <input type="button" class="btn"
                           value="쿼리 유효성 검사"
                           onclick="validateQueries()"/>
                </td>
            </tr>


        </table>
    </td>
</tr>
<tr></tr>
<tr>
    <th>Export 스트림</th>
    <td>
    <div class="line-frm">
    	값  <input type="text" id="exportedStreamValueOf"/>은 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                스트림 ID : <select id="exportedStreamId" onfocus="this.selectedIndex = 0;" onchange="createExportedStreamDefinition(this)"
                            onclick="exportedStreamDefSelectClick(this)">
                    <%
                        if (streamNames != null && streamNames.length > 0) {
                            for (String streamName : streamNames) {

                    %>
                    <option value= <%= "\"" + streamName + "\""%>><%= streamName %>
                    </option>
                    <%
                            }
                        }
                    %>
                    <option value="createStreamDef">-- Create Stream Definition --</option>
                </select>
                에서 Export &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       <input type="button" class="btn" value="Export"  onclick="addExportedStreamDefinition()"/>
    </div>
    </td>
</tr>
</tbody>
</table>
</div>
</td>
</tr>