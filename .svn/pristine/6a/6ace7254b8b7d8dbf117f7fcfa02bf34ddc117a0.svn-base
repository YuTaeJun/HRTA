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


// this function validate required fields if they are required fields,
// other fields are ignored.In addition to that, the values from each
// field is taken and appended to a string.
// string = propertyName + $ + propertyValue + | +propertyName...

// this function validate required fields if they are required fields,
// other fields are ignored.In addition to that, the values from each
// field is taken and appended to a string.
// string = propertyName + $ + propertyValue + | +propertyName...

function addEvent(form) {

    var parameters = getConfigurationProperties(form);
    
    //alert(parameters);

    var selectedIndex = document.getElementById("eventTypeFilter").selectedIndex;
    var selected_text = document.getElementById("eventTypeFilter").options[selectedIndex].text;
    var eventAdaptorName = (document.getElementById("eventNameId").value.trim());
    
    // ajax call for creating a event adaptor at backend, needed parameters are appended.

    new Ajax.Request('../hrta_output_adaptor/hrta_add_event_ajaxprocessor1.jsp', {
        method:'POST',
        asynchronous:false,
        parameters:{eventName:eventAdaptorName, eventType:selected_text,
            outputPropertySet:parameters},
        onSuccess:function (msg) {
            if ("true" == msg.responseText.trim()) {
                form.submit();
            } else {
                CARBON.showErrorDialog("이벤트 어답터 추가에 실패하였습니다., Exception: " + msg.responseText.trim());
            }
        }
    })
}

function testConnection(form) {

    var parameters = getConfigurationProperties(form);

    var selectedIndex = document.getElementById("eventTypeFilter").selectedIndex;
    var selected_text = document.getElementById("eventTypeFilter").options[selectedIndex].text;
    var eventAdaptorName = (document.getElementById("eventNameId").value.trim());
    if (eventAdaptorName != "") {
        var testConnectionEnabled = "true";
        // ajax call for creating a event adaptor at backend, needed parameters are appended.

        new Ajax.Request('../hrta_output_adaptor/hrta_add_event_ajaxprocessor.jsp', {
            method:'POST',
            asynchronous:false,
            parameters:{eventName:eventAdaptorName, eventType:selected_text,
                outputPropertySet:parameters, testConnection:testConnectionEnabled },
            onSuccess:function (msg) {
                if ("true" == msg.responseText.trim()) {
                    CARBON.showInfoDialog("Connection is successful");
                } else if("not-available" == msg.responseText.trim()){
                    CARBON.showWarningDialog("연결 테스트는 이 어답터에는 적용되지 않습니다");

                }else {
                    CARBON.showErrorDialog("접속 실패: " + msg.responseText.trim());
                }
            }
        })
    }
}

function getConfigurationProperties(form) {

    var isFieldEmpty = false;
    var outputParameterString = "";
    var outputPropertyCount = 0;

    // all output properties, not required and required are checked
    while (document.getElementById("outputProperty_Required_" + outputPropertyCount) != null ||
           document.getElementById("outputProperty_" + outputPropertyCount) != null) {
        // if required fields are empty
        if ((document.getElementById("outputProperty_Required_" + outputPropertyCount) != null)) {
            if (document.getElementById("outputProperty_Required_" + outputPropertyCount).value.trim() == "") {
                // values are empty in fields
                isFieldEmpty = true;
                outputParameterString = "";
                break;
            }
            else {
                // values are stored in parameter string to send to backend
                var propertyValue = document.getElementById("outputProperty_Required_" + outputPropertyCount).value.trim();
                var propertyName = document.getElementById("outputProperty_Required_" + outputPropertyCount).name;
                outputParameterString = outputParameterString + propertyName + "$=" + propertyValue + "|=";

            }
        } else if (document.getElementById("outputProperty_" + outputPropertyCount) != null) {
            var notRequriedPropertyValue = document.getElementById("outputProperty_" + outputPropertyCount).value.trim();
            var notRequiredPropertyName = document.getElementById("outputProperty_" + outputPropertyCount).name;
            if (notRequriedPropertyValue == "") {
                notRequriedPropertyValue = "  ";
            }
            outputParameterString = outputParameterString + notRequiredPropertyName + "$=" + notRequriedPropertyValue + "|=";


        }
        outputPropertyCount++;
    }

    var reWhiteSpace = new RegExp("^[a-zA-Z0-9_\.]+$");
    // Check for white space
    if (!reWhiteSpace.test(document.getElementById("eventNameId").value)) {
        CARBON.showErrorDialog("이벤트 어답터의 이름에 사용하실 수 없는 문자가 있습니다.");
        return;
    }
    if (isFieldEmpty || (document.getElementById("eventNameId").value.trim() == "")) {
        // empty fields are encountered.
        CARBON.showErrorDialog("입력 항목이 비어있습니다.");
        return;
    }
    else {
        return outputParameterString;
    }

}

