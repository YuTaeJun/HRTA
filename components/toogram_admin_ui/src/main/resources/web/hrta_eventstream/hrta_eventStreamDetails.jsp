<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>
<%@ page import="com.toogram.cep.ui.ToogramEventStreamUIUtils" %>



<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>
<script type="text/javascript" src="../ajax/js/prototype.js"></script>

<script type="text/javascript" src="../hrta_eventstream/js/vkbeautify.0.99.00.beta.js"></script>
<script type="text/javascript" src="../hrta_eventstream/js/event_stream.js"></script>
<script type="text/javascript" src="../hrta_eventstream/js/create_eventStream_helper.js"></script>


    <%
        String eventStreamWithVersion = request.getParameter("eventStreamWithVersion");
    %>

    <script type="text/javascript">
        jQuery(document).ready(function () {
            formatSampleEvent();
        });

        function formatSampleEvent() {
            var selectedIndex = document.getElementById("sampleEventTypeFilter").selectedIndex;
            var eventType = document.getElementById("sampleEventTypeFilter").options[selectedIndex].text;

            var sampleEvent = document.getElementById("sampleEventText").value.trim();

            if (eventType == "xml") {
                jQuery('#sampleEventText').val(vkbeautify.xml(sampleEvent.trim()));
            }
            else if (eventType == "json") {
                jQuery('#sampleEventText').val(vkbeautify.json(sampleEvent.trim()));
            }
        }
    </script>

    
<div id="cols">
	<p id="breadCurmb">
		Home &gt; 이벤트 스트림 &gt; 이벤트 속성보기						
	</p>
	<div class="hgroup">
		<h1>이벤트 스트림 속성 -<%=eventStreamWithVersion%></h1>
	</div>
	        
     <div class="act">
     	<h2>이벤트 스트림 설정</h2>
			<div class="detail-view">
				<form name="eventStreamInfo" action="../hrta_eventstream/hrta_eventStream.jsp?ordinal=1" method="post" id="showEventStream">
					<table id="eventStreamInfoTable" class="detail">
						<colgroup>
							<col style="width: 20%" />
							<col />
						</colgroup>                    
                    	<tbody>
                    	<%

                        if (eventStreamWithVersion != null) {
                        EventStreamAdminServiceStub stub = ToogramEventStreamUIUtils.getEventStreamAdminService(config, session, request ,response);
                        String[] eventAdaptorPropertiesDto = stub.getStreamDetailsForStreamId(eventStreamWithVersion);
                        %>
                    		<tr>
                        		<th>이벤트 스트림 정의</th>
                                <td>                                	
                                <textArea class="expandedTextarea" id="streamDefinitionText"
                                            name="streamDefinitionText"
                                            readonly="true"
                                            cols="120"
                                            style="height:350px;"><%=eventAdaptorPropertiesDto[0]%>
								</textArea>                              
                               </td>
                            </tr>
                             <tr>
                                    <th>셈플 이벤트 생성</th>
                                    <td>
	                                    <select name="sampleEventTypeFilter"
	                                                id="sampleEventTypeFilter">
	                                        <option>xml</option>
	                                        <option>json</option>
	                                        <option>text</option>
                                    	</select>
	                                   	<button type="button" class="btn" onclick="generateEvent('<%=eventStreamWithVersion%>')"/>
	                                    		<i class="fa fa-file-code-o"></i>생성하기</button>
	                                    <div class="act">
		                                    <textArea class="expandedTextarea" id="sampleEventText"
		                                                  name="sampleEventText"
		                                                  readonly="true"
		                                                  cols="120"><%=eventAdaptorPropertiesDto[1]%>
		                                    </textArea>	
	                                    </div>
	                                 </td>                                                                                                              
                             </tr>
                                <%
                                    }
                                %>
                                
						</tbody>
                </table>
            </form>
        </div>
    </div>