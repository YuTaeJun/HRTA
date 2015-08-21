<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="com.toogram.cep.ui.ToogramEventProcessorUIUtils" %>
<%@ page import="org.wso2.carbon.event.processor.stub.EventProcessorAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.processor.stub.types.ExecutionPlanConfigurationDto" %>
<%@ page import="org.wso2.carbon.event.processor.stub.types.SiddhiConfigurationDto" %>
<%@ page import="org.wso2.carbon.event.processor.stub.types.StreamConfigurationDto" %>
<%@ page import="org.wso2.carbon.event.processor.ui.UIConstants" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>

<script type="text/javascript" src="../admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../admin/js/cookies.js"></script>
<script type="text/javascript" src="../admin/js/main.js"></script>
<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>
<script type="text/javascript" src="../eventprocessor/js/execution_plans.js"></script>

<link type="text/css" href="../resources/css/registry.css" rel="stylesheet"/>

<div id="cols">
<h2>이벤트 프로세서 디테일</h2>
	<p id="breadCurmb">
		Home &gt; 쿼리 실행 계획 &gt; 쿼리 실행 계획 내용 						
	</p>
	<div class="hgroup">
		<h1>퀴리 실행 계획 상세 내역 보기</h1>
	</div>

<div class="act">
<table id="eventProcessorDetails" class="styledVertical">
<tbody>
<tr>
<td>
<%
    String execPlanName = request.getParameter("execPlan");
    EventProcessorAdminServiceStub processorAdminServiceStub = ToogramEventProcessorUIUtils.getEventProcessorAdminService(config, session, request, response);
    EventStreamAdminServiceStub eventStreamAdminServiceStub = ToogramEventProcessorUIUtils.getEventStreamAdminService(config, session, request, response);
    ExecutionPlanConfigurationDto configurationDto = processorAdminServiceStub.getActiveExecutionPlanConfiguration(execPlanName);
%>
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
               style="width:100%"
               value=<%= "\"" + execPlanName + "\"" %>
                       readonly/>
    </td>
</tr>
<tr>
    <th>설명</th>
    <td>
        <input type="text" name="executionPlanDescription" id="executionPlanDescId"
               style="width:100%"
               value=<%= "\"" +((configurationDto.getDescription()!= null)? configurationDto.getDescription().trim():"")+ "\"" %>
                       readonly/>
    </td>
</tr>
<tr name="siddhiConfigsHeader">
    <td colspan="2">
        <b>Siddhi 설정</b>
    </td>
</tr>
<tr>
    <th>Snapshot 간격</th>
    <td>

        <%
            String snapshotTime = "0";
            if (configurationDto.getSiddhiConfigurations() != null) {
                for (SiddhiConfigurationDto siddhiConfigurationDto : configurationDto.getSiddhiConfigurations()) {
                    if (UIConstants.SIDDHI_SNAPSHOT_INTERVAL.equalsIgnoreCase(siddhiConfigurationDto.getKey())) {
                        snapshotTime = siddhiConfigurationDto.getValue();
                    }
                }
            }
        %>

        <input type="text" name="siddhiSnapshotTime" id="siddhiSnapshotTime"
               style="width:100%"
               value=<%= "\"" +snapshotTime + "\"" %>
                       readonly/>

    </td>
</tr>

<tr>
    <th>분산 처리</th>
    <td>
        <%
            String distributedProcessingStatus = "N/A";
            if (configurationDto.getSiddhiConfigurations() != null) {
                for (SiddhiConfigurationDto siddhiConfig : configurationDto.getSiddhiConfigurations()) {
                    if (UIConstants.SIDDHI_DISTRIBUTED_PROCESSING.equalsIgnoreCase(siddhiConfig.getKey())) {
                        if ("true".equals(siddhiConfig.getValue()) || "DistributedCache".equals(siddhiConfig.getValue())) {
                            distributedProcessingStatus = "Distributed Cache";
                        } else if ("RedundantNode".equals(siddhiConfig.getValue())) {
                            distributedProcessingStatus = "Redundant Node";
                        } else {
                            distributedProcessingStatus = "Disabled";
                        }
                    }
                }
            }
        %>
        <input type="text" name="siddhiDistrProcessing" id="siddhiDistrProcessing"
               style="width:100%"
               value=<%= "\"" +distributedProcessingStatus + "\"" %>
                       readonly/>

    </td>
</tr>

    <%--code mirror code--%>

<link rel="stylesheet" href="../hrta_eventprocessor/css/codemirror.css"/>
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
            autofocus: true,
            readOnly: true
        });
    };
</script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        init();
    });
</script>

    <%--Code mirror code end--%>

<tr>
    <td colspan="2">
        <b>query expressions</b>
    </td>
</tr>

<!--imported stream mappings-->

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
                    <table id="streamDefinitionsTable" width="100%">
                        <tbody>
                        <%
                            if (configurationDto.getImportedStreams() != null) {
                                for (StreamConfigurationDto dto : configurationDto.getImportedStreams()) {
                                    String paramDefinitions = eventStreamAdminServiceStub.getStreamDefinitionAsString(dto.getStreamId());
                                    String query = "define stream <b>"  + dto.getSiddhiStreamName() + "</b> (" + paramDefinitions+" )";

                        %>
                        <tr>
                            <td>
                                <font color="green"> <i><%="// 인입 스트림 ID : " + dto.getStreamId()%>
                                </i>   </font>
                                <br>
                                <%=query %>
                            </td>
                        </tr>

                        <%
                                }
                            }
                        %>

                        <%
                            if (configurationDto.getExportedStreams() != null) {
                                for (StreamConfigurationDto dto : configurationDto.getExportedStreams()) {
                                    String paramDefinitions = eventStreamAdminServiceStub.getStreamDefinitionAsString(dto.getStreamId());
                                    String query = "define stream <b>" + dto.getSiddhiStreamName() + "</b> ( " + paramDefinitions +" )";

                        %>
                        <tr>
                            <td>
                                <font color="blue"> <i><%="// 표시 스트림 ID : " + dto.getStreamId()%>
                                </i> </font>
                                <br>
                                <%=query %>
                            </td>
                        </tr>

                        <%
                                }
                            }
                        %>

                        </tbody>
                    </table>
                </td>
            </tr>
                <%--query expressions--%>
            <tr>
                <td>
                    <textarea class="queryExpressionsTextArea" style="width:100%; height: 150px"
                              id="queryExpressions"
                              name="queryExpressions" readonly><%= configurationDto.getQueryExpressions() %>
                    </textarea>
                </td>
            </tr>
        </table>
    </td>
</tr>
</tbody>
</table>
</div>
</tbody>
</table>

</div>
</div>