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

function addEvent(form) {
	
    var isFieldEmpty = false;
    var inputParameterString = "";
    var inputPropertyCount = 0;

    // all input properties, not required and required are checked
    while (document.getElementById("inputProperty_Required_" + inputPropertyCount) != null ||
    document.getElementById("inputProperty_" + inputPropertyCount) != null) {
    	// if required fields are empty
    if ((document.getElementById("inputProperty_Required_" + inputPropertyCount) != null) ) {
    if (document.getElementById("inputProperty_Required_" + inputPropertyCount).value.trim() == "") {
    	// values are empty in fields
    isFieldEmpty = true;
    inputParameterString = "";
    break;
    }
	else {
	    // values are stored in parameter string to send to backend
	        var propertyValue = document.getElementById("inputProperty_Required_" + inputPropertyCount).value.trim();
	        var propertyName = document.getElementById("inputProperty_Required_" + inputPropertyCount).name;
	        inputParameterString = inputParameterString + propertyName + "$=" + propertyValue + "|=";
	
	        }
	} else if (document.getElementById("inputProperty_" + inputPropertyCount) != null) {
	        var notRequriedPropertyValue = document.getElementById("inputProperty_" + inputPropertyCount).value.trim();
	        var notRequiredPropertyName = document.getElementById("inputProperty_" + inputPropertyCount).name;
	        if (notRequriedPropertyValue == "") {
	        notRequriedPropertyValue = "  ";
	        }
	inputParameterString = inputParameterString + notRequiredPropertyName + "$=" + notRequriedPropertyValue + "|=";

	//alert("2?");

	}
	inputPropertyCount++;
	}
	
	var reWhiteSpace = new RegExp("^[a-zA-Z0-9_]+$");
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
	    // create parameter string
	        var selectedIndex = document.getElementById("eventTypeFilter").selectedIndex;
	        var selected_text = document.getElementById("eventTypeFilter").options[selectedIndex].text;
	
	        var eventAdaptorName = (document.getElementById("eventNameId").value.trim());
	        
	        //alert("3?");
	
	    new Ajax.Request('../hrta_input_adaptor/hrta_add_event_ajaxprocessor.jsp', {
	        method: 'post',
	        asynchronous: false,
	        parameters: {eventName: eventAdaptorName, eventType: selected_text,
	            inputPropertySet: inputParameterString},
	        onSuccess: function (msg) {
	            if ("true" == msg.responseText.trim()) {
	                form.submit();
	            } else {
	                CARBON.showErrorDialog("이벤트 어답터 추가 실패, Exception: " + msg.responseText.trim());
	            }
	        }
	    })
	
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

// event adaptor properties are taken from back-end and render according to fields
function showEventProperties(propertiesHeader) {

        var eventInputTable = document.getElementById("eventInputTable");
//    jQuery('input[name=eventTypeFilter]').val()
        var selectedIndex = document.getElementById("eventTypeFilter").selectedIndex;
        var selected_text = document.getElementById("eventTypeFilter").options[selectedIndex].text;

    // delete all rows except first two; event name, event type
        for (i = eventInputTable.rows.length - 1; i > 1; i--) {
        eventInputTable.deleteRow(i);
        }

    jQuery.ajax({
        type:"POST",
        url:"../hrta_input_adaptor/hrta_get_properties_ajaxprocessor.jsp?eventType=" + selected_text + "",
        data:{},
		contentType:"application/json; charset=utf-8",
		dataType:"text",
		async:false,
		success:function (msg) {
	        if (msg != null) {
	
	        	var jsonObject = JSON.parse(msg);
		        var inputEventProperties = jsonObject.localInputEventAdaptorPropertyDtos;
		
		        var tableRow = eventInputTable.insertRow(eventInputTable.rows.length);
		        if (inputEventProperties != undefined) {
		        var eventInputPropertyLoop = 0;
		        var inputProperty = "inputProperty_";
		        var inputRequiredProperty = "inputProperty_Required_";
		        var inputOptionProperty = "inputOptionProperty";
		
		        tableRow.innerHTML = '<td colspan="2" ><b>'+"이벤트 입력 프로퍼티"+'</b></td> ';
		
		        jQuery.each(inputEventProperties, function (index,inputEventProperty) {
			        loadEventProperties('input', inputEventProperty, eventInputTable, eventInputPropertyLoop, inputProperty, inputRequiredProperty, 'inputFields')
			        eventInputPropertyLoop = eventInputPropertyLoop + 1;
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

function fillInputAdaptorBundle() {	
	if(map.isEmpty()) {
		map.put("Email Address","메일주소");
		map.put("Subject","제목");
		map.put("Default Subject","기본 제목");
		map.put("The default outgoing email subject","발송시 기본 설정 제목");
		map.put("Receiving Mail Address","메일 수신 주소");
		map.put("The mail address from which this service should fetch incoming mails.","송신된 메일을 가져올 메일 주소");
		map.put("Receiving Mail Protocol","메일 프로토콜");
		map.put("The mail protocol to be used to receive messages.","메일을 수신하기 위한 메일 프로토콜");
		map.put("Poll Interval (in seconds)","풀링 주기");
		map.put("A positive integer","1보다 큰 정수");
		map.put("Receiving Mail Protocol Host","메일 서버 호스트");
		map.put("Receiving Mail Protocol Port","메일 서버 포트");
		map.put("User Name","사용자명");
		map.put("Password","비밀번호");
		map.put("Receiving Mail Protocol Port SocketFactory Class","메일 수신 서버의 Port SocketFactory Class");
		map.put("Receiving Mail Protocol Port SocketFactory Fallback","메일 수신 서버의 Port SocketFactory Fallback");
		map.put("Email Service Name","E-mail 서비스명");
		map.put("Receiving email subject must be \"SOAPAction: urn:{Email Service Name}\"","송신 메일의 주소는 반드시 \"SOAPAction: urn:{Email Service Name}\" 형식이어야 함");
		map.put("File path","파일 경로");
		map.put("Eg: /home/cep/cep_3.0.0/wso2cep-3.0.0/repository/logs/wso2carbon.log","예: /home/cep/cep_3.0.0/wso2cep-3.0.0/repository/logs/wso2carbon.log");
		map.put("Topic","토픽");
		map.put("JNDI Initial Context Factory Class","JNDI Initial Context Factory Class");
		map.put("JNDI initial context factory class. The class must implement the java.naming.spi.InitialContextFactory interface.","JNDI initial context factory class. java.naming.spi.InitialContextFactory interface를 상속 받아야 함");
		map.put("JNDI Provider URL","JNDI Provider URL");
		map.put("URL of the JNDI provider.","JNDI provider URL");
		map.put("The JMS connection username","JMS 접속 사용자명");
		map.put("The JMS connection password","JMS 접속 패스워드");
		map.put("Connection Factory JNDI Name","Connection Factory JNDI Name");
		map.put("The JNDI name of the connection factory.","JMS 접속을 위한 Connection Factory JNDI Name");
		map.put("Enable Durable Subscription","Durable Subscription 허용");
		map.put("Whether the subscription is durable or not.","Durable Subscription 허용 여부");
		map.put("Durable Subscriber Name","Durable Subscription 명");
		map.put("Name of the durable subscriber.","Durable Subscription 적용시 설정 명");
		map.put("Destination Type","목적지 유형");
		map.put("Type of the destination.","JMS 목적지의 유형");
		map.put("Topic/Queue Name","Topic/Queue Name");
		map.put("Topic/Queue name of the input stream","인풋 스트림으로 전달될 Topic/Queue Name");
		map.put("Stream Version","스트림 버전");
		map.put("This where event needs to be send","이벤트가 전달될 위치");
		map.put("Topic","토픽");
		map.put("This will be the operation name for the EventBrokerService","EventBrokerService 이름");
		map.put("URI","URI");
		map.put("URI of the WS Event Server (E.g. WSO2 MB)","WS 이벤트 서버를 위한 URI (E.g. WSO2 MB)");
		map.put("Stream Name","스트림명");
	}
} 

//replace english label to koream
function changeToKoreanLabel(displayName) {
	fillInputAdaptorBundle();
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
			
	        hint = changeToKoreanLabel(eventProperty.localHint);
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
