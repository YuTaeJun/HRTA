<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.OutputEventAdaptorManagerAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.types.OutputEventAdaptorPropertiesDto" %>
<%@ page import="org.wso2.carbon.event.output.adaptor.manager.stub.types.OutputEventAdaptorPropertyDto" %>            
<%@ page import="com.toogram.cep.ui.ToogramOutputEventAdaptorUIUtils" %>
<%@ page import="com.toogram.cep.ui.utils.ToogramBundleUtils" %>


    <script type="text/javascript" src="../hrta_output_adaptor/js/create_event_adaptor_helper.js"></script>
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
                        onchange="showEventProperties('output.event.all.propertie')"
                        id="eventTypeFilter">
                <%
                	OutputEventAdaptorManagerAdminServiceStub stub = ToogramOutputEventAdaptorUIUtils.getOutputEventManagerAdminService(config, session, request, response);
                    String[] eventNames = stub.getOutputEventAdaptorTypeNames();
                    OutputEventAdaptorPropertiesDto eventAdaptorPropertiesDto = null;
                    String firstEventName = null;
                    String supportedEventAdaptorType = null;
                    if (eventNames != null) {
                        firstEventName = eventNames[0];
                        eventAdaptorPropertiesDto = stub.getOutputEventAdaptorProperties(firstEventName);
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
            if ((eventAdaptorPropertiesDto.getOutputEventAdaptorPropertyDtos()) != null) {

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
            //Input fields for output event adaptor properties
            if ((eventAdaptorPropertiesDto.getOutputEventAdaptorPropertyDtos()) != null & firstEventName != null) {

                OutputEventAdaptorPropertyDto[] outputEventProperties = eventAdaptorPropertiesDto.getOutputEventAdaptorPropertyDtos();

                if (outputEventProperties != null) {
                    for (int index = 0; index < outputEventProperties.length; index++) {
        %>
        <tr>

            <th><%=ToogramBundleUtils.getOutputAdaptorBundleText(outputEventProperties[index].getDisplayName())%>
                <%
                    String propertyId = "outputProperty_";
                    if (outputEventProperties[index].getRequired()) {
                        propertyId = "outputProperty_Required_";

                %>
                <span class="required">*</span>
                <%
                    }
                %>
            </th>
            <%
                String type = "text";
                if (outputEventProperties[index].getSecured()) {
                    type = "password";
                }
            %>

            <td>
                  <%

                      if (outputEventProperties[index].getOptions()[0] != null) {

                  %>

                  <select name="<%=outputEventProperties[index].getKey()%>"
                          id="<%=propertyId%><%=index%>">

                      <%
                          for (String property : outputEventProperties[index].getOptions()) {
                              if (property.equals(outputEventProperties[index].getDefaultValue())) {
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
                         name="<%=outputEventProperties[index].getKey()%>"
                         id="<%=propertyId%><%=index%>"
                         style="width:80%"
                         value="<%= (outputEventProperties[index].getDefaultValue()) != null ? outputEventProperties[index].getDefaultValue() : "" %>"/>

                  <% }

                      if (outputEventProperties[index].getHint() != null) { %>                  
                  <p><small><%=ToogramBundleUtils.getOutputAdaptorBundleText(outputEventProperties[index].getHint())%></small></p>
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