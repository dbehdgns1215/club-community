<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="community.CommunityDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="community" class="community.Community" scope="page"/>
<jsp:setProperty name="community" property="communityTitle"/>
<jsp:setProperty name="community" property="communityContent"/>
<jsp:setProperty name="community" property="communityContentText"/>
<jsp:setProperty name="community" property="topicID"/>

<%
    // boardContentText 설정
    String communityContent = request.getParameter("communityContent");
	community.setCommunityContentText(communityContent);
    
 	// topicID 설정
    int topicID = Integer.parseInt(request.getParameter("topic"));
    community.setTopicID(topicID);
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
	    	if (community.getCommunityTitle() == null || community.getCommunityContent() == null) {
	    	    		PrintWriter script = response.getWriter();
	    	            script.println("<script>");
	    	            script.println("alert('입력되지 않은 필드가 존재합니다.');");
	    	            script.println("history.back();");
	    	            script.println("</script>");
	    	    	} else {
	    	    		CommunityDAO communityDAO = new CommunityDAO();
	    	    		int result = communityDAO.write(community.getCommunityTitle(), userID, community.getCommunityContent(), community.getCommunityContentText(), community.getTopicID());
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
	    	                script.println("location.href = 'community.jsp'");
	    	                script.println("</script>");
	    	            }
	    	    	}

		}
    %>
</body>
</html>
