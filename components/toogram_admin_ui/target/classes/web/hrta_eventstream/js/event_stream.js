//Method that used in jsp files


function addEventStream(form, option, eventStreamId) {


    var eventStreamName = document.getElementById("eventStreamNameId").value.trim();
    var eventStreamVersion = document.getElementById("eventStreamVersionId").value.trim();

    var eventStreamDescription = document.getElementById("eventStreamDescription").value.trim();
    var eventStreamNickName = document.getElementById("eventStreamNickName").value.trim();

    if ((eventStreamName == "") || (eventStreamVersion == "")) {
        // empty fields are encountered.
        CARBON.showErrorDialog("빈 입력항목은 허용되지 않습니다.");
        return;
    }
    else {
        var metaData = "";
        var correlationData = "";
        var payloadData = "";
        var newEventStreamId = eventStreamName + ":" + eventStreamVersion;

        var metaDataTable = document.getElementById("outputMetaDataTable");
        if (metaDataTable != null && metaDataTable.rows.length > 1) {
            metaData = getWSO2EventDataValues(metaDataTable);
        }
        var correlationDataTable = document.getElementById("outputCorrelationDataTable");
        if (correlationDataTable != null && correlationDataTable.rows.length > 1) {
            correlationData = getWSO2EventDataValues(correlationDataTable);
        }
        var payloadDataTable = document.getElementById("outputPayloadDataTable");
        if (payloadDataTable != null && payloadDataTable.rows.length > 1) {
            payloadData = getWSO2EventDataValues(payloadDataTable);
        }

        if (metaData == "" && correlationData == "" && payloadData == "") {
            CARBON.showErrorDialog("Mapping parameters cannot be empty.");
            return;
        } else if (option == "add") {
            new Ajax.Request('../hrta_eventstream/hrta_add_event_stream_ajaxprocessor.jsp', {
                method:'POST',
                asynchronous:false,
                parameters:{eventStreamName:eventStreamName, eventStreamVersion:eventStreamVersion, metaData:metaData, correlationData:correlationData, payloadData:payloadData, eventStreamDescription:eventStreamDescription, eventStreamNickName:eventStreamNickName},
                onSuccess:function (event) {
                    if ("true" == event.responseText.trim()) {
                        CARBON.showInfoDialog("스트림 정의 추가 완료", function () {
                            CARBON.customConfirmDialogBox("" +
                            		"정의된 이벤트 스트림은 해당 이벤트 빌더를 사용하는 이벤트의 In Flow에서 보실 수 있습니다. 지금 이벤트 빌더를 생성하시겠습니까? ", "디퐅트 WSO2Event Builder", "커스텀 Event Builder", function (option) {                                
                            	if (option == "custom") {
                                    new Ajax.Request('../hrta_eventbuilder/hrta_popup_create_event_builder_ajaxprocessor.jsp', {
                                        method:'POST',
                                        asynchronous:false,
                                        parameters:{streamNameWithVersion:newEventStreamId},
                                        onSuccess:function (data) {
                                            showCustomPopupDialog(data.responseText, "이벤트 빌더 생성", "80%", "", ignore, "90%");
                                        }
                                    });

                                } else {
                                    new Ajax.Request('../hrta_eventbuilder/hrta_add_default_event_builder_ajaxprocessor.jsp', {
                                        method:'POST',
                                        asynchronous:false,
                                        parameters:{eventStreamId:newEventStreamId},
                                        onSuccess:function (response) {
                                            if ("true" == response.responseText.trim()) {
                                                CARBON.showInfoDialog("기본 이벤트 빌더가 성공적으로 추가되었습니다!!");
                                                form.submit();
                                            } else {
                                                CARBON.showErrorDialog("이벤트 빌더 추가 실패, Exception: " + response.responseText.trim());
                                            }
                                        }
                                    });
                                }

                            }, function () {
                                form.submit();
                            });

                        }, null);
                    } else {
                        CARBON.showErrorDialog("이벤트 스트림 추가 실패, Exception: " + event.responseText.trim());
                    }
                }
            })
        } else if (option == "edit") {

            CARBON.showConfirmationDialog(
                    "이벤트 스트림을 수정하시면, 관련된 설정 파일들이 같이 영향을 받습니다. 수정하시겠습니까?", function () {
                        new Ajax.Request('../hrta_eventstream/hrta_edit_event_stream_ajaxprocessor.jsp', {
                            method:'POST',
                            asynchronous:false,
                            parameters:{oldStreamId:eventStreamId, eventStreamName:eventStreamName, eventStreamVersion:eventStreamVersion, metaData:metaData, correlationData:correlationData, payloadData:payloadData, eventStreamDescription:eventStreamDescription, eventStreamNickName:eventStreamNickName},
                            onSuccess:function (event) {
                                if ("true" == event.responseText.trim()) {
                                    form.submit();
                                } else {
                                    CARBON.showErrorDialog("이벤트 스트림 수정 실패, Exception: " + event.responseText.trim());
                                }
                            }
                        })
                    }, null, null);

        }
    }
}

