<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

    <script type="text/javascript" src="../cep-admin/js/breadcrumbs.js"></script>
    <script type="text/javascript" src="../cep-admin/js/cookies.js"></script>
    <script type="text/javascript" src="../cep-admin/js/main.js"></script>
    <script type="text/javascript" src="../hrta_eventprocessor/js/execution_plans.js"></script>
    
    <script type="text/javascript" src="../yui/build/yahoo-dom-event/yahoo-dom-event.js"></script>
    <script type="text/javascript" src="../yui/build/connection/connection-min.js"></script>
    <script type="text/javascript" src="../ajax/js/prototype.js"></script>

    <script type="text/javascript" src="../hrta_eventprocessor/js/create_execution_plan_helper.js"></script>

    <link type="text/css" href="../resources/css/registry.css" rel="stylesheet"/>
    
    <div id="custom_dcontainer" style="display:none"></div>

    <div id="cols" >
        <h2>이벤트 실행 계획 생성</h2>
        <div id="workArea" class="act">
            <form name="inputForm" action="../hrta_eventprocessor/hrta_eventprocessor.jsp?ordinal=1" 
            method="post" id="addExecutionPlanForm">

                <table id="eventProcessorAdd" class="styledVertical">
                    <thead>
                    <tr>
                        <th>이벤트 프로세서 상세 내역 입력</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr id="uiElement">
                    <%@include file="../hrta_eventprocessor/hrta_inner_execution_plan_ui.jsp" %>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" value="실행 계획 추가"
                                   onclick="addExecutionPlan(document.getElementById('addExecutionPlanForm'))"/>
                        </td>
                    </tr>
                    </tbody>

                </table>

            </form>
        </div>
    </div>
