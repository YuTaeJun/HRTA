<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ page import="org.wso2.carbon.analytics.hive.ui.cron.CronBuilderConstants" %>
<%@ page import="org.wso2.carbon.analytics.hive.ui.cron.CronExpressionBuilder" %>

<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServlet" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.HashMap" %>

<%
	String cronExpression = "";
	
	String msg = null;
	
	
	if (request.getParameter("optionCron").equalsIgnoreCase("selectUI")) {
		
	    HashMap<String, String> cronVals = new HashMap<String, String>();
	    
	    cronVals.put(CronBuilderConstants.YEAR, request.getParameter("yearSelected"));
	    cronVals.put(CronBuilderConstants.MONTH, request.getParameter("monthSelected"));
	    
	    if (request.getParameter("selectDay").equalsIgnoreCase("selectDayMonth")) {
	        cronVals.put(CronBuilderConstants.DAY_OF_MONTH, request.getParameter("dayMonthSelected"));
	    } else {
	        cronVals.put(CronBuilderConstants.DAY_OF_WEEK, request.getParameter("dayWeekSelected"));
	    }
	    
	    cronVals.put(CronBuilderConstants.HOURS, request.getParameter("hoursSelected"));
	    cronVals.put(CronBuilderConstants.MINUTES, request.getParameter("minutesSelected"));
	
	    CronExpressionBuilder cronBuilder = CronExpressionBuilder.getInstance();
	    
	    cronExpression = cronBuilder.getCronExpression(cronVals);
	    
	    msg = "스크립트 스케줄을 업데이트 하였습니다.# cron expression: #" + cronExpression;
	    
	} else if (request.getParameter("optionCron").equalsIgnoreCase("customCron")) {
	    cronExpression = request.getParameter("customCron");
	    msg = "스크립트 스케줄을 업데이트 하였습니다.# cron expression: #" + cronExpression;
	} else {
		msg = "Interval wise 스케줄링은 현재 지원되지 않습니다.";
	}
	
	PrintWriter writer = null;
	try {
	    writer = response.getWriter();
	    writer.print(msg);
	} catch (IOException e) {    
	    writer.print("스크립트 스케줄링 중 에러 발생");
	}

%>