function ignore() {

}

function addEventStreamViaPopup(form, callback) {

    var eventStreamName = document.getElementById("eventStreamNameId").value.trim();
    var eventStreamVersion = document.getElementById("eventStreamVersionId").value.trim();

    var streamId = eventStreamName + ":" + eventStreamVersion;
    var eventStreamDescription = document.getElementById("eventStreamDescription").value.trim();
    var eventStreamNickName = document.getElementById("eventStreamNickName").value.trim();

    if ((eventStreamName == "") || (eventStreamVersion == "")) {
        // empty fields are encountered.
        CARBON.showErrorDialog("빈 입력한은 허용되지 않습니다.");
        return;
    }

    else {
        var metaData = "";
        var correlationData = "";
        var payloadData = "";

        var metaDataTable = document.getElementById("outputMetaDataTable");
        if (metaDataTable.rows.length > 1) {
            metaData = getWSO2EventDataValues(metaDataTable);
        }
        var correlationDataTable = document.getElementById("outputCorrelationDataTable");
        if (correlationDataTable.rows.length > 1) {
            correlationData = getWSO2EventDataValues(correlationDataTable);
        }
        var payloadDataTable = document.getElementById("outputPayloadDataTable");
        if (payloadDataTable.rows.length > 1) {
            payloadData = getWSO2EventDataValues(payloadDataTable);
        }

        if (metaData == "" && correlationData == "" && payloadData == "") {
            CARBON.showErrorDialog("Mapping parameters cannot be empty.");
            return;
        } else {
            new Ajax.Request('../hrta_eventstream/hrta_add_event_stream_ajaxprocessor.jsp', {
                method:'POST',
                asynchronous:false,
                parameters:{eventStreamName:eventStreamName, eventStreamVersion:eventStreamVersion, metaData:metaData, correlationData:correlationData, payloadData:payloadData, eventStreamDescription:eventStreamDescription, eventStreamNickName:eventStreamNickName},
                onSuccess:function (event) {
                    if ("true" == event.responseText.trim()) {
                        CARBON.showInfoDialog("스트림 정의가 성공적으로 추가되었습니다!!", function () {
                            if (callback == "inflow") {
                                onSuccessCreateInflowStreamDefinition(streamId);
                            } else if (callback == "outflow") {
                                onSuccessCreateOutflowStreamDefinition(streamId);
                            }
                        }, function () {
                            if (callback == "inflow") {
                                onSuccessCreateInflowStreamDefinition(streamId);
                            } else if (callback == "outflow") {
                                onSuccessCreateOutflowStreamDefinition(streamId);
                            }
                        });
                        customCarbonWindowClose();
                    } else {
                        CARBON.showErrorDialog("이벤트 스트림 추가 실패, Exception: " + event.responseText.trim());
                    }
                }
            })
        }
    }
}

function getWSO2EventDataValues(dataTable) {

    var wso2EventData = "";
    for (var i = 1; i < dataTable.rows.length; i++) {

        var row = dataTable.rows[i];
        var column0 = row.cells[0].textContent;
        var column1 = row.cells[1].textContent;

        wso2EventData = wso2EventData + column0 + "^=" + column1 + "^=" + "$=";
    }
    return wso2EventData;
}

