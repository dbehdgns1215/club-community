<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="club_board.ClubBoardDAO" %>
<%@ page import="club_board.ClubBoard" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>우송 동아리방</title>
<style>
		.btn {
		border: #29367c;
		background-color: #29367c;
		}
</style>
</head>
<body>
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
        int boardID = 0;
        if (request.getParameter("club_boardID") != null) {
            boardID = Integer.parseInt(request.getParameter("club_boardID"));
        }
        if (boardID == 0) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 게시글입니다.');");
            script.println("location.href = 'clubBoard.jsp?clubID=" + club_board.getClubID() + "';");
            script.println("</script>");
        }
        ClubBoard board = new ClubBoardDAO().getBoard(boardID);
        if (!userID.equals(board.getUserID())){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('해당 게시자만 수정이 가능합니다.');");
            script.println("location.href = 'clubBoard.jsp?clubID=" + club_board.getClubID() + "';");
            script.println("</script>");
        } else { // 로그인 된 사용자
        	ClubBoardDAO club_boardDAO = new ClubBoardDAO();
            int result = club_boardDAO.delete(boardID);
            if (result == -1) { // DB 오류 -> 아이디 중복
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('글 삭제에 실패했습니다.');");
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
    %>
</body>
</html>
