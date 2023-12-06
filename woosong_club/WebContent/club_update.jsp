<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<script src="https://cdn.tiny.cloud/1/n1twv8llejkw8x78cq0dtyftceex78bki1qygwj3hqic91r4/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
<script>
    tinymce.init({
        selector: 'textarea',
        language: 'ko_KR', // 한국어 언어 설정
        plugins: 'image link', // 이미지 및 링크 플러그인 추가
        file_picker_types: 'file image media',
        block_unsupported_drop: false,
        toolbar: 'undo redo | formatselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | image link', // 툴바에 추가할 기능 설정
        height: 350, // 에디터의 높이 설정
    });
</script>
<title>우송 동아리방</title>
</head>
<body>
    <%
        // Get the boardID from the request
        int boardID = Integer.parseInt(request.getParameter("club_boardID"));
		
        // Get the existing club_board object from the database
        ClubBoardDAO clubBoardDAO = new ClubBoardDAO();
        ClubBoard club_board = clubBoardDAO.getBoard(boardID);
		
     	// clubID 설정
	    String clubIDParameter = request.getParameter("clubID");
	    if (clubIDParameter != null && !clubIDParameter.isEmpty()) {
	        int clubID = Integer.parseInt(clubIDParameter);
	        club_board.setClubID(clubID);
	    } else {
	        System.out.println("clubID is null or empty.");
	    }
        
        // Check if the user is logged in
        String userID = (String) session.getAttribute("userID");
        if (userID == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인이 되어있지 않습니다.');");
            script.println("location.href = 'login.jsp';");
            script.println("</script>");
        }

        // Check if the boardID is valid
        if (club_board == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 게시글입니다.');");
            script.println("location.href = 'clubBoard.jsp?clubID=" + club_board.getClubID() + "';");
            script.println("</script>");
        }

        // Check if the logged-in user is the owner of the board
        if (!userID.equals(club_board.getUserID())) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('해당 게시자만 수정이 가능합니다.');");
            script.println("location.href = 'clubBoard.jsp?clubID=" + club_board.getClubID() + "';");
            script.println("</script>");
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
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle"
                        data-toggle="dropdown" role="button" aria-haspopup="true"
                        aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="logoutAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>
    
    <div class="container">
        <div class="row">
            <form method="post" action="club_updateAction.jsp?clubID=<%= club_board.getClubID() %>&club_boardID=<%= boardID %>">
    <table class="table table-striped" style="text-align: center; border: 1px solid#dddddd">
        <thead>
            <tr>
                <th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <input type="text" class="form-control" placeholder="글 제목" name="club_boardTitle" maxlength="50" value="<%= club_board.getClub_boardTitle() %>">
                </td>
            </tr>
            <tr>
                <td>
				    <textarea class="form-control" class="TinyMCE" placeholder="글 내용" name="club_boardContent" maxlength="2048" style="height: 350px;"><%= club_board.getClub_boardContentText() %></textarea>
				</td>

            </tr>
        </tbody>
    </table>
    <input type="submit" id="updateButton" class="btn btn-primary pull-right" value="수정">
</form>
        </div>    
    </div>
    <input type="hidden" id="club_boardContentText" name="boardContentText">
    
    <script>
        function convertHtmlToText() {
            var editorContent = tinymce.activeEditor.getContent();
            var div = document.createElement("div");
            div.innerHTML = editorContent;
            var textContent = div.textContent || div.innerText;

            // 텍스트 내용을 숨겨진 필드에 넣어줌
            document.getElementById("boardContentText").value = textContent;
        }
        
        // 글쓰기 버튼 클릭 시 convertHtmlToText 함수 호출
        document.getElementById("updateButton").addEventListener("click", convertHtmlToText);
    </script>
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
