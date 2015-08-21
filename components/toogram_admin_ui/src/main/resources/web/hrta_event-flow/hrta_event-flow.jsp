<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.event.flow.ui.client.EventFlowAdminServiceClient" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>

<script src="global-params.js" type="text/javascript"></script>
<script type="text/javascript" src="../hrta_event-flow/js/d3.v3.js"></script>
<script type="text/javascript" src="../hrta_event-flow/js/dagre-d3.min.js"></script>
<script type="text/javascript" src="../hrta_event-flow/js/graphlib-dot.min.js"></script>

<style>

    g.type-ES > rect {
        fill: #00e8ba;
    }

    g.type-EP > rect {
        fill: #c0699e;
    }

    g.type-IEA > rect {
        fill: #4395cb;
    }

    g.type-OEA > rect {
        fill: #4cb5f4;
    }

    g.type-EB > rect {
        fill: #e3b217;
    }

    g.type-EF > rect {
        fill: #ffc719;
    }

    svg {
        border: 1px solid #999;
        overflow: hidden;
    }

    text {
        font-weight: 300;
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
        font-size: 14px;
    }

    .node rect {
        stroke: #999;
        stroke-width: 1px;
        fill: #fff;
    }

    .edgeLabel rect {
        fill: #fff;
    }

    .edgePath path {
        stroke: #333;
        stroke-width: 1.5px;
        fill: none;
    }

</style>


<%

	String serverURL = (String)session.getAttribute("serverURL");	    
	String sessionCookie = (String)session.getAttribute("authCookie");

    ConfigurationContext configContext =
            (ConfigurationContext) config.getServletContext()
                    .getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);

    EventFlowAdminServiceClient client;
    String[] logs = new String[0];
    try {
        client = new EventFlowAdminServiceClient(sessionCookie, serverURL, configContext,
                                                  request.getLocale());


            String eventFlow = client.getEventFlow();

%>
<script type="text/javascript">
    var eventFlow= jQuery.parseJSON( <%=eventFlow%> );
</script>
<%
    } catch (Exception e) {
%>
<script type="text/javascript">
   window.location.href = "../cep-admin/error.jsp";
</script>
<%
    }
%>



<script type="text/javascript">


wso2.wsf.Util.initURLs();

var frondendURL = wso2.wsf.Util.getServerURL() + "/";

window.onload=function(){tryDraw();};

function tryDraw() {
    var g = new dagreD3.Digraph();
    var nodes= eventFlow.nodes;
    for (var i=0; i<nodes.length;i++){
        g.addNode(nodes[i].id, { label: "<div style='padding: 10px;'>"+nodes[i].label+"</div>" , nodeclass: "type-"+nodes[i].nodeclass });

    }

    var edges= eventFlow.edges;
    for (i=0; i<edges.length;i++){
        g.addEdge(null, edges[i].from, edges[i].to);
    }

    var renderer = new dagreD3.Renderer();
    var oldDrawNodes = renderer.drawNodes();
    renderer.drawNodes(function (graph, root) {
        var svgNodes = oldDrawNodes(graph, root);
        svgNodes.each(function (u) {
            d3.select(this).classed(graph.node(u).nodeclass, true);
        });
        return svgNodes;
    });

    var svg = d3.select("svg");

    var layout = dagreD3.layout()
            .nodeSep(10)
            .edgeSep(10)
            .rankDir("LR");
    renderer.layout(layout);

    renderer.transition(transition);

      var layout = renderer.run(g, d3.select("svg g"));

    transition(d3.select("svg"))
            .attr("width", layout.graph().width + 40)
            .attr("height", layout.graph().height + 40);

    d3.select("svg")
            .call(d3.behavior.zoom().on("zoom", function () {
                var ev = d3.event;
                svg.select("g")
                        .attr("transform", "translate(" + ev.translate + ") scale(" + ev.scale + ")");
            }));

}

// Custom transition function
function transition(selection) {
    return selection.transition().duration(500);
}

</script>

    <div id="cols">
		<p id="breadCurmb">
			Home &gt; 관리자 Dashboard &gt; 이벤트 Flow 조회				
		</p>
	<div class="hgroup">		
		<h1>이벤트 Flow</h1>
	</div>
    <div id="workArea">
        <div id="flowdiv">
            <svg width=100% height=600>
                <g transform="translate(20, 20)"/>
            </svg>
        </div>
    </div>
</div>