function addStreamAttribute(dataType) {
    var attributeName = document.getElementById("output" + dataType + "DataPropName");
    var attributeType = document.getElementById("output" + dataType + "DataPropType");
    var streamAttributeTable = document.getElementById("output" + dataType + "DataTable");
    var noStreamAttributesDiv = document.getElementById("noOutput" + dataType + "Data");

    var error = "";

    if (attributeName.value == "") {
        error = "속성명이 없습니다.\n";
    }

    if (attributeType.value == "") {
        error = "속성 타입이 없습니다\n";
    }

    if (error != "") {
        CARBON.showErrorDialog(error);
        return;
    }
    streamAttributeTable.style.display = "";


    var newTableRow = streamAttributeTable.insertRow(streamAttributeTable.rows.length);
    var newCell0 = newTableRow.insertCell(0);
    newCell0.innerHTML = attributeName.value;
    
    var newCell1 = newTableRow.insertCell(1);
    newCell1.innerHTML = attributeType.value;

    var newCel3 = newTableRow.insertCell(2);
    
    newCel3.innerHTML = ' <a class="delete" onclick="removeStreamAttribute(this,\'' + dataType + '\')"><i class="fa fa-trash"></i>삭제</a>';      
    YAHOO.util.Dom.addClass(newCel3, "fnc-btn");

    attributeName.value = "";
    noStreamAttributesDiv.style.display = "none";

}


function removeStreamAttribute(link, format) {
    var rowToRemove = link.parentNode.parentNode;
    var propertyToERemove = rowToRemove.cells[0].innerHTML.trim();
    rowToRemove.parentNode.removeChild(rowToRemove);
    CARBON.showInfoDialog("Stream Attribute removed successfully!!");
    return;
}

function generateEvent(eventStreamId) {

    var selectedIndex = document.getElementById("sampleEventTypeFilter").selectedIndex;
    var eventType = document.getElementById("sampleEventTypeFilter").options[selectedIndex].text;

    jQuery.ajax({
                    type:"POST",
                    url:"../hrta_eventstream/hrta_getSampleEvent_ajaxprocessor.jsp?streamId=" + eventStreamId + "&eventType=" + eventType + "",
                    data:{},
                    dataType:"text",
                    async:false,
                    success:function (sampleEvent) {
                        if (eventType == "xml") {
                            jQuery('#sampleEventText').val(vkbeautify.xml(sampleEvent.trim()));
                        }
                        else if (eventType == "json") {
                            jQuery('#sampleEventText').val(vkbeautify.json(sampleEvent.trim()));
                        } else {
                            jQuery('#sampleEventText').val(sampleEvent.trim());
                        }
                    }
                });

}


CARBON.customConfirmDialogBox = function (message, option1, option2, callback, closeCallback) {
    var strDialog = "<div id='dialog' title='HRTA 확인'><div id='messagebox-info' style='height:90px'><p>" +
                    message + "</p> <br/><input id='dialogRadio1' name='dialogRadio' type='radio' value='default' checked />" + option1 + "<br/> <input id='dialogRadio2' name='dialogRadio' type='radio' value='custom' />" + option2 + "</div></div>";
    var func = function () {
        jQuery("#dcontainer").html(strDialog);

        jQuery("#dialog").dialog({
                                     close:function () {
                                         jQuery(this).dialog('destroy').remove();
                                         jQuery("#dcontainer").empty();
                                         if (closeCallback && typeof closeCallback == "function") {
                                             closeCallback();
                                         }
                                         return false;
                                     },

                                     buttons:{
                                         "OK":function () {
                                             var value = jQuery('input[name=dialogRadio]:checked').val();
                                             jQuery(this).dialog("destroy").remove();
                                             jQuery("#dcontainer").empty();
                                             if (callback && typeof callback == "function") {
                                                 callback(value);
                                             }
                                             return false;
                                         },
                                         "Create Later":function(){
                                             jQuery(this).dialog('destroy').remove();
                                             jQuery("#dcontainer").empty();
                                             if (closeCallback && typeof closeCallback == "function") {
                                                 closeCallback();
                                             }
                                             return false;
                                         }
                                     },

                                     height:200,
                                     width:500,
                                     minHeight:200,
                                     minWidth:330,
                                     modal:true
                                 });
    };
    if (!pageLoaded) {
        jQuery(document).ready(func);
    } else {
        func();
    }

};




