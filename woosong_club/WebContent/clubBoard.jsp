<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.io.PrintWriter" %>
    <%@ page import="club_board.ClubBoardDAO" %>
    <%@ page import="club_board.ClubBoard" %>
    <%@ page import="java.util.ArrayList" %>
    <%@ page import="java.util.HashMap" %>
              
              
    <%
 	// clubID 설정
    String clubIDParameter = request.getParameter("clubID");
    ClubBoard club_board = new ClubBoard();
    if (clubIDParameter != null && !clubIDParameter.isEmpty()) {
        int clubID = Integer.parseInt(clubIDParameter);
        club_board.setClubID(clubID);
    } else {
        System.out.println("clubID is null or empty.");
    }
    
 	// 동아리 소개를 저장하는 맵
    HashMap<Integer, String> clubIntroductionMap = new HashMap<>();

    // 각 동아리에 대한 소개를 맵에 저장
    clubIntroductionMap.put(1, "동아리 1<br><span class=\"small\">동아리 1에 대한 소개입니다.</span>");
    clubIntroductionMap.put(2, "동아리 2<br><span class=\"small\">동아리 2에 대한 소개입니다.</span>");
    clubIntroductionMap.put(3, "동아리 3<br><span class=\"small\">동아리 3에 대한 소개입니다.</span>");
    clubIntroductionMap.put(4, "동아리 4<br><span class=\"small\">동아리 4에 대한 소개입니다.</span>");
    clubIntroductionMap.put(5, "동아리 5<br><span class=\"small\">동아리 5에 대한 소개입니다.</span>");
    clubIntroductionMap.put(6, "동아리 6<br><span class=\"small\">동아리 6에 대한 소개입니다.</span>");


    // 선택된 동아리의 소개를 가져옴
    String clubIntroduction = clubIntroductionMap.get(club_board.getClubID());
	%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>우송 동아리방</title>
<style type="text/css">
	.jumbotron.text-center {
        max-width: 1200px;
        min-width: 768px;
        margin: 0 auto;
        padding-right: 60px;
        padding-left: 60px;
        padding-top: 48px;
        padding-bottom: 48px;
        border-radius: 6px;
        margin-bottom: 25px;
    }
    .small {
    font-size: 50%; /* 원하는 크기로 조절하세요. */
	}
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
	
	.btn {
		border: #29367c;
		background-color: #29367c;
		}
    .jumbotron.text-center p {
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
	<div class="jumbotron text-center">
	    <p><%= clubIntroduction %></p>
	</div>
	<div class="container">
    <!-- 공지사항 목록 출력 -->
    <%
        ClubBoardDAO club_boardDAO = new ClubBoardDAO();
        String currentClubID = request.getParameter("clubID");
        ArrayList<ClubBoard> noticeList = club_boardDAO.getNoticeListByClubID(Integer.parseInt(currentClubID));
    %>
    <div class="row">
        <table class="table table-striped" style="text-align: center; border: 1px solid#dddddd">
            <thead>
                <tr>
                    <th colspan="2" style="background-color: #eeeeee; text-align: center;">공지사항</th>
                </tr>
            </thead>
            <tbody>
                <% for (ClubBoard notice : noticeList) { %>
                    <tr>
                        <td>
                            <a href="club_view.jsp?clubID=<%= club_board.getClubID() %>&club_boardID=<%= notice.getClub_boardID() %>"><%= notice.getClub_boardTitle() %></a>
                        </td>
                        <td><%= notice.getClub_boardDate() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

    
	<div class="container">
    <div class="row">
        <table class="table table-striped" style="text-align: center; border: 1px solid#dddddd">
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
                <% 
                    ArrayList<ClubBoard> list = club_boardDAO.getListByClubID(club_board.getClubID(), pageNumber);
                    for (int i = 0; i < list.size(); i++) { 
                %>        
                    <tr>
                        <td><%= list.get(i).getClub_boardID() %></td>
                        <td><%= club_boardDAO.getTopicName(list.get(i).getTopicID()) %></td>
                        <td><a href="club_view.jsp?clubID=<%= club_board.getClubID() %>&club_boardID=<%= list.get(i).getClub_boardID() %>">
    					<%= list.get(i).getClub_boardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %>
					    	</a>
					    </td>
                        
                        <td><%= list.get(i).getUserID() %></td>
                        <td><%= list.get(i).getClub_boardDate().substring(11, 13) + ":" + list.get(i).getClub_boardDate().substring(14, 16) + " " + " [" + list.get(i).getClub_boardDate().substring(0, 10) + "] "%></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        <%
				if(pageNumber != 1) {
			%>
				<a href="board.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arraw-left">이전</a>
			<%
				} if(club_boardDAO.nextPageByClubID(club_board.getClubID(), pageNumber + 1)) {
			%>	
				<a href="board.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			
			%>
        <a href="club_write.jsp?clubID=<%= club_board.getClubID() %>" class="btn btn-primary pull-right">글쓰기</a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
</body>
</html>



