function removeExportedStream(link) {
    var rowToRemove = link.parentNode.parentNode;
    rowToRemove.parentNode.removeChild(rowToRemove);
    CARBON.showInfoDialog("유출 스트림이 성공적으로 삭제되었습니다!!");
    return;
}


function removeImportedStreamDefinition(link) {
    var rowToRemove = link.parentNode.parentNode;
    rowToRemove.parentNode.removeChild(rowToRemove);
    CARBON.showInfoDialog("유입스트림이 성공적으로 삭제되었습니다!!");
    return;
}

function createEventBuilder(streamNameWithVersion) {
    if (streamNameWithVersion == '' || streamNameWithVersion == null) {
        CARBON.showErrorDialog("스트림 정의가 선택되지 않았습니다.");
        return;
    }
    new Ajax.Request('../hrta_eventbuilder/hrta_popup_create_event_builder_ajaxprocessor.jsp', {
        method:'POST',
        asynchronous:false,
        parameters:{streamNameWithVersion:streamNameWithVersion, redirectPage:"none"},
        onSuccess:function (data) {
            showCustomPopupDialog(data.responseText, "Create Event Builder", "80%", "", onSuccessCreateEventBuilder, "90%");
        }
    });
}

function createEventFormatter(streamId) {
    if (streamId != '' && streamId != null) {
        new Ajax.Request('../hrta_eventformatter/hrta_popup_create_event_formatter_ajaxprocessor.jsp', {
            method:'POST',
            parameters:{streamId:streamId, redirectPage:"none"},
            asynchronous:false,
            onSuccess:function (data) {
                showCustomPopupDialog(data.responseText, "이벤트 포멧터 생성", "80%", "", onSuccessCreateEventFormatter, "90%");
            }
        });
    }
}

/**
 * Display the Info Message inside a jQuery UI's dialog widget.
 * @method showPopupDialog
 * @param {String} message to display
 * @return {Boolean}
 */
function showCustomPopupDialog(message, title, windowHight, okButton, callback, windowWidth) {
    var strDialog = "<div id='custom_dialog' title='" + title + "'><div id='popupDialog'></div>" + message + "</div>";
    var requiredWidth = 750;
    if (windowWidth) {
        requiredWidth = windowWidth;
    }
    var func = function () {
        jQuery("#custom_dcontainer").hide();
        jQuery("#custom_dcontainer").html(strDialog);
        if (okButton) {
            jQuery("#custom_dialog").dialog({
                                                close:function () {
                                                    jQuery(this).dialog('destroy').remove();
                                                    jQuery("#custom_dcontainer").empty();
                                                    return false;
                                                },
                                                buttons:{
                                                    "OK":function () {
                                                        if (callback && typeof callback == "function") {
                                                            callback();
                                                        }
                                                        jQuery(this).dialog("destroy").remove();
                                                        jQuery("#custom_dcontainer").empty();
                                                        return false;
                                                    }
                                                },
                                                autoOpen:false,
                                                height:windowHight,
                                                width:requiredWidth,
                                                minHeight:windowHight,
                                                minWidth:requiredWidth,
                                                modal:true
                                            });
        } else {
            jQuery("#custom_dialog").dialog({
                                                close:function () {
                                                    if (callback && typeof callback == "function") {
                                                        callback();
                                                    }
                                                    jQuery(this).dialog('destroy').remove();
                                                    jQuery("#custom_dcontainer").empty();
                                                    return false;
                                                },
                                                autoOpen:false,
                                                height:windowHight,
                                                width:requiredWidth,
                                                minHeight:windowHight,
                                                minWidth:requiredWidth,
                                                modal:true
                                            });
        }

        jQuery('.ui-dialog-titlebar-close').click(function () {
            jQuery('#custom_dialog').dialog("destroy").remove();
            jQuery("#custom_dcontainer").empty();
            jQuery("#custom_dcontainer").html('');
        });
        jQuery("#custom_dcontainer").show();
        jQuery("#custom_dialog").dialog("open");
    };
    if (!pageLoaded) {
        jQuery(document).ready(func);
    } else {
        func();
    }

}


function onSuccessCreateEventFormatter() {
    refreshEventFormatterInfo("eventFormatter");
}

function onSuccessCreateEventBuilder() {
    refreshEventBuilderInfo("eventBuilder");
}

