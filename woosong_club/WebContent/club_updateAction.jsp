<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="club_board.ClubBoardDAO" %>
<%@ page import="club_board.ClubBoard" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/custom.css">
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
        // club_board 객체를 먼저 생성
        ClubBoard club_board = new ClubBoard();

        // clubID 설정
        String clubIDParameter = request.getParameter("clubID");
        if (clubIDParameter != null && !clubIDParameter.isEmpty()) {
            int clubID = Integer.parseInt(clubIDParameter);
            club_board.setClubID(clubID);
        } else {
            System.out.println("clubID is null or empty.");
        }

        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }
        int boardID = 0;
        if (request.getParameter("club_boardID") != null) {
            boardID = Integer.parseInt(request.getParameter("club_boardID"));
        }
        if (boardID == 0) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 게시글입니다.');");
            script.println("location.href = 'board.jsp';");
            script.println("</script>");
        } else {
            // Get the existing club_board object from the database
            ClubBoardDAO clubBoardDAO = new ClubBoardDAO();
            club_board = clubBoardDAO.getBoard(boardID);

            // Check if the logged-in user is the owner of the board
            if (!userID.equals(club_board.getUserID())) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('해당 게시자만 수정이 가능합니다.');");
                script.println("location.href = 'clubBoard.jsp?clubID=" + club_board.getClubID() + "';");
                script.println("</script>");
            } else { // 로그인 된 사용자
                String boardTitle = request.getParameter("club_boardTitle");
                String boardContent = request.getParameter("club_boardContent");
                String boardContentText = request.getParameter("club_boardContentText");

                // 간단한 값 체크 (null 또는 빈 값인 경우)
                if (boardTitle == null || boardContent == null || boardTitle.equals("") || boardContent.equals("")) {
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('입력되지 않은 필드가 존재합니다.');");
                    script.println("history.back();");
                    script.println("</script>");
                } else {
                    ClubBoardDAO boardDAO = new ClubBoardDAO();
                    int result = boardDAO.update(boardID, boardTitle, boardContent, boardContentText);

                    if (result == -1) { // DB 오류
                        PrintWriter script = response.getWriter();
                        script.println("<script>");
                        script.println("alert('글 수정에 실패했습니다.');");
                        script.println("history.back();");
                        script.println("</script>");
                    } else {
                        PrintWriter script = response.getWriter();
                        script.println("<script>");
                        script.println("location.href = 'clubBoard.jsp?clubID=" + club_board.getClubID() + "';");
                        script.println("</script>");
                    }
                }
            }
        }
    %>
</body>
</html>
