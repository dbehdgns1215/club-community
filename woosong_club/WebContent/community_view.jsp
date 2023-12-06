<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="community.CommunityDAO" %>
<%@ page import="community.Community" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css">
    <title>우송 동아리방</title>

    <style>
        html, body {
            height: 100%;
        }

        .container, .row {
            height: 100%;
        }
        .bar {
	    position: relative;
	    border-top: 2px solid #29367c;
		}
    </style>
</head>

<body>
    <%
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }
        int communityID = 0;
        if (request.getParameter("CommunityID") != null) {
        	communityID = Integer.parseInt(request.getParameter("CommunityID"));
        }
        if (communityID == 0) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 게시글입니다.');");
            script.println("location.href = 'board.jsp';");
            script.println("</script>");
        }
        Community community = new CommunityDAO().getCommunity(communityID);
    %>
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
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
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
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
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
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
        <div class="row">
            <table class="table" style="text-align: center; width: 100%; height: 70%; border: 1px solid#dddddd">
                <thead>
                    <tr>
                        <th colspan="6" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
                    </tr>
                </thead>
                <tbody>
                    <tr style="height: 40px">
                        <td style="width: 10%; background-color: #eeeeee;">글 제목</td>
                        <td colspan="1"><%= community.getCommunityTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
                        <td style="width: 10%; background-color: #eeeeee;">작성자</td>
                        <td colspan="1"><%= community.getUserID() %></td>
                        <td style="width: 10%; background-color: #eeeeee;">작성일자</td>
                        <td colspan="1"><%= " [" + community.getCommunityDate().substring(0, 10) + "] " +
                        		community.getCommunityDate().substring(11, 13) + ":" + community.getCommunityDate().substring(14, 16) %></td>
                    </tr>
                    <tr style="min-height: 500px;">
	                   <%
						    String communityContentText = community.getCommunityContent();
						    if (communityContentText != null) {
						    	communityContentText = communityContentText.replaceAll(" ", "&nbsp;")
						            .replaceAll("<", "&lt;")
						            .replaceAll(">", "&gt;")
						            .replaceAll("\n", "<br>");
						    } else {
						    	communityContentText = ""; // 또는 다른 기본값 설정
						    }
						%>
                        <td colspan="6" style="text-align: left; padding: 20px;"><%= community.getCommunityContentText() %></td>

                    </tr>
                </tbody>
            </table>
            <a href="community.jsp" class="btn btn-primary">목록</a>
            <%
                if (userID != null && userID.equals(community.getUserID())) {
            %>
            <a href="community_update.jsp?communityID=<%= communityID %>" class="btn btn-primary">수정</a>
            <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="community_deleteAction.jsp?communityID=<%= communityID %>" class="btn btn-primary">삭제</a>
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