function onSuccessCreateInflowStreamDefinition(streamId) {
    refreshStreamDefInfo("importedStreamId");
    refreshStreamDefInfo("exportedStreamId");   
    CARBON.customConfirmDialogBox("정의된 이벤트 스트림은 이벤트 빌더를 사용하는 이벤트의 in flow에 존재합니다.\n이벤트 빌더를 생성하시겠습니까? ", "디폴트 WSO2 이벤트 빌더", "커스텀 이벤트 빌더", function (option) {
        if (option == "custom") {
            createEventBuilder(streamId);
        } else {
            new Ajax.Request('../hrta_eventbuilder/hrta_add_default_event_builder_ajaxprocessor.jsp', {
                method:'POST',
                asynchronous:false,
                parameters:{eventStreamId:streamId},
                onSuccess:function (response) {
                    if ("true" == response.responseText.trim()) {
                        CARBON.showInfoDialog("디폴트 이벤트 빌더가 추가되었습니다!!");
                    } else {
                        CARBON.showErrorDialog("이벤트 빌더 추가 실패, Exception: " + response.responseText.trim());
                    }
                }
            });
        }

    }, null);
}

function onSuccessCreateOutflowStreamDefinition(streamId) {
    refreshStreamDefInfo("importedStreamId");
    refreshStreamDefInfo("exportedStreamId");

    CARBON.customConfirmDialogBox("정의된 이벤트 스트림은 이벤트 포멧터를 사용하여 이벤트의 out flow를 생성할 수 있습니다.\n이벤트 포멧터를 생성하시겠습니까? ", "디폴트 LoggerAdaptor 이벤트 포멧터", "커스텀 이벤트 포멧터", function (option) {
        if (option == "custom") {
            createEventFormatter(streamId);
        } else {
            new Ajax.Request('../hrta_eventformatter/hrta_add_default_event_formatter_ajaxprocessor.jsp', {
                method:'POST',
                asynchronous:false,
                parameters:{eventStreamId:streamId},
                onSuccess:function (response) {
                    if ("true" == response.responseText.trim()) {
                        CARBON.showInfoDialog("디폴트 이벤트 포멧터가 추가되었습니다!!");
                    } else {
                        CARBON.showErrorDialog("이벤트 포멧터 추가 실패, Exception: " + response.responseText.trim());
                    }
                }
            });
        }

    }, null);
}