function clearTextIn(obj) {
    if (YAHOO.util.Dom.hasClass(obj, 'initE')) {
        YAHOO.util.Dom.removeClass(obj, 'initE');
        YAHOO.util.Dom.addClass(obj, 'normalE');
        textValue = obj.value;
        obj.value = "";
    }
}
function fillTextIn(obj) {
    if (obj.value == "") {
        obj.value = textValue;
        if (YAHOO.util.Dom.hasClass(obj, 'normalE')) {
            YAHOO.util.Dom.removeClass(obj, 'normalE');
            YAHOO.util.Dom.addClass(obj, 'initE');
        }
    }
}

function showEventProperties(propertiesHeader) {

    var eventInputTable = document.getElementById("eventInputTable");
    var selectedIndex = document.getElementById("eventTypeFilter").selectedIndex;
    var selected_text = document.getElementById("eventTypeFilter").options[selectedIndex].text;

    // delete all rows except first two; event name, event type
    for (i = eventInputTable.rows.length - 1; i > 1; i--) {
        eventInputTable.deleteRow(i);
    }

    jQuery.ajax({
                    type:"POST",
                    url:"../hrta_output_adaptor/hrta_get_properties_ajaxprocessor.jsp?eventType=" + selected_text + "",
                    data:{},
                    contentType:"application/json; charset=utf-8",
                    dataType:"text",
                    async:false,
                    success:function (msg) {
                        if (msg != null) {

                            var jsonObject = JSON.parse(msg);
                            var outputEventProperties = jsonObject.localOutputEventAdaptorPropertyDtos;

                            var tableRow = eventInputTable.insertRow(eventInputTable.rows.length);

                            if (outputEventProperties != undefined) {
                                var eventOutputPropertyLoop = 0;
                                var outputProperty = "outputProperty_";
                                var outputRequiredProperty = "outputProperty_Required_";
                                var outputOptionProperty = "outputOptionProperty";

                                tableRow.innerHTML = '<td colspan="2" ><b>' + "이벤트 입력 프로퍼티" + '</b></td> ';

                                jQuery.each(outputEventProperties, function (index,
                                                                             outputEventProperty) {

                                    loadEventProperties('output', outputEventProperty, eventInputTable, eventOutputPropertyLoop, outputProperty, outputRequiredProperty, 'outputFields')
                                    eventOutputPropertyLoop = eventOutputPropertyLoop + 1;

                                });
                            }
                        }
                    }
                });
}

