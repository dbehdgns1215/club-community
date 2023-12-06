<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.io.PrintWriter" %>
    <%@ page import="board.BoardDAO" %>
    <%@ page import="board.Board" %>
    <%@ page import="java.util.ArrayList" %>
                
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>우송 동아리방</title>
    <style type="text/css">
        a, a:hover {
            color: #000000;
            text-decoration: none;
        }

        .btn {
            border: #29367c;
            background-color: #29367c;
        }

        /* Add your custom styles here */
        .club-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            margin-top: 20px;
        }

        .club-item {
            text-align: center;
            margin-bottom: 20px;
            width: 30%; /* Adjust the width as needed */
        }

        .club-logo {
            width: 60%; /* Occupy the full width of the container */
            height: auto; /* Maintain aspect ratio */
        }
        p {
        	margin-top: 5px;
       	    font-size: 20px;
       	    font-weight: bold;
        }
        h2 {
       	    font-size: 40px;
       	    font-weight: bold;
       	    text-align: center;
        }
</style>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="main.jsp">우송 동아리방</a>
		</div>
		
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li><a href="board.jsp">홍보 게시판</a></li>
				<li class="active"><a href="club.jsp">동아리 커뮤니티</a></li>
				<li><a href="community.jsp">동아리 연합 활동</a></li>
			</ul>
			<%
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
					<li><a href="login.jsp">로그인</a>
					<li><a href="register.jsp">회원가입</a>
					</ul>
				</li>
			</ul>
			<%
				} else {
			%>
				<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
					<li><a href="logoutAction.jsp">로그아웃</a>
					</ul>
				</li>
			</ul>
			<%	
				}
			%>
		</div>
	</nav>
	
	<div class="container">
        <div class="jumbotron">
		    <h2 class="text-center">동아리 커뮤니티</h2>
		</div>

        <!-- Replace the following with your actual club logos and links -->

        <div class="club-container" style="margin-top: 60px;">
            <div class="club-item">
                <a href="clubBoard.jsp?clubID=1">
                    <img src="https://i.ibb.co/2dM2Y29/club-1.png" alt="Club 1" class="club-logo">
                </a>
                <p>Club 1</p>
            </div>
            <div class="club-item">
                <a href="clubBoard.jsp?clubID=5">
                    <img src="https://i.ibb.co/1GYth6L/club-5.png" alt="Club 5" class="club-logo">
                </a>
                <p>Club 5</p>
            </div>
            <div class="club-item">
                <a href="clubBoard.jsp?clubID=2">
                    <img src="https://i.ibb.co/Ws315ZV/club-2.png" alt="Club 2" class="club-logo">
                </a>
                <p>Club 2</p>
            </div>
            <div class="club-item">
                <a href="clubBoard.jsp?clubID=4">
                    <img src="https://i.ibb.co/qrvWsdD/club-4.png" alt="Club 4" class="club-logo">
                </a>
                <p>Club 4</p>
            </div>
            <div class="club-item">
                <a href="clubBoard.jsp?clubID=3">
                    <img src="https://i.ibb.co/cT3QDk9/club-3.png" alt="Club 3" class="club-logo">
                </a>
                <p>Club 3</p>
            </div>
            <div class="club-item">
	            <a href="clubBoard.jsp?clubID=6">
	                <img src="https://i.ibb.co/j4JnDBH/club-6.png" alt="Club 6" class="club-logo">
	            </a>
                <p>Club 6</p>
           	</div>
        </div>

        <!-- Add other content or styling as needed -->
    </div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>



