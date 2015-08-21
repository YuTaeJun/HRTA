<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>


<!-- WSO2 using js -->
<script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>

    <%
        String eventStreamWithVersion = request.getParameter("eventStreamWithVersion");
        String loadingCondition = "exportedStreams";
    %>

<div id="cols">
	<p id="breadCurmb">
		Home &gt; 이벤트 스트림 &gt; 이벤트 스트림 목록						
	</p>
	<div class="hgroup">
		<h1>이벤트 In-Flows(
		<a href="../hrta_eventstream/hrta_eventStreamDetails.jsp?ordinal=1&eventStreamWithVersion=<%=eventStreamWithVersion%>"><%=eventStreamWithVersion%></a>
		)
		</h1>
	</div>

   <div class=con-area>
		<h2>내부 이벤트 In-flows</h2>
		<div class="act">
			<jsp:include page="../hrta_eventbuilder/hrta_event_builder_inFlows.jsp" flush="true">
                 <jsp:param name="eventStreamWithVersion"
                            value="<%=eventStreamWithVersion%>"/>
             </jsp:include>
		</div>		
		<h2>외부 이벤트 In-flows</h2>
		<div class="act">
			<jsp:include page="../hrta_eventprocessor/hrta_inner_index.jsp" flush="true">
                <jsp:param name="eventStreamWithVersion"
                           value="<%=eventStreamWithVersion%>"/>
                <jsp:param name="loadingCondition" value="<%=loadingCondition%>"/>
            </jsp:include>
		</div>
	</div>
</div>