//hash map
Map = function(){
	this.map = new Object();
};   
Map.prototype = {   
    put : function(key, value){   
        this.map[key] = value;
    },   
    get : function(key){   
        return this.map[key];
    },
    containsKey : function(key){    
     return key in this.map;
    },
    containsValue : function(value){    
     for(var prop in this.map){
      if(this.map[prop] == value) return true;
     }
     return false;
    },
    isEmpty : function(key){    
     return (this.size() == 0);
    },
    clear : function(){   
     for(var prop in this.map){
      delete this.map[prop];
     }
    },
    remove : function(key){    
     delete this.map[key];
    },
    keys : function(){   
        var keys = new Array();   
        for(var prop in this.map){   
            keys.push(prop);
        }   
        return keys;
    },
    values : function(){   
     var values = new Array();   
        for(var prop in this.map){   
         values.push(this.map[prop]);
        }   
        return values;
    },
    size : function(){
      var count = 0;
      for (var prop in this.map) {
        count++;
      }
      return count;
    }
};

var map = new Map();

function fillOutputAdaptorBundle() {	
	if(map.isEmpty()) {
		map.put("Authenticator URL","인증 URL");
		map.put("Auto Subscribe","자동등록");
		map.put("Cluster Name","클러스터명");
		map.put("Column Family Name","컬럼 페밀리 명");
		map.put("Column Qualifier","컬럼 Qualifier");
		map.put("Connection Factory JNDI Name","Connection Factory JNDI Name");
		map.put("Custom HTTP headers, e.g. \"header1: value1, header2: value2\"","자체 HTTP 헤더, 예 \"header1: value1, header2: value2\"");
		map.put("Data Source Name","데이터 소스명");
		map.put("Database Name","데이터 베이스 명");
		map.put("Default Subject","기본 제목");
		map.put("Destination","목적지");
		map.put("Destination Type","목적지 유형");
		map.put("Durable Subscriber Name","Durable Subscription 명");
		map.put("Email Address","메일주소");
		map.put("Enable Durable Subscription","Durable Subscription 허용");
		map.put("Enter the Authenticator Url","인증자 Url을 입력하세요");
		map.put("Enter the Password","페스워드를 입력하세요");
		map.put("Enter the Receiver Url","수신자 Url을 입력하세요");
		map.put("Enter the UserName","사용자 명을 입력하세요");
		map.put("HBase Configuration Path","HBase 설정 경로");
		map.put("Header","헤더");
		map.put("Headers","헤더");
		map.put("Host Name","호스트명");
		map.put("HTTP BasicAuth password","HTTP 기본인증 패스워드");
		map.put("HTTP BasicAuth username","HTTP 기본인증 사용자명");
		map.put("Index All Columns","전체 컬럼 인덱싱");
		map.put("IP Address","IP 주소");
		map.put("JNDI Initial Context Factory Class","JNDI Initial Context Factory Class");
		map.put("JNDI initial context factory class. The class must implement the java.naming.spi.InitialContextFactory interface.","JNDI initial context factory class. java.naming.spi.InitialContextFactory interface를 상속 받아야 함");
		map.put("JNDI Name","JNDI 이름");
		map.put("JNDI Password","JNDI 비밀번호");
		map.put("JNDI Provider URL","JNDI Provider URL");
		map.put("JNDI Username","JNDI 사용자명");
		map.put("Keyspace Name","키스페이스 명");
		map.put("Name of the Cassandra cluster","카산드라 클러스터 명");
		map.put("Name of the durable subscriber.","Durable Subscription 적용시 설정 명");
		map.put("Name of the MySQL database","MySQL 데이터베이스 명");
		map.put("Password","비밀번호");
		map.put("Path of the configuration file of HBase database","HBase database 설정 파일 경로");
		map.put("Phone No","전화번호");
		map.put("Phone No where SMS needs to be send (eg: [country-code][number])","SMS 수신 전화번호");
		map.put("Port","Port");
		map.put("Provider URL","프로바이더 URL");
		map.put("Proxy Host","Proxy Host");
		map.put("Proxy Port","Proxy Port");
		map.put("Receiver URL","수신자 URL");
		map.put("Server Name","서버명");
		map.put("Stream Definition","스트림 정의");
		map.put("Stream Name","스트림명");
		map.put("Stream Version","스트림 버전");
		map.put("Subject","제목");
		map.put("Table Name","테이블 명");
		map.put("The default outgoing email subject","발송시 기본 설정 제목");
		map.put("The JNDI name of the connection factory.","JMS 접속을 위한 Connection Factory JNDI Name");
		map.put("The proxy server host","프록시 서버 호스트");
		map.put("The proxy server port","프록시 서버 포트");
		map.put("The target HTTP/HTTPS URL, e.g. \"http://yourhost:8080/service\"","HTTP/HTTPS URL, 예.\"http://yourhost:8080/service\"");
		map.put("This will be the operation name for the EventBrokerService","EventBrokerService 이름");
		map.put("This will be the unique identification for subscription","서브크립션에 대한 고유 인증값입니다.");
		map.put("Topic","토픽");
		map.put("Type of the destination.","JMS 목적지의 유형");
		map.put("URI of the WS Event Server (E.g. WSO2 MB)","WS 이벤트 서버를 위한 URI (E.g. WSO2 MB)");
		map.put("URI","URI");
		map.put("URL","URL");
		map.put("URL of the JNDI provider.","JNDI provider URL");
		map.put("User Name","사용자명");
		map.put("Username","사용자명");
		map.put("Virtual Host Name","가상 호스트명");
		map.put("Whether the subscription is durable or not.","Durable Subscription 허용 여부");
	}
} 

