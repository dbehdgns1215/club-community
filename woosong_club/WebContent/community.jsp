<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.io.PrintWriter" %>
    <%@ page import="community.CommunityDAO" %>
    <%@ page import="community.Community" %>
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
				<li><a href="main.jsp">메인</a></li>
				<li><a href="board.jsp">홍보 게시판</a></li>
				<li><a href="club.jsp">동아리 커뮤니티</a></li>
				<li class="active"><a href="community.jsp">동아리 연합 활동</a></li>
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
        <!-- 공지사항 목록 출력 -->
        <%
        	CommunityDAO communityDAO = new CommunityDAO();
            ArrayList<Community> noticeList = communityDAO.getNoticeList();
        %>
        <div class="row">
            <table class="table table-striped" style="text-align: center; border: 1px solid#dddddd">
                <thead>
                    <tr>
                        <th colspan="2" style="background-color: #eeeeee; text-align: center;">공지사항</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Community notice : noticeList) { %>
                        <tr>
                            <td>
                                <a href="community_view.jsp?CommunityID=<%= notice.getCommunityID() %>"><%= notice.getCommunityTitle() %></a>
                            </td>
                            <td><%= notice.getCommunityDate() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
	<div class="container">
		<div class="row">
			<table class="table table-striped" style ="text-align: center; border: 1px solid#dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">주제</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
                    <% ArrayList<Community> list = communityDAO.getList(pageNumber);
                       for (int i =0; i<list.size(); i++) {
                    %>        
                        <tr>
                            <td><%= list.get(i).getCommunityID() %></td>
                            <td><%= communityDAO.getTopicName(list.get(i).getTopicID()) %></td>
                            <td><a href="community_view.jsp?CommunityID=<%= list.get(i).getCommunityID() %>"> <%= list.get(i).getCommunityTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
                            <td><%= list.get(i).getUserID() %></td>
                            <td><%= list.get(i).getCommunityDate().substring(11, 13) + ":" + list.get(i).getCommunityDate().substring(14, 16) + " " + " [" + list.get(i).getCommunityDate().substring(0, 10) + "] "%></td>
                        </tr>
                    <% } %>
                </tbody>
			</table>
			<%
				if(pageNumber != 1) {
			%>
				<a href="community.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arraw-left">이전</a>
			<%
				} if(communityDAO.nextPage(pageNumber + 1)) {
			%>	
				<a href="community.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			
			%>
			<a href="community_write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>



