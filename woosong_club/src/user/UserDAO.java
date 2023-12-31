package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
			//Data Access Object
public class UserDAO { 

		private Connection conn;
		private PreparedStatement pstmt; // SQL Injection을 방어하기 위한 수단
		private ResultSet rs;
		
		public UserDAO() {
			try {
				String dbURL = "jdbc:mysql://localhost:3306/WOOSONG";
				String dbID = "root";
				String dbPassword = "451278";
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		public int login(String userID, String userPassword)
		{
			String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID); // 상단 SQL 문구의 ?가 userID로 대체됨. 
				rs = pstmt.executeQuery();
				if (rs.next()) {
					if (rs.getString(1).equals(userPassword)) {
						return 1; // 로그인 성공
					}
					else return 0; // 비밀번호 불일치
				}
				return -1; // 아이디가 존재하지 않음
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -2; // DB 오류를 의미
		}
		
		public int register(User user) {
			String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, user.getUserID());
				pstmt.setString(2, user.getUserPassword());
				pstmt.setString(3, user.getUserName());
				pstmt.setString(4, user.getUserGender());
				pstmt.setString(5, user.getUserEmail());
				return pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1; // DB 오류
		}
}
