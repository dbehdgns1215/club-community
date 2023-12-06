<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="board" class="board.Board" scope="page"/>
<jsp:setProperty name="board" property="boardTitle"/>
<jsp:setProperty name="board" property="boardContent"/>
<jsp:setProperty name="board" property="boardContentText"/>
<jsp:setProperty name="board" property="topicID"/>

<%
    // boardContentText 설정
    String boardContent = request.getParameter("boardContent");
    board.setBoardContentText(boardContent);
    
 	// topicID 설정
    int topicID = Integer.parseInt(request.getParameter("topic"));
    board.setTopicID(topicID);
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
	    	if (board.getBoardTitle() == null || board.getBoardContent() == null) {
	    	    		PrintWriter script = response.getWriter();
	    	            script.println("<script>");
	    	            script.println("alert('입력되지 않은 필드가 존재합니다.');");
	    	            script.println("history.back();");
	    	            script.println("</script>");
	    	    	} else {
	    	    		BoardDAO boardDAO = new BoardDAO();
	    	    		int result = boardDAO.write(board.getBoardTitle(), userID, board.getBoardContent(), board.getBoardContentText(), board.getTopicID());
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
	    	                script.println("location.href = 'board.jsp'");
	    	                script.println("</script>");
	    	            }
	    	    	}

		}
    %>
</body>
</html>