CARBON.customConfirmDialogBox = function (message, option1, option2, callback, closeCallback) {
    var strDialog = "<div id='dialog' title='HRTA 확인''><div id='messagebox-info' style='height:90px'><p>" +
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
                                         "Create Later":function () {
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


function refreshEventFormatterInfo(eventFormatterSelectId) {
    var eventFormatterSelect = document.getElementById(eventFormatterSelectId);
    new Ajax.Request('../hrta_eventformatter/hrta_get_active_event_formatters_ajaxprocessor.jsp', {
        method:'POST',
        asynchronous:false,
        onSuccess:function (event) {
            eventFormatterSelect.length = 0;
            // for each property, add a text and input field in a row
            var jsonArrEventFormatterNames = JSON.parse(event.responseText);
            for (i = 0; i < jsonArrEventFormatterNames.length; i++) {
                var eventFormatterName = jsonArrEventFormatterNames[i];
                if (eventFormatterName != undefined && eventFormatterName != "") {
                    eventFormatterName = eventFormatterName.trim();
                    eventFormatterSelect.add(new Option(eventFormatterName, eventFormatterName), null);
                }
            }

        }
    });
}

function refreshEventBuilderInfo(eventBuilderSelectId) {
    var eventBuilderSelect = document.getElementById(eventBuilderSelectId);
    new Ajax.Request('../hrta_eventbuilder/hrta_get_active_event_builders_ajaxprocessor.jsp', {
        method:'POST',
        asynchronous:false,
        onSuccess:function (event) {
            eventBuilderSelect.length = 0;
            // for each property, add a text and input field in a row
            var jsonArrEventBuilderNames = JSON.parse(event.responseText);
            for (i = 0; i < jsonArrEventBuilderNames.length; i++) {
                var eventBuilderName = jsonArrEventBuilderNames[i];
                if (eventBuilderName != undefined && eventBuilderName != "") {
                    eventBuilderName = eventBuilderName.trim();
                    eventBuilderSelect.add(new Option(eventBuilderName, eventBuilderName), null);
                }
            }

        }
    });
}

function refreshStreamDefInfo(streamDefSelectId) {
    var streamDefSelect = document.getElementById(streamDefSelectId);
    new Ajax.Request('../hrta_eventstream/hrta_get_stream_definitions_ajaxprocessor.jsp', {
        method:'POST',
        asynchronous:false,
        onSuccess:function (event) {
            streamDefSelect.length = 0;
            // for each property, add a text and input field in a row
            var jsonArrStreamDefIds = JSON.parse(event.responseText);
            for (i = 0; i < jsonArrStreamDefIds.length; i++) {
                var streamDefId = jsonArrStreamDefIds[i];
                if (streamDefId != undefined && streamDefId != "") {
                    streamDefId = streamDefId.trim();
                    streamDefSelect.add(new Option(streamDefId, streamDefId), null);
                }
            }
            streamDefSelect.add(new Option("-- Create Stream Definition --", "createStreamDef"), null);
        }
    });
}

function customCarbonWindowClose() {
    jQuery("#custom_dialog").dialog("destroy").remove();
}


var ENABLE = "enable";
var DISABLE = "disable";
var STAT = "statistics";
var TRACE = "Tracing";

function doDelete(executionPlanName) {
    var theform = document.getElementById('deleteForm');
    theform.executionPlan.value = executionPlanName;
    theform.submit();
}

function disableStat(execPlanName) {
    jQuery.ajax({
                    type:'POST',
                    url:'../hrta_eventprocessor/hrta_stats_tracing_ajaxprocessor.jsp',
                    data:'execPlanName=' + execPlanName + '&action=disableStat',
                    async:false,
                    success:function (msg) {
                        handleCallback(execPlanName, DISABLE, STAT);
                    },
                    error:function (msg) {
                        CARBON.showErrorDialog('통계 비활성화 에러' +
                                               ' ' + execPlanName);
                    }
                });
}

function enableStat(execPlanName) {
    jQuery.ajax({
                    type:'POST',
                    url:'../hrta_eventprocessor/hrta_stats_tracing_ajaxprocessor.jsp',
                    data:'execPlanName=' + execPlanName + '&action=enableStat',
                    async:false,
                    success:function (msg) {
                        handleCallback(execPlanName, ENABLE, STAT);
                    },
                    error:function (msg) {
                        CARBON.showErrorDialog('통계 활성화 에러' +
                                               ' ' + execPlanName);
                    }
                });
}

function handleCallback(execPlanName, action, type) {
    var element;
    if (action == "enable") {
        if (type == "statistics") {
            element = document.getElementById("disableStat" + execPlanName);
            element.style.display = "";
            element = document.getElementById("enableStat" + execPlanName);
            element.style.display = "none";
        } else {
            element = document.getElementById("disableTracing" + execPlanName);
            element.style.display = "";
            element = document.getElementById("enableTracing" + execPlanName);
            element.style.display = "none";
        }
    } else {
        if (type == "statistics") {
            element = document.getElementById("disableStat" + execPlanName);
            element.style.display = "none";
            element = document.getElementById("enableStat" + execPlanName);
            element.style.display = "";
        } else {
            element = document.getElementById("disableTracing" + execPlanName);
            element.style.display = "none";
            element = document.getElementById("enableTracing" + execPlanName);
            element.style.display = "";
        }
    }
}

function enableTracing(execPlanName) {
    jQuery.ajax({
                    type:'POST',
                    url:'../hrta_eventprocessor/hrta_stats_tracing_ajaxprocessor.jsp',
                    data:'execPlanName=' + execPlanName + '&action=enableTracing',
                    async:false,
                    success:function (msg) {
                        handleCallback(execPlanName, ENABLE, TRACE);
                    },
                    error:function (msg) {
                        CARBON.showErrorDialog('추적 활성화 에러' +
                                               ' ' + execPlanName);
                    }
                });
}

function disableTracing(execPlanName) {
    jQuery.ajax({
                    type:'POST',
                    url:'../hrta_eventprocessor/hrta_stats_tracing_ajaxprocessor.jsp',
                    data:'execPlanName=' + execPlanName + '&action=disableTracing',
                    async:false,
                    success:function (msg) {
                        handleCallback(execPlanName, DISABLE, TRACE);
                    },
                    error:function (msg) {
                        CARBON.showErrorDialog('추적 비활성화 에러' +
                                               ' ' + execPlanName);
                    }
                });
}

