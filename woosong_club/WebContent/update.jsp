<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.io.PrintWriter" %>
    <%@ page import="board.Board" %>
    <%@ page import="board.BoardDAO" %>
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
		String userID = null;
		if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인이 되어있지 않습니다.');");
            script.println("location.href = 'login.jsp';");
            script.println("</script>");
		}
        int boardID = 0;
        if (request.getParameter("boardID") != null) {
            boardID = Integer.parseInt(request.getParameter("boardID"));
        }
        if (boardID == 0) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 게시글입니다.');");
            script.println("location.href = 'board.jsp';");
            script.println("</script>");
        }
        Board board = new BoardDAO().getBoard(boardID);
        if (!userID.equals(board.getUserID())){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('해당 게시자만 수정이 가능합니다.');");
            script.println("location.href = 'board.jsp';");
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
				<li class="active"><a href="board.jsp">게시판</a></li>
			</ul>
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
		</div>
	</nav>
	
	<div class="container">
		<div class="row">
			<form method="post" action="updateAction.jsp?boardID=<%= boardID %>">
				<table class="table table-striped" style ="text-align: center; border: 1px solid#dddddd">
						<thead>
							<tr>
								<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>
									<input type="text" class="form-control" placeholder="글 제목" name="boardTitle" maxlength="50" value="<%= board.getBoardTitle() %>">
								</td>
							</tr>
							<tr>
								<td>
									<textarea class="form-control" class="TinyMCE" placeholder="글 내용" name="boardContent" maxlength="2048" style="height: 350px;"><%= board.getBoardContentText() %></textarea>
										<script>
										    function convertHtmlToText() {
										        var editorContent = tinymce.activeEditor.getContent(); // TinyMCE 에디터의 내용을 가져옴
										        var div = document.createElement("div");
										        div.innerHTML = editorContent;
										        var textContent = div.textContent || div.innerText; // 브라우저 호환성을 위해 두 가지 속성을 모두 체크
										
										        // 텍스트 내용을 textarea에 넣어줌
										        document.getElementById("boardContentText").value = textContent;
										    }
										
										    // 글쓰기 버튼 클릭 시 convertHtmlToText 함수 호출
										    document.getElementById("writeButton").addEventListener("click", convertHtmlToText);
										</script>
								</td>
							</tr>
						</tbody>
					</table>
					<input type="submit" class="btn btn-primary pull-right" value="수정">
			</form>
		</div>
	</div>
	<input type="hidden" id="boardContentText" name="boardContentText">
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>



