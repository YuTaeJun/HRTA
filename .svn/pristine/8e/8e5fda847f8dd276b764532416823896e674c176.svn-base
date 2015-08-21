/*
 * Copyright (c) 2005-2013, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

function validateQueries() {
    var queryExpressions = window.queryEditor.getValue();
    var allEventStreams = "";
    var eventStreamTable = document.getElementById("streamDefinitionsTable");


    if (queryExpressions == "") {
        CARBON.showErrorDialog("쿼리 구문이 없습니다.");
        return;
    }

    if (getImportedStreamDataValues(eventStreamTable) == "") {
        CARBON.showErrorDialog("유입 스트림이 없습니다.");
        return;
    }

    if (eventStreamTable.rows.length > 0) {
        for (var i = 0; i < eventStreamTable.rows.length; i++) {
            var row = eventStreamTable.rows[i];
            var query = row.getAttribute("siddhiStreamDefinition");
            allEventStreams = allEventStreams + query + ";";
        }
    }

    new Ajax.Request('../hrta_eventprocessor/hrta_validate_siddhi_queries_ajaxprocessor.jsp', {
        method:'POST',
        asynchronous:false,
        parameters:{siddhiStreamDefinitions:allEventStreams, queries:queryExpressions },
        onSuccess:function (callbackMessage) {
            var resultText = callbackMessage.responseText.trim();
            if (resultText == "success") {
                CARBON.showInfoDialog("정상적인 쿼리입니다!");
                return;
            } else {
                CARBON.showErrorDialog(resultText);
                return;
            }
        }
    });
}

function createImportedStreamDefinition(element) {
    var selectedVal = element.options[element.selectedIndex].value;
    if (selectedVal == 'createStreamDef') {
        new Ajax.Request('../hrta_eventstream/hrta_popup_create_event_stream_ajaxprocessor.jsp', {
            method:'POST',
            asynchronous:false,
            parameters:{callback:"inflow"},
            onSuccess:function (data) {
                showCustomPopupDialog(data.responseText, "스트림 정의 생성", "80%", "", onSuccessCreateInflowStreamDefinition, "90%");
            }
        });
    }
}

function importedStreamDefSelectClick(element) {
    if (element.length <= 1) {
        createImportedStreamDefinition(element);
    }
}

function exportedStreamDefSelectClick(element) {
    if (element.length <= 1) {
        createExportedStreamDefinition(element);
    }
}

function createExportedStreamDefinition(element) {

    var selectedVal = element.options[element.selectedIndex].value;
    if (selectedVal == 'createStreamDef') {

        var queryExpressions = window.queryEditor.getValue();

        if (queryExpressions == "") {
            CARBON.showErrorDialog("쿼리 구문이 없습니다.");
            return;
        }

        var importedStreams = "";
        var importedStreamTable = document.getElementById("streamDefinitionsTable");

        if (importedStreamTable.rows.length > 0) {
            for (var i = 0; i < importedStreamTable.rows.length; i++) {
                var row = importedStreamTable.rows[i];
                var query = row.getAttribute("siddhiStreamDefinition");
                importedStreams = importedStreams + query + ";";
            }
        }
        else {
            CARBON.showErrorDialog("유입 스트림이 없습니다.");
            return;
        }

        var valueOf = document.getElementById("exportedStreamValueOf").value;
        var jsonStreamDefinition = "";

        new Ajax.Request('../hrta_eventprocessor/hrta_export_siddhi_stream_ajaxprocessor.jsp', {
            method:'POST',
            asynchronous:false,
            parameters:{siddhiStreamDefinitions:importedStreams, queries:queryExpressions, targetStream:valueOf },
            onSuccess:function (data) {
                jsonStreamDefinition = data.responseText;
            }
        });

        if (jsonStreamDefinition) {
            jsonStreamDefinition = jsonStreamDefinition.replace(/^\s+|\s+$/g, '');
            if (jsonStreamDefinition == "") {
                CARBON.showErrorDialog("주어진 이름과 매칭되는 스트림이 없습니다 : " + valueOf + ". " +
                                       "'Value of' 필드의 이름을 사용할 수 있는 스트림 이름으로 지정하세요.");
                return;
            }
        } else {
        	CARBON.showErrorDialog("주어진 이름과 매칭되는 스트림이 없습니다 : " + valueOf + ". " +
            "'Value of' 필드의 이름을 사용할 수 있는 스트림 이름으로 지정하세요.");
            return;
        }


        new Ajax.Request('../hrta_eventstream/hrta_popup_create_event_stream_ajaxprocessor.jsp', {
            method:'POST',
            asynchronous:false,
            parameters:{streamDef:jsonStreamDefinition, callback:"outflow"},
            onSuccess:function (data) {
                showCustomPopupDialog(data.responseText, "스트림 정의 생성", "80%", "", onSuccessCreateOutflowStreamDefinition, "90%");
            }
        });
    }
}


function addImportedStreamDefinition() {
    var propStreamId = document.getElementById("importedStreamId");
    var propAs = document.getElementById("importedStreamAs");

    var error = "";
    if (propStreamId.value == "" || propStreamId.value == "createStreamDef") {
        error = "Invalid Stream ID selected.\n";
    }

    if (error != "") {
        CARBON.showErrorDialog(error);
        return;
    }

    if (propAs.value.trim() == "") {
        propAs.value = propStreamId.value.trim().split(':')[0];
        propAs.value = propAs.value.replace(/\./g, '_');
    }

    // checking for duplicate stream definitions.
    var streamDefinitionsTable = document.getElementById("streamDefinitionsTable");
    for (var i = 0, row; row = streamDefinitionsTable.rows[i]; i++) {
        var existingStreamId = row.getAttribute("streamId");
        var existingAs = row.getAttribute("as");
        if ((propStreamId.value == existingStreamId) && (propAs.value == existingAs)) {
            CARBON.showErrorDialog("An identical imported stream already exists.");
            return;
        }
    }

    new Ajax.Request('../hrta_eventprocessor/hrta_get_stream_definition_ajaxprocessor.jsp', {
        method:'POST',
        asynchronous:false,
        parameters:{streamId:propStreamId.value, streamAs:propAs.value },
        onSuccess:function (eventStreamDefinition) {
            var definitions = eventStreamDefinition.responseText.trim().split("|=");
            var streamId = definitions[0].trim();
            var streamAs = definitions[1].trim();

            var streamDefinitionString = "define stream <b>" + streamAs + "</b> (<div class=\"siddhiStreamDefParams\"> " + definitions[2].trim() + ")</div> ";
            var siddhiStreamDefinition = "define stream " + streamAs + " (" + definitions[3].trim() + ")";

            var streamDefinitionsTable = document.getElementById("streamDefinitionsTable");
            var newStreamDefTableRow = streamDefinitionsTable.insertRow(streamDefinitionsTable.rows.length);
            newStreamDefTableRow.setAttribute("streamType", "imported");
            newStreamDefTableRow.setAttribute("id", "def:imported:" + streamId);
            newStreamDefTableRow.setAttribute("streamId", streamId);
            newStreamDefTableRow.setAttribute("as", streamAs);
            newStreamDefTableRow.setAttribute("siddhiStreamDefinition", siddhiStreamDefinition);

            var newStreamDefCell0 = newStreamDefTableRow.insertCell(0);
            newStreamDefCell0.innerHTML = "<font color='green'>//  <i> Imported from " + streamId + "</i></font><br>" + streamDefinitionString;
            YAHOO.util.Dom.addClass(newStreamDefCell0, "property-names");
            YAHOO.util.Dom.setStyle(newStreamDefCell0, "padding-left", "45px !important");

            var newStreamDefCell1 = newStreamDefTableRow.insertCell(1);
            newStreamDefCell1.innerHTML = '<p class="fnc-set"><a href="" class="btn-add"  onclick="removeImportedStreamDefinition(this)"><i class="fa fa-minus-circle fa-2"></i>삭제</a></p>';
            YAHOO.util.Dom.addClass(newStreamDefCell1, "property-names");
        }
    });
    propAs.value = "";


}


function addExportedStreamDefinition() {
    var propStreamId = document.getElementById("exportedStreamId");
    var propValueOf = document.getElementById("exportedStreamValueOf");
    var streamDefinitionsTable = document.getElementById("streamDefinitionsTable");

    var error = "";

    if (propStreamId.value == "" || propStreamId.value == "createStreamDef") {
        error = "Invalid Stream ID selected.\n";
    }

    if (propValueOf.value == "") {
        error = "Value Of field is empty.\n";
    }

    if (error != "") {
        CARBON.showErrorDialog(error);
        return;
    }

// checking for duplicate stream definitions.
    for (var i = 0, row; row = streamDefinitionsTable.rows[i]; i++) {
        if (i > 0) {  // leaving out the headers.
            if (row.getAttribute("streamType") == "exported") {
                var existingValueOf = row.getAttribute("as");
                var existingStreamId = row.getAttribute("streamId");
                if ((propStreamId.value == existingStreamId) && (propValueOf.value == existingValueOf)) {
                    CARBON.showErrorDialog("An identical exported stream already exists.");
                    return;
                }
            }
        }
    }

    new Ajax.Request('../hrta_eventprocessor/hrta_get_stream_definition_ajaxprocessor.jsp', {
        method:'POST',
        asynchronous:false,
        parameters:{streamId:propStreamId.value, streamAs:propValueOf.value },
        onSuccess:function (eventStreamDefinition) {
            var definitions = eventStreamDefinition.responseText.trim().split("|=");
            var streamId = definitions[0].trim();
            var streamAs = definitions[1].trim();

            var streamDefinitionString = "define stream <b>" + streamAs + "</b> (<div class=\"siddhiStreamDefParams\"> " + definitions[2].trim() + ")</div> ";
            var siddhiStreamDefinition = "define stream " + streamAs + " (" + definitions[3].trim() + ")";

            var newStreamDefTableRow = streamDefinitionsTable.insertRow(streamDefinitionsTable.rows.length);
            newStreamDefTableRow.setAttribute("streamType", "exported");
            newStreamDefTableRow.setAttribute("id", "def:exported:" + streamId);
            newStreamDefTableRow.setAttribute("streamId", streamId);
            newStreamDefTableRow.setAttribute("as", streamAs);
            newStreamDefTableRow.setAttribute("siddhiStreamDefinition", siddhiStreamDefinition);

            var newStreamDefCell0 = newStreamDefTableRow.insertCell(0);
            newStreamDefCell0.innerHTML = "<font color='blue'>//  <i> Exported to " + streamId + "</i></font><br>" + streamDefinitionString;
            YAHOO.util.Dom.addClass(newStreamDefCell0, "property-names");
            YAHOO.util.Dom.setStyle(newStreamDefCell0, "padding-left", "45px !important");


            var newStreamDefCell1 = newStreamDefTableRow.insertCell(1);
            newStreamDefCell1.innerHTML = '<p class="fnc-set"><a href="" class="btn-add"  onclick="removeExportedStream(this)"><i class="fa fa-minus-circle fa-2"></i>삭제</a></p>';
            
            
            YAHOO.util.Dom.addClass(newStreamDefCell1, "property-names");
        }
    });

    propValueOf.value = "";
}


function addExecutionPlan(form) {
    var isFieldEmpty = false;
    var execPlanName = document.getElementById("executionPlanId").value.trim();
    var description = document.getElementById("executionPlanDescId").value.trim();
    var snapshotInterval = document.getElementById("siddhiSnapshotTime").value.trim();
    var distributedProcessing = document.getElementById("distributedProcessing").value.trim();

    // query expressions can be empty for pass thru execution plans...?
    var queryExpressions = window.queryEditor.getValue();
    var reWhiteSpace = new RegExp("^[a-zA-Z0-9_]+$");

    if (!reWhiteSpace.test(execPlanName)) {
        CARBON.showErrorDialog("수행 계획명에 사용하실 수 없는 문자가 있습니다.");
        return;
    }
    if ((execPlanName == "")) {
        // empty fields are encountered.
        CARBON.showErrorDialog("빈 입력란은 허용되지 않습니다.");
        return;
    }

    if (queryExpressions == "") {
        CARBON.showErrorDialog("쿼리 구문이 없습니다.");
        return;
    }

    var propertyCount = 0;
    var outputPropertyParameterString = "";

    // all properties, not required and required are checked
    while (document.getElementById("property_Required_" + propertyCount) != null ||
           document.getElementById("property_" + propertyCount) != null) {
        // if required fields are empty
        if (document.getElementById("property_Required_" + propertyCount) != null) {
            if (document.getElementById("property_Required_" + propertyCount).value.trim() == "") {
                // values are empty in fields
                isFieldEmpty = true;
                outputPropertyParameterString = "";
                break;
            }
            else {
                // values are stored in parameter string to send to backend
                var propertyValue = document.getElementById("property_Required_" + propertyCount).value.trim();
                var propertyName = document.getElementById("property_Required_" + propertyCount).name;
                outputPropertyParameterString = outputPropertyParameterString + propertyName + "$=" + propertyValue + "|=";

            }
        } else if (document.getElementById("property_" + propertyCount) != null) {
            var notRequriedPropertyValue = document.getElementById("property_" + propertyCount).value.trim();
            var notRequiredPropertyName = document.getElementById("property_" + propertyCount).name;
            if (notRequriedPropertyValue == "") {
                notRequriedPropertyValue = "  ";
            }
            outputPropertyParameterString = outputPropertyParameterString + notRequiredPropertyName + "$=" + notRequriedPropertyValue + "|=";

        }
        propertyCount++;
    }

    if (isFieldEmpty) {
        // empty fields are encountered.
        CARBON.showErrorDialog("빈 입력란은 허용되지 않습니다.");
        return;
    } else {
        var importedStreams = "";

        var eventStreamTable = document.getElementById("streamDefinitionsTable");
        if (eventStreamTable.rows.length > 0) {
            importedStreams = getImportedStreamDataValues(eventStreamTable);
        }
        else {
            CARBON.showErrorDialog("유입 스트림이 없습니다.");
            return;
        }

        var exportedStreams = "";
        var streamDefinitionsTable = document.getElementById("streamDefinitionsTable");

        exportedStreams = getExportedStreamDataValues(streamDefinitionsTable);
        var duplicatedStreams = getDuplicatedStreams();
        var allEventStreams = "";
        if (eventStreamTable.rows.length > 0) {
            for (var i = 0; i < eventStreamTable.rows.length; i++) {
                var row = eventStreamTable.rows[i];
                var query = row.getAttribute("siddhiStreamDefinition");
                allEventStreams = allEventStreams + query + ";";
            }
        }

        new Ajax.Request('../hrta_eventprocessor/hrta_validate_siddhi_queries_ajaxprocessor.jsp', {
            method:'POST',
            asynchronous:false,
            parameters:{siddhiStreamDefinitions:allEventStreams, queries:queryExpressions },
            onSuccess:function (callbackMessage) {
                var resultText = callbackMessage.responseText.trim();
                if (resultText == "success") {

                    if (duplicatedStreams == "no-export-streams") {
                        CARBON.showConfirmationDialog("유출 스트림이 정의 되지 않았습니다. 진행하시겠습니까.", function () {
                            makeAsyncCallToCreateExecutionPlan(form, execPlanName, description, snapshotInterval, distributedProcessing, importedStreams, exportedStreams, queryExpressions);
                        }, null);
                    } else {
                        if (duplicatedStreams != "" && duplicatedStreams != "no-export-streams") {
                            CARBON.showConfirmationDialog("주어진 스트림은 유입/유출에서 모두 사용됩니다. 진행하시겠습니까?\n" + duplicatedStreams, function () {
                                makeAsyncCallToCreateExecutionPlan(form, execPlanName, description, snapshotInterval, distributedProcessing, importedStreams, exportedStreams, queryExpressions);
                            }, null);
                        } else {
                            makeAsyncCallToCreateExecutionPlan(form, execPlanName, description, snapshotInterval, distributedProcessing, importedStreams, exportedStreams, queryExpressions);
                        }
                    }
                } else {
                    CARBON.showErrorDialog(resultText);
                    return;
                }
            }
        });
    }
}

function getDuplicatedStreams() {
    var exportedStreamsTable = document.getElementById("exportedStreamsTable");
    var StreamTable = document.getElementById("streamDefinitionsTable");

    var importedStreamCount = 0;
    var exportedStreamCount = 0;
    var importedStreamArray = new Array();
    var exportedStreamArray = new Array();

    for (var i = 0; i < StreamTable.rows.length; i++) {
        var row = StreamTable.rows[i];
        if (row.getAttribute("streamType") == "imported") {
            importedStreamArray[importedStreamCount] = row.getAttribute("streamId");
            importedStreamCount++;
        } else if (row.getAttribute("streamType") == "exported") {
            exportedStreamArray[exportedStreamCount] = row.getAttribute("streamId");
            exportedStreamCount++;
        }
    }

    var reusedStreams = "";

    if (exportedStreamCount == 0) {
        return "no-export-streams";
    }
    else if (importedStreamCount > 0 && exportedStreamCount > 0) {
        for (var i = 0; i < exportedStreamCount; i++) {
            var exportedStreamId = exportedStreamArray[i];
            for (var j = 0; j < importedStreamCount; j++) {
                var importedStreamId = importedStreamArray[j];
                if (importedStreamId == exportedStreamId) {
                    if (reusedStreams != "") {
                        reusedStreams = reusedStreams + "\n"
                    }
                    reusedStreams = reusedStreams + importedStreamId;
                }
            }
        }
    }
    return reusedStreams;

}


function makeAsyncCallToCreateExecutionPlan(form, execPlanName, description, snapshotInterval,
                                            distributedProcessing, importedStreams, exportedStreams,
                                            queryExpressions) {
    new Ajax.Request('../hrta_eventprocessor/hrta_add_execution_plan_ajaxprocessor.jsp', {
        method:'POST',
        asynchronous:false,
        parameters:{execPlanName:execPlanName, description:description, snapshotInterval:snapshotInterval, distributedProcessing:distributedProcessing,
            importedStreams:importedStreams, exportedStreams:exportedStreams, queryExpressions:queryExpressions },
        onSuccess:function (transport) {
            if ("true" == transport.responseText.trim()) {
                form.submit();
            } else {
                CARBON.showErrorDialog("수행 계획 추가에 실패하였습니다, Exception: " + transport.responseText.trim());
            }
        }
    });
}


function getExportedStreamDataValues(dataTable) {

    var streamData = "";
    for (var i = 1; i < dataTable.rows.length; i++) {
        var row = dataTable.rows[i];
        if (row.getAttribute("streamType") == "exported") {
            var column0 = row.getAttribute("as");
            var column1 = row.getAttribute("streamId");
            streamData = streamData + column0 + "^=" + column1 + "^=" + "$=";
        }
    }
    return streamData;
}

function getImportedStreamDataValues(dataTable) {
    var streamData = "";
    for (var i = 0; i < dataTable.rows.length; i++) {
        var row = dataTable.rows[i];
        if (row.getAttribute("streamType") == "imported") {
            var column0 = row.getAttribute("streamId");
            var column1 = row.getAttribute("as");
            streamData = streamData + column0 + "^=" + column1 + "^=" + "$=";
        }
    }
    return streamData;
}


function loadUIElements(uiId) {
    var uiElementTd = document.getElementById("uiElement");
    uiElementTd.innerHTML = "";

    jQuery.ajax({
                    type:"POST",
                    url:"../hrta_eventexecutionplanwizard/hrta_get_ui_ajaxprocessor.jsp?uiId=" + uiId + "",
                    data:{},
                    contentType:"text/html; charset=utf-8",
                    dataType:"text",
                    async:false,
                    success:function (ui_content) {
                        if (ui_content != null) {
                            jQuery(uiElementTd).html(ui_content);

                            if (uiId == 'builder') {
                                var innertTD = document.getElementById('addEventAdaptorTD');
                                jQuery(innertTD).html('<a onclick=\'loadUIElements("inputAdaptor") \'style=\'background-image:url(images/add.gif);\' class="icon-link" href="#" \'> Add New Input Event Adaptor </a>')
                            }

                            else if (uiId == 'formatter') {
                                var innertTD = document.getElementById('addOutputEventAdaptorTD');
                                jQuery(innertTD).html('<a onclick=\'loadUIElements("outputAdaptor") \'style=\'background-image:url(images/add.gif);\' class="icon-link" href="#" \'> Add New Out Event Adaptor </a>')
                            }

                            else if (uiId == 'processor') {
                                var innertTD = document.getElementById('addEventStreamTD');
                                jQuery(innertTD).html('<a onclick=\'loadUIElements("builder") \'style=\'background-image:url(images/add.gif);\' class="icon-link" href="#" \'> Add New Event Stream </a>')
                            }

                        }
                    }
                });


}


