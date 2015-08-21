<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.EventStreamAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.stream.manager.stub.types.EventStreamInfoDto" %>
<%@ page import="com.toogram.cep.ui.ToogramEventStreamUIUtils" %>


<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

    <script type="text/javascript">

        var ENABLE = "enable";
        var DISABLE = "disable";
        var STAT = "statistics";
        var TRACE = "Tracing";

        function doDelete(eventStreamName, eventStreamVersion) {
            CARBON.showConfirmationDialog(" 만약 이벤트 스트림을 삭제하신다면 이 스트림을 사용하는 다른 영역이 비 활성회 됩니다. 삭제하시길 원하십니까?", function () {
                        var theform = document.getElementById('deleteForm');
                        theform.eventStream.value = eventStreamName;
                        theform.eventStreamVersion.value = eventStreamVersion;
                        theform.submit();
                    }, null, null);
        }

    </script>
    <%
        EventStreamAdminServiceStub stub = ToogramEventStreamUIUtils.getEventStreamAdminService(config, session, request ,response);
        String eventStreamName = request.getParameter("eventStream");
        String eventStreamVersion = request.getParameter("eventStreamVersion");
        int totalEventStreams = 0;
        if (eventStreamName != null && eventStreamVersion != null) {
            stub.removeEventStreamInfo(eventStreamName, eventStreamVersion);
    %>
    <script type="text/javascript">CARBON.showInfoDialog("이밴트 스트림 삭제 완료");</script>
    <%
        }

        EventStreamInfoDto[] eventStreamDetailsArray = stub.getAllEventStreamInfoDto();
        if (eventStreamDetailsArray != null) {
            totalEventStreams = eventStreamDetailsArray.length;
        }

    %>

<div id="cols">
	<p id="breadCurmb">
		Home &gt; 이벤트 스트림 &gt; 이벤트 스트림 목록						
	</p>
	<div class="hgroup">
		<h1>현재 사용가능한 이벤트 스트림</h1>
	</div>
	        
     <div class="act">
		<h2>이벤트 스트림 생성</h2>
		<p class="fnc-set">
			<a href="../hrta_eventstream/hrta_create_event_stream.jsp?ordinal=1" class="btn-add"><i class="fa fa-plus-circle fa-2"></i>스트림 추가</a>
			<span class="side-btn">
				<a href="../hrta_eventbuilder/hrta_eventbuilder.jsp?ordinal=1" class="btn-build"><i class="fa fa-bug fa-2"></i>이벤트 빌더 목록</a>
				<a href="../hrta_eventformatter/hrta_eventformatter.jsp?ordinal=1" class="btn-formater"><i class="fa fa-cogs fa-2"></i>이벤트 포멧터 목록</a>
			</span>
		</p>
		
		<p class="lead-t"><%=totalEventStreams%> 개의 Active 상태 이벤트 스트림 </p>
		<br/>
			<table class="styledVertical">
		         <%
		
		             if (eventStreamDetailsArray != null) {
		         %>                
            	<thead>
					<tr>
						<th>스트림 명</th>
						<th>설영</th>
						<th>수정</th>
					</tr>
				</thead>
	            <tbody>
		            <%
		             for (EventStreamInfoDto eventStreamInfoDto : eventStreamDetailsArray) {
		                 String eventStreamWithVersion = eventStreamInfoDto.getStreamName() + ":" + eventStreamInfoDto.getStreamVersion();
		         %>
		         <tr class="tableOddRow">
		             <td>
		                 <a href="../hrta_eventstream/hrta_eventStreamDetails.jsp?ordinal=1&eventStreamWithVersion=<%=eventStreamWithVersion%>"><%=eventStreamWithVersion%>
		                 </a>
		             </td>
		             <td><%= eventStreamInfoDto.getStreamDescription() != null ? eventStreamInfoDto.getStreamDescription() : "" %>
		             </td>                    
		             <td class="fnc-btn">
		             	<a href="../hrta_eventstream/hrta_stream_in_flows.jsp?ordinal=1&eventStreamWithVersion=<%=eventStreamWithVersion%>" class="statics"><i class="fa fa-line-chart"></i>유입 Flow</a>
						<a href="../hrta_eventstream/hrta_stream_out_flows.jsp?ordinal=1&eventStreamWithVersion=<%=eventStreamWithVersion%>" class="tracing"><i class="fa fa-search"></i>유출 Flow</a>                    
						<a class="delete" onclick="doDelete('<%=eventStreamInfoDto.getStreamName()%>','<%=eventStreamInfoDto.getStreamVersion()%>')"><i class="fa fa-trash"></i>삭제</a>
						<a class="edit" href="../hrta_eventstream/hrta_edit_event_stream.jsp?ordinal=1&eventStreamWithVersion=<%=eventStreamWithVersion%>">
								<i class="fa fa-pencil-square-o"></i>수정</a>
					</td>
	           </tr>
	           </tbody>
		           <%
		             }
		
		         } else {
		         %>
		
		           <tbody>
		           <tr class="tableOddRow">
			            <div class="act">
							<div class="con-area">
								사용 가능 스트림이 없습니다.
							</div>
						</div>
		           </tr>
		           </tbody>
		           <%
		             }
		         %>		
		    </table>            
		    <div>
		  <br/>
		  <form id="deleteForm" name="input" action="" method="post">
		  	<input type="HIDDEN" name="eventStream" value=""/>
		  	<input type="HIDDEN" name="eventStreamVersion" value="">
	  	</form>
		</div>
	</div>
</div>