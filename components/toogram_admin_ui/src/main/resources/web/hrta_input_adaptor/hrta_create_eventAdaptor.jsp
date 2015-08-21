<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

    <script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
    <script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
    <script type="text/javascript" src="../cep-admin/js/main.js"></script>
    <script type="text/javascript" src="../hrta_input_adaptor/js/create_event_adaptor_helper.js"></script>
    <script type="text/javascript" src="../ajax/js/prototype.js"></script>

    <div id="cols">
        <p id="breadCurmb">
		Home &gt; 인풋어답터 &gt; Input 이벤트 아답터						
		</p>
		<div class="hgroup">
			<h1>신규 이벤트 아답터 생성</h1>
		</div>
        <div class="act">        	
            <form name="inputForm" action="../hrta_input_adaptor/hrta_input_adaptor.jsp?ordinal=1" method="post" id="addEvent">
            	<div class="act">            	
	                <table id="eventAdd" class="styledVertical">
	                	<thead>
							<tr>
								<th>이벤트 아답터 상세 내역 입력</th>
							</tr>
						</thead>
						<tbody>
						<tr>
						<td>
		                <%@include file="../hrta_input_adaptor/hrta_inner_event_adaptor_ui.jsp" %>
		                </td>
		                </tr>
		                </tbody>
                </table>
				</div>
            <div class="btn-set">			
				<button class="btn" onclick="addEvent(document.getElementById('addEvent'))"/>추가</button>
			</div>
            </form>
        </div>
    </div>