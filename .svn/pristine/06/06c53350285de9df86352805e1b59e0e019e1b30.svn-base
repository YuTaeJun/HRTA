<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.event.statistics.stub.client.EventStatisticsAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.statistics.ui.EventStatisticsAdminClient" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="java.rmi.RemoteException" %>

<script type="text/javascript" src="../cep-admin/js/jquery.js"></script>
<script type="text/javascript" src="../cep-admin/js/jquery.flot.js"></script>
<script type="text/javascript" src="../cep-admin/js/excanvas.js"></script>


<script src="../yui/build/yahoo-dom-event/yahoo-dom-event.js" type="text/javascript"></script>
<script src="../yui/build/animation/animation-min.js" type="text/javascript"></script>
<script src="../cep-admin/js/template.js" type="text/javascript"></script>
<script src="../yui/build/yahoo/yahoo-min.js" type="text/javascript"></script>
<script src="../yui/build/selector/selector-min.js" type="text/javascript"></script>
<script type="text/javascript" src="../cep-admin/js/jquery-1.5.2.min.js"></script>
<script type="text/javascript" src="../cep-admin/js/jquery.form.js"></script>
<script type="text/javascript" src="../dialog/js/jqueryui/jquery-ui.min.js"></script>
<script type="text/javascript" src="../cep-admin/js/jquery.validate.js"></script>    
<script type="text/javascript" src="../cep-admin/js/jquery.cookie.js"></script>
<script type="text/javascript" src="../cep-admin/js/jquery.ui.core.min.js"></script>
<script type="text/javascript" src="../cep-admin/js/jquery.ui.widget.min.js"></script>
<script type="text/javascript" src="../cep-admin/js/jquery.ui.tabs.min.js"></script>
<script type="text/javascript" src="../cep-admin/js/main.js"></script>
<script type="text/javascript" src="../cep-admin/js/WSRequest.js"></script>
<script type="text/javascript" src="../cep-admin/js/cookies.js"></script>

<script type="text/javascript" src="../hrta_event-statistics/js/graphs.js"></script>
<script type="text/javascript" src="../hrta_event-statistics/js/statistics.js"></script>


    <%
        String category = request.getParameter("category");
        String deployment = request.getParameter("deployment");
        String element = request.getParameter("element");
        
      	//url 받아오고, 쿠키 받아오고
        //String backendServerURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
        
		String serverURL = (String)session.getAttribute("serverURL");	    
	    String sessionCookie = (String)session.getAttribute("authCookie");

        ConfigurationContext configContext =
                (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);

        EventStatisticsAdminClient client = new EventStatisticsAdminClient(sessionCookie,serverURL,configContext,request.getLocale());

        EventStatisticsAdminServiceStub.StatsDTO count = null;
        try {
            if(category==null){
                count = client.getGlobalCount();
            } else {
                if(deployment==null){
                    count = client.getCategoryCount(category);
                } else {
                    if(element==null){
                        count = client.getDeploymentCount(category,deployment);
                    } else {
                        count = client.getElementCount(category,deployment,element);
                    }
                }
            }
        } catch (RemoteException e) {
    %>
            <jsp:forward page="../cep-admin/error.jsp?<%=e.getMessage()%>"/>
    <%
            return;
        }
    %>

    <%
        if (count != null) {
    %>  
    
    	<style type="text/css">
			#legendContainer {
			    background-color: #fff;
			    padding: 2px;
			    margin-bottom: 8px;
			    border-radius: 3px 3px 3px 3px;
			    border: 1px solid #E6E6E6;
			    display: inline-block;
			    margin: 0 auto;
			    float: right;			    
			}
		</style>	
 
 		   <div id="legendContainer"></div>
 		   <table>
 		   <tr><td>
           <div id="statsGraph" style="height:300px;"></div>               
           <script type="text/javascript">
           
               jQuery.noConflict();
               
               graphRequest.add(<%= count.getRequestTotalCount()%>);
               graphResponse.add(<%= count.getResponseTotalCount()%>);               
               
               function drawEventStatsGraph() {                    	   
            	   $.plot("#statsGraph", [
                       {
                           label:"REQ",
                           data:graphRequest.get(),
                           lines:{ show:true, fill:true }
                       },
                       {
                           label:"RES",
                           data:graphResponse.get(),
                           lines:{ show:true, fill:true }
                       }
                   ], {
                       xaxis:{
                           ticks:graphRequest.tick(),
                           min:0
                       },
                       yaxis:{
                           ticks:10,
                           min:0
                       },
                       legend:{         
                    	   container:$("#legendContainer"),            
                           noColumns: 0
                       }
                  });
               }
               
               drawEventStatsGraph();
               
           </script>
           </td></tr>
           </table>
          </br>
       <table>
       <tr>
            <td>
            	<div class="detail-view">
                <table class="detail" id="requestStatsTable">
                    <thead>
                    <tr>
                        <th colspan="2" align="left">유입 통계</th>
                    </tr>
                    </thead>
                    <tr>
                        <th width="40%">총 유입수</th>
                        <td><%=count.getRequestTotalCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">업데이트 시간</th>
                        <td><%=count.getRequestLastUpdatedTime() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">초당 회대 유입수</th>
                        <td><%=count.getRequestMaxCountPerSec() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">초당 평균 유입수</th>
                        <td><%=count.getRequestAvgCountPerSec() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 1초간 유입수</th>
                        <td><%=count.getRequestLastSecCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 분간 유입수</th>
                        <td>&#126;&nbsp;<%=count.getRequestLastMinCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 15분간 유입수</th>
                        <td>&#126;&nbsp;<%=count.getRequestLast15MinCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 1시간 유입수</th>
                        <td>&#126;&nbsp;<%=count.getRequestLastHourCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 6시간 유입수</th>
                        <td>&#126;&nbsp;<%=count.getRequestLast6HourCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 일간 유입수</th>
                        <td>&#126;&nbsp;<%=count.getRequestLastDayCount() %>
                        </td>
                    </tr>
                </table>
                </div>
           </td>
           <td>&nbsp;<br/></td>
           <td>
           		<div class="detail-view">
                <table class="detail" id="responseStatsTable">
                    <thead>
                    <tr>
                        <th colspan="2" align="left">응답 통계</th>
                    </tr>
                    </thead>
                    <tr>
                        <th width="40%">총 응답수</th>
                        <td><%=count.getResponseTotalCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">업데이트 시간</th>
                        <td><%=count.getResponseLastUpdatedTime() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">초당 회대 응답수</th>
                        <td><%=count.getResponseMaxCountPerSec() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">초당 평균 응답수</th>
                        <td><%=count.getResponseAvgCountPerSec() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 1초간 응답수</th>
                        <td><%=count.getResponseLastSecCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 분간 응답수</th>
                        <td>&#126;&nbsp;<%=count.getResponseLastMinCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 15분간 응답수</th>
                        <td>&#126;&nbsp;<%=count.getResponseLast15MinCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 1시간 응답수</th>
                        <td>&#126;&nbsp;<%=count.getResponseLastHourCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 6시간 응답수</th>
                        <td>&#126;&nbsp;<%=count.getResponseLast6HourCount() %>
                        </td>
                    </tr>
                    <tr>
                        <th width="40%">최종 1일간 응답수</th>
                        <td>&#126;&nbsp;<%=count.getResponseLastDayCount() %>
                        </td>
                    </tr>
                </table>
                </div>
           </td>
       </tr>
    </table>
    <%
        } else {
    %>
            <p>통계 데이터가 없습니다.</p>
    <%
        }
    %>