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
				<li class="active"><a href="main.jsp">메인</a></li>
				<li><a href="board.jsp">홍보 게시판</a></li>
				<li><a href="club.jsp">동아리 커뮤니티</a></li>
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
			<div class="container">
				<h1>우송 동아리방</h1>
				<p>우송대학교 동아리 홍보 및 동아리원들과의 교류 및 동아리간의 소통 등을 위해 만든 웹 사이트입니다.</p>
				<p><a class="btn btn-primary btn-pull" href="#" role="button" onclick="showMessage()">자세히 알아보기</a></p>
				
				
				<div class="container">
					<div id="myCarousel" class="carousel slide" data-ride="carousel">
						<ol class="carousel-indicators">
							<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
							<li data-target="#myCarousel" data-slide-to="1"></li>
							<li data-target="#myCarousel" data-slide-to="2"></li>
						</ol>
						<div class="carousel-inner">
							<div class="item active">
								<img src="images/2.PNG">
							</div>
							<div class="item">
								<img src="images/1.PNG">
							</div>
							<div class="item">
								<img src="images/3.PNG">
							</div>
						</div>
						<a class="left carousel-control" href="#myCarousel" data-slide="prev">
							<span class="glyphicon glyphicon-chevron-left"></span>
						</a>
						<a class="right carousel-control" href="#myCarousel" data-slide="next">
							<span class="glyphicon glyphicon-chevron-right"></span>
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="container">
	<h2 style ="text-align: center;">공지사항</h2>
		<div class="row">
			<table class="table table-striped" style ="text-align: center; border: 1px solid#dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<tbody>
					<%
						BoardDAO boardDAO = new BoardDAO();
						ArrayList<Board> noticeList = boardDAO.getNoticeList();
	                    // 가져온 공지사항을 표시
	                    for (int i = 0; i < noticeList.size(); i++) {
	                %>
	                    <tr>
	                        <td><a href="view.jsp?boardID=<%= noticeList.get(i).getBoardID() %>"><%= noticeList.get(i).getBoardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
	                        <td><%= noticeList.get(i).getBoardDate().substring(11, 13) + ":" + noticeList.get(i).getBoardDate().substring(14, 16) + " [" + noticeList.get(i).getBoardDate().substring(0, 10) + "] "%></td>
	                    </tr>
	                <%
	                    }
	                %>
				</tbody>
				</table>
				<%
					if(pageNumber != 1) {
				%>
					<a href="board.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arraw-left">이전</a>
				<%
					} if(boardDAO.nextPage(pageNumber + 1)) {
				%>	
					<a href="board.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arraw-left">다음</a>
				<%
					}
				
				%>
				</tbody>
		</div>
	</div>
	<script>
	    function showMessage() {
	        alert('준비 중입니다.');
	    }
	</script>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>



