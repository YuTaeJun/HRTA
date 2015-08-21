<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


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
<script src="../layout/js/jquery-1.11.1.min.js"></script>
<script src="../layout/js/jquery.cookie.js" type="text/javascript"></script>
</head>

 <script type="text/javascript">
    function doValidation() {
        var reason = "";

        var userNameEmpty = isEmpty("username");
        var passwordEmpty = isEmpty("password");

        if (userNameEmpty || passwordEmpty) {
            CARBON.showWarningDialog('<fmt:message key="empty.credentials"/>');
            document.getElementById('txtUserName').focus();
            return false;
        }

        return true;
    }

</script>
 <script type="text/javascript">
	function getSafeText(text){
		text = text.replace(/</g,'&lt;');
		return text.replace(/>/g,'&gt');
	}

    function checkInputs(){
    	var loginForm = document.getElementById('loginForm');
    	var username = document.getElementById("txtUserName");        	
    	username.value = getSafeText(username.value);
    	loginForm.submit();
    }
</script>

<body>
<div id="login">
	<div class="login-frm">
		<h1>로그인</h1>
		<form action='../cep-admin/index.jsp' method="POST" onsubmit="return doValidation();" onsubmit="checkInputs()">		
		<fieldset>
			<legend>로그인 폼</legend>
			<p>
				<label for="useId">아이디</label>
				<input type="text" id="useId" name="username"/>
				<span class="save"><input type="checkbox" title="아이디 기억하기" /> 아이디 기억하기</span>
			</p>
			<p>
				<label for="usePw">비밀번호</label>
				<input type="password" id="usePw" name="password"/>
			</p>
			<p class="btn-login">
				<button class="submit">로그인</button>
			</p>
		</fieldset>
		</form>
	</div>
</div>
</body>
</html>
	

    