//replace english label to koream
function changeToKoreanLabel(displayName) {
	fillOutputAdaptorBundle();
	value = map.get(displayName);
	
	if( value == null || value.length < 1) return displayName;
	
	return value;
}

function loadEventProperties(propertyType, eventProperty, eventInputTable,
eventPropertyLoop, propertyValue, requiredValue, classType
) {

        var property = eventProperty.localDisplayName.trim();
        var tableRow = eventInputTable.insertRow(eventInputTable.rows.length);
        
        //insert cell을 하면 tb로만 추가되기 때문에 아래와 같이 createElement 로 바꾸었다.
        //var textLabel = tableRow.insertCell(0);        
        var textLabel = document.createElement('th');
        
        var displayName = changeToKoreanLabel(eventProperty.localDisplayName.trim());
        textLabel.innerHTML = displayName;
        var requiredElementId = propertyValue;
        var textPasswordType = "text";
        var hint = ""
        var defaultValue = "";

        if (eventProperty.localRequired) {
        textLabel.innerHTML = displayName + '<span class="required">*</span>';
        requiredElementId = requiredValue;
        }
        
        //만들어딘 th를 추가한다. 기존의 insertCell을 한번에 되지만 별도의 작업이 필요하다.
        tableRow.appendChild(textLabel);

if (eventProperty.localSecured) {
        textPasswordType = "password";
        }

if (eventProperty.localHint != "") {
        hint = changeToKoreanLabel(eventProperty.localHint.trim());
        }

if (eventProperty.localDefaultValue != undefined && eventProperty.localDefaultValue != "") {
        defaultValue = eventProperty.localDefaultValue;
        }


var inputField = tableRow.insertCell(1);
if (eventProperty.localOptions == '') {

        if (hint != undefined) {
        inputField.innerHTML = '<input style="width:80%" type="' + textPasswordType + '" id="' + requiredElementId + eventPropertyLoop + '" name="' + eventProperty.localKey + '" value="' + defaultValue + '" /> <br/> <p><small>' + hint + '</small></p>';
        }
else {
        inputField.innerHTML = '<input style="width:80%" type="' + textPasswordType + '" id="' + requiredElementId + eventPropertyLoop + '" name="' + eventProperty.localKey + '" value="' + defaultValue + '" />';
        }
}

else {

        var option = '';
    jQuery.each(eventProperty.localOptions, function (index, localOption) {
        if (localOption == eventProperty.localDefaultValue) {
        option = option + '<option selected=selected>' + localOption + '</option>';
        }
else {
        option = option + '<option>' + localOption + '</option>';
        }

});


if (hint != undefined) {
        inputField.innerHTML = '<select  id="' + requiredElementId + eventPropertyLoop + '" name="' + eventProperty.localKey + '" />' + option + ' <br/> <p><small>' + hint + '</small></p>';
        }
else {
        inputField.innerHTML = '<select  id="' + requiredElementId + eventPropertyLoop + '" name="' + eventProperty.localKey + '" />' + option;
        }
}
}


