<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="java.rmi.RemoteException" %>
<%@ page import="org.wso2.carbon.event.statistics.stub.client.EventStatisticsAdminServiceStub" %>
<%@ page import="org.wso2.carbon.event.flow.ui.client.EventFlowAdminServiceClient" %>

<script type="text/javascript" src="../hrta_event-statistics/js/graphs.js"></script>
<script type="text/javascript" src="../hrta_event-statistics/js/statistics.js"></script>
<script type="text/javascript" src="../cep-admin/js/jquery.flot.js"></script>
<script type="text/javascript" src="../cep-admin/js/excanvas.js"></script>
<script type="text/javascript" src="global-params.js"></script>
    <%
        response.setHeader("Cache-Control", "no-cache");

        String category = request.getParameter("category");
        String deployment = request.getParameter("deployment");
        String element = request.getParameter("element");
        
        
        //url 받아오고, 쿠키 받아오고
        //String backendServerURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
        
		String serverURL = (String)session.getAttribute("serverURL");	    
	    String sessionCookie = (String)session.getAttribute("authCookie");
        
        
        ConfigurationContext configContext =
                (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);

        org.wso2.carbon.event.statistics.ui.EventStatisticsAdminClient client = new org.wso2.carbon.event.statistics.ui.EventStatisticsAdminClient(sessionCookie,serverURL,configContext,request.getLocale());

        EventStatisticsAdminServiceStub.StatsDTO count ;
        
        String typeName="Server";
        try {
            if(category==null){
                count = client.getGlobalCount();
            } else {
                if(deployment==null){
                    typeName=category;
                    count = client.getCategoryCount(category);
                } else {
                    if(element==null){
                        typeName=deployment;
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

    <script type="text/javascript">
        jQuery.noConflict();
        initStats('50');
    </script>
    
    <div id="cols">
		<p id="breadCurmb">
			Home &gt; 관리자 Dashboard &gt; 이벤트 흐름 통계						
		</p>
	<div class="hgroup">		
        <%
            String requestString="";
            if (category == null) {
        %>
        <h1>이벤트 statistics( 전체 이벤트 )</h1>
        <%
            } else {

                if (deployment == null) {
                    requestString="?category="+category;
        %>
        <h1>이벤트 statistics( 전체 이벤트 : <%=category%> ) </h1>
        <%
                } else {
                    if (element == null) {
                        requestString="?category="+category+"&deployment="+deployment;

        %>
        <h1>이벤트 statistics(<%=deployment%> <%=category%>) </h1>
        <%
                    } else {
                        requestString="?category="+category+"&deployment="+deployment+"&element="+element;
        %>
        <h1>이벤트 statistics(<%=element%> 통게: <%=deployment%> <%=category%>) </h1>
        <%
                    }
                }
            }
        %>
	</div>
       <div id="workArea" class="act">
         <%
             if (count != null) {
         %>
        <table  class="styledVertical">
            <thead>
                   <tr>
                       <th>이벤트 유입/유출 현황</th>
                   </tr>
			</thead>
		</table>
		</div>			
		<div id="result" class="act"></div>
		<script type="text/javascript">
			jQuery.noConflict();
			var refresh;
			function refreshStats() {
			    var url = "../hrta_event-statistics/hrta_graph_ajaxprocessor.jsp<%=requestString.replaceAll(" ","%20")%>";
			    jQuery("#result").load(url, null, function (responseText, status, XMLHttpRequest) {
			        if (status != "success") {
			            stopRefreshStats();
			        }
			    });
			}
			function stopRefreshStats() {
			    if (refresh) {
			        clearInterval(refresh);
			    }
			}
			jQuery(document).ready(function() {
			    refreshStats();
			    refresh = setInterval("refreshStats()", 6000);
			});
		</script>		
		<div class="act">
	           <% if (count.getChildStats() != null && count.getChildStats().length>0 && count.getChildStats()[0]!=null) { %>
	          <table class="styledVertical" id="subTypeTable">
	              <thead>
	                  <tr>
	                      <th>"통계 대상 타입"&nbsp;<%=typeName%></th>
	                  </tr>
	              </thead>
	
	              <% for (String childStat : count.getChildStats()) { %>
	              <tr>
	                  <td>
	                      <%
	                          if (category == null) {
	                      %>
	                      <a href="../hrta_event-statistics/hrta_event_statistics_view.jsp?ordinal=1&category=<%=childStat.replaceAll(" ","%20")%>"><%=childStat%>
	                      </a>
	
	                      <%
	                      } else {
	                          if (deployment == null) {
	                      %>
	                      <a href="../hrta_event-statistics/hrta_event_statistics_view.jsp?ordinal=1&category=<%=category%>&deployment=<%=childStat.replaceAll(" ","%20")%>"><%=childStat%></a>
	                      <%
	                              } else {
	                                  if (element == null) {
	                      %>
	                      <a href="../hrta_event-statistics/hrta_event_statistics_view.jsp?ordinal=1&category=<%=category%>&deployment=<%=deployment%>&element=<%=childStat.replaceAll(" ","%20")%>"><%=childStat%></a>
	                      <%
	                                  }
	                              }
	                          }
	                      %>
	                  </td>
	              </tr>
	              <%
	                  }%>
	          </table>
	          <% }%>
	          <%
	          } else {
	          %>
	          <table class="styledVertical">
	              <tbody>
	              <tr>
	                  <td>
	                      <table id="noEventFormatterInputTable">
	                          <tbody>
	                          <tr>
	                              <td colspan="2">
	                                  <p style="color:red">이벤트 통계 비활성화</p>
	                              </td>
	                          </tr>
	                          <tr>
	                              <td colspan="2">
	                               	각 이벤트 통계 대상을 enblae 하십시오	
	                              </td>
	                          </tr>
	                          </tbody>
	                      </table>
	                  </td>
	              </tr>
	              </tbody>
	          </table>
	          <%
	          }
		    %>
		</div>
	
</div>
