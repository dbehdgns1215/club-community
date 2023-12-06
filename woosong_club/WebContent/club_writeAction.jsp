<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="club_board.ClubBoardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="club_board" class="club_board.ClubBoard" scope="page"/>
<jsp:setProperty name="club_board" property="club_boardTitle"/>
<jsp:setProperty name="club_board" property="club_boardContent"/>
<jsp:setProperty name="club_board" property="club_boardContentText"/>
<jsp:setProperty name="club_board" property="topicID"/>

<%
    // boardContentText 설정
    String club_boardContent = request.getParameter("club_boardContent");
	club_board.setClub_boardContentText(club_boardContent);
    
 	// topicID 설정
    int topicID = Integer.parseInt(request.getParameter("topic"));
    club_board.setTopicID(topicID);
    
	 // clubID 설정
    String clubIDParameter = request.getParameter("clubID");
    if (clubIDParameter != null && !clubIDParameter.isEmpty()) {
        int clubID = Integer.parseInt(clubIDParameter);
        club_board.setClubID(clubID);
    } else {
        System.out.println("clubID is null or empty.");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>우송 동아리방</title>
</head>
<body>
    <%	
	    String userID = null;
		if (session.getAttribute("userID") != null )
		{
			userID = (String)session.getAttribute("userID");
		}
		if (userID == null) // 로그인 안된 사용자
		{
			PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('글쓰기 기능은 회원에게만 제공되어집니다.');");
	        script.println("location.href = 'login.jsp';");
	        script.println("</script>");
		}
		else { // 로그인 된 사용자
	    	if (club_board.getClub_boardTitle() == null || club_board.getClub_boardContent() == null) {
	    	    		PrintWriter script = response.getWriter();
	    	            script.println("<script>");
	    	            script.println("alert('입력되지 않은 필드가 존재합니다.');");
	    	            script.println("history.back();");
	    	            script.println("</script>");
	    	    	} else {
	    	    		ClubBoardDAO club_boardDAO = new ClubBoardDAO();
	    	    		int result = club_boardDAO.write(club_board.getClub_boardTitle(), userID, club_board.getClub_boardContent(), club_board.getClub_boardContentText(), club_board.getTopicID(), club_board.getClubID());
	    	            if (result == -1) { // DB 오류 -> 아이디 중복
	    	                PrintWriter script = response.getWriter();
	    	                script.println("<script>");
	    	                script.println("alert('글쓰기에 실패했습니다.');");
	    	                script.println("history.back();");
	    	                script.println("</script>");
	    	            }
	    	            else {
	    	            	PrintWriter script = response.getWriter();
	                        script.println("<script>");
	                        script.println("location.href = 'clubBoard.jsp?clubID=" + club_board.getClubID() + "';");
	                        script.println("</script>");
	                    }
	    	    	}

		}
    %>
</body>
</html>