////
function loadEventProperties(propertyType, eventProperty, eventInputTable, eventPropertyLoop,
        propertyValue, requiredValue, classType) {

	var property = eventProperty.localDisplayName.trim();
    var tableRow = eventInputTable.insertRow(eventInputTable.rows.length);
    
    //insert cell을 하면 tb로만 추가되기 때문에 아래와 같이 createElement 로 바꾸었다.
    //var textLabel = tableRow.insertCell(0);        
    var textLabel = document.createElement('th');
    
    /*
    var displayName = changeToKoreanLabel(eventProperty.localDisplayName.trim());
    textLabel.innerHTML = displayName;
    var requiredElementId = propertyValue;
    var textPasswordType = "text";
    var hint = ""
    var defaultValue = "";

    if (eventProperty.localRequired) {
    textLabel.innerHTML = displayName + '<span class="required">*</span>';
    requiredElementId = requiredValue;
    }
    */
    
    var displayName = changeToKoreanLabel(eventProperty.localDisplayName.trim());
    textLabel.innerHTML = displayName;
    var requiredElementId = propertyValue;
    var textPasswordType = "text";
    var hint = ""
    var defaultValue = "";

    if (eventProperty.localRequired) {
    textLabel.innerHTML = displayName + '<span class="required">*</span>';
    requiredElementId = requiredValue;
    }
    
    //만들어딘 th를 추가한다. 기존의 insertCell을 한번에 되지만 별도의 작업이 필요하다.
    tableRow.appendChild(textLabel);
	
	if (eventProperty.localSecured) {
		textPasswordType = "password";
	}
	
	if (eventProperty.localHint != "") {
		hint = eventProperty.localHint;
	}
	
	if (eventProperty.localDefaultValue != undefined && eventProperty.localDefaultValue != "") {
		defaultValue = eventProperty.localDefaultValue;
	}
	
	
	var outputField = tableRow.insertCell(1);
	
	if (eventProperty.localOptions == '') {
	
	if (hint != undefined) {
		outputField.innerHTML = '<input style="width:80%" type="' + textPasswordType + '" id="' + requiredElementId + eventPropertyLoop + '" name="' + eventProperty.localKey + '" value="' + defaultValue + '" /> <br/> <p><small>' + hint + '</small></p>';
	}
	else {
		outputField.innerHTML = '<input style="width:80%" type="' + textPasswordType + '" id="' + requiredElementId + eventPropertyLoop + '" name="' + eventProperty.localKey + '" value="' + defaultValue + '" />';
	}
	}
	
	else {
	
	var option = '';
	jQuery.each(eventProperty.localOptions, function (index, localOption) {
		if (localOption == eventProperty.localDefaultValue) {
			option = option + '<option selected=selected>' + localOption + '</option>';
		}
		else {
			option = option + '<option>' + localOption + '</option>';
		}
	
	});
	
	
	if (hint != undefined) {
		outputField.innerHTML = '<select  id="' + requiredElementId + eventPropertyLoop + '" name="' + eventProperty.localKey + '" />' + option + ' <br/> <p><small>' + hint + '</small></p>';
		}
	else {
		outputField.innerHTML = '<select  id="' + requiredElementId + eventPropertyLoop + '" name="' + eventProperty.localKey + '" />' + option;
		}
	}
}
