<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>

<head>
<title> new document </title>
<meta charset="UTF-8">
<meta name="generator" content="editplus" />
<meta name="author" content="" />
<meta name="keywords" content="" />
<meta name="description" content="" />

<link rel="stylesheet" href="../layout/css/jquery.treeview.css" />
<link rel="stylesheet" href="../layout/css/screen.css" />
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
<link href="../dialog/css/jqueryui/jqueryui-themeroller.css" rel="stylesheet" type="text/css"
          media="all"/>
<link href="../dialog/css/dialog.css" rel="stylesheet" type="text/css" media="all"/>
<!--[if gte IE 8]>
<link href="../dialog/css/dialog-ie8.css" rel="stylesheet" type="text/css" media="all"/>        
<![endif]-->
<!--[if gte IE 7]>
<link href="../dialog/css/dialog-ie8.css" rel="stylesheet" type="text/css" media="all"/>
<![endif]-->

<script src="../layout/js/jquery-1.11.1.min.js"></script>
<script src="../layout/js/jquery.cookie.js" type="text/javascript"></script>

<script type="text/javascript" src="../dialog/js/jqueryui/jquery-ui.min.js"></script>


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

    <script type="text/javascript" src="../cep-admin/js/customControls.js"></script>

</head>

<body>
<div id="dcontainer"></div>
<script type="text/javascript" src="../dialog/js/dialog.js"></script>

<div id="wrap">
	<div id="header">
		<tiles:insertAttribute name="header"></tiles:insertAttribute>
	</div>
	<div id="container">
		<div id="body">
			<div class="tNav">
				<tiles:insertAttribute name="menu"></tiles:insertAttribute>
			</div>
			<div id="content">
				<tiles:insertAttribute name="contents"></tiles:insertAttribute>
			</div>
		</div>
	</div>
	<div id="footer">
		<tiles:insertAttribute name="footer"></tiles:insertAttribute>
	</div>
</div>
</body>
</html>
