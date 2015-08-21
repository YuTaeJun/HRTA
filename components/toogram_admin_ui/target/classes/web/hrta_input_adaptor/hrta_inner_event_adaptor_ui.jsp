<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.InputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.types.InputEventAdaptorPropertiesDto" %>
<%@ page import="org.wso2.carbon.event.input.adaptor.manager.stub.types.InputEventAdaptorPropertyDto" %>
<%@ page import="com.toogram.cep.ui.ToogramInputEventAdaptorUIUtils" %>
<%@ page import="com.toogram.cep.ui.utils.ToogramBundleUtils" %>


    <script type="text/javascript"
            src="../hrta_input_adaptor/js/create_event_adaptor_helper.js"></script>
<div class="detail-view">
    <table id="eventInputTable" class="detail">
	    <colgroup>
			<col style="width: 20%;">
			<col>
		</colgroup>    
        <tbody>
        <tr>
            <th>이벤트 아답터 명<span class="required">*</span> 
            </th>
            <td><input type="text" name="eventName" id="eventNameId"
                       onclick="clearTextIn(this)" onblur="fillTextIn(this)"
                       value=""
                       style="width:80%"/>
                <p><small>이벤트 어답터 명을 입력하세요</small></p>
            </td>
        </tr>
        <tr>
            <th>이벤트 어답터 타입<span class="required">*</span></th>
            <td><select name="eventTypeFilter"
                        onchange="showEventProperties('input.event.all.properties')"
                        id="eventTypeFilter">
                <%
                	InputEventAdaptorManagerAdminServiceStub stub = ToogramInputEventAdaptorUIUtils.getInputEventManagerAdminService(config, session, request ,response);
                    String[] eventNames = stub.getAllInputEventAdaptorTypeNames();
                    InputEventAdaptorPropertiesDto eventAdaptorPropertiesDto = null;
                    String firstEventName = null;
                    String supportedEventAdaptorType = null;
                    if (eventNames != null) {
                        firstEventName = eventNames[0];
                        eventAdaptorPropertiesDto = stub.getInputEventAdaptorProperties(firstEventName);
                        for (String type : eventNames) {
                %>
                <option><%=type%>
                </option>
                <%
                        }
                    }
                %>
            </select>
                <p><small>이벤트 어답터 타입을 선택하세요</small></p>
            </td>

        </tr>

        <%
            if ((eventAdaptorPropertiesDto.getInputEventAdaptorPropertyDtos()) != null) {

        %>
        <tr>
            <td colspan="2"><b>
                	상세 입력 항목</b>
            </td>
        </tr>

        <%
            }

            if (firstEventName != null) {

        %>


        <%
            //Input fields for input event adaptor properties
            if ((eventAdaptorPropertiesDto.getInputEventAdaptorPropertyDtos()) != null & firstEventName != null) {

                InputEventAdaptorPropertyDto[] inputEventProperties = eventAdaptorPropertiesDto.getInputEventAdaptorPropertyDtos();

                if (inputEventProperties != null) {
                    for (int index = 0; index < inputEventProperties.length; index++) {
        %>
        <tr>

            <th><%=ToogramBundleUtils.getInputAdaptorBundleText(inputEventProperties[index].getDisplayName())%>
                <%
                    String propertyId = "inputProperty_";
                    if (inputEventProperties[index].getRequired()) {
                        propertyId = "inputProperty_Required_";

                %>
                <span class="required">*</span>
                <%
                    }
                %>
            </th>
            <%
                String type = "text";
                if (inputEventProperties[index].getSecured()) {
                    type = "password";
                }
            %>

            <td>
                  <%

                      if (inputEventProperties[index].getOptions()[0] != null) {

                  %>

                  <select name="<%=inputEventProperties[index].getKey()%>"
                          id="<%=propertyId%><%=index%>">

                      <%
                          for (String property : inputEventProperties[index].getOptions()) {
                              if (property.equals(inputEventProperties[index].getDefaultValue())) {
                      %>
                      <option selected="selected"><%=property%>
                      </option>
                      <% } else { %>
                      <option><%=property%>
                      </option>
                      <% }
                      }%>
                  </select>

                  <% } else { %>
                  <input type="<%=type%>"
                         name="<%=inputEventProperties[index].getKey()%>"
                         id="<%=propertyId%><%=index%>"
                         style="width:80%"
                         value="<%= (inputEventProperties[index].getDefaultValue()) != null ? inputEventProperties[index].getDefaultValue() : "" %>"/>

                  <% }

                      if (inputEventProperties[index].getHint() != null) { %>                  
                  <p><small><%=ToogramBundleUtils.getInputAdaptorBundleText(inputEventProperties[index].getHint())%></small></p>
                  <% } %>                
            </td>

        </tr>
        <%
                        }
                    }
                }
            }
        %>

        </tbody>
    </table>
</div>