<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

<script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>

<script type="text/javascript" src="../hrta_eventstream/js/event_stream.js"></script>
<script type="text/javascript" src="../hrta_eventstream/js/create_eventStream_helper.js"></script>
<script type="text/javascript" src="../hrta_eventbuilder/js/create_event_builder_helper.js"></script>
<script type="text/javascript" src="../ajax/js/prototype.js"></script>


    <div id="cols">
        <p id="breadCurmb">
		Home &gt; 이벤트 스트림 &gt; 이벤트 스트림 생성								
		</p>
		<div class="hgroup">
			<h1>신규 이벤트 스트림 생성</h1>
		</div>
		<div id="custom_dcontainer" style="display:none"></div>
        <div class="act">
            <form name="inputForm" action="../hrta_eventstream/hrta_eventStream.jsp?ordinal=1" method="post" id="addEventStream">
            	<div class="act">            	
	                <table id="eventAdd" class="styledVertical">
	                	<thead>
							<tr>
								<th>이벤트 스트림 상세 내역 입력</th>
							</tr>
						</thead>
						<tbody>
							<tr>
		                        <td>
		                            <%@include file="../hrta_eventstream/hrta_inner_event_stream_ui.jsp" %>
		                        </td>
							</tr>					
						</tbody>
					</table>
				</div>				
                
	            <input type="button" class="btn" value="추가" onclick="addEventStream(document.getElementById('addEventStream'),'add')"/>
				
            </form>
        </div>
    </div>
