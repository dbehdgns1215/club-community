package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
			//Data Access Object
public class BoardDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	public BoardDAO() {
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
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // DB 오류
	}
	
	public int getNext() {
		String SQL = "SELECT boardID FROM BOARD ORDER BY boardID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번째 게시물일 경우 ID 값 1로 할당
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB 오류
	}
	
	public int write(String boardTitle, String userID, String boardContent, String boardContentText, int topicID) {
		String SQL = "INSERT INTO BOARD VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext()); // boardID
			pstmt.setString(2,  boardTitle); // boardTitle
			pstmt.setString(3,  userID); // userID
			pstmt.setString(4,  getDate()); // boardDate
			pstmt.setString(5,  boardContent); // boardContent
			pstmt.setInt(6,  1); // 삭제 가능한 상태. boardAvailable
			pstmt.setString(7, boardContentText);
			pstmt.setInt(8,  topicID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB 오류
	}
	
	public ArrayList<Board> getList(int pageNumber) {
		String SQL = "SELECT * FROM BOARD WHERE boardID < ? AND boardAvailable = 1 ORDER BY boardID DESC LIMIT 10";
		ArrayList<Board> list = new ArrayList<Board>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			// getNext는 다음으로 작성 될 글의 번호
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Board board = new Board();
				board.setBoardID(rs.getInt(1));
				board.setBoardTitle(rs.getString(2));
				board.setUserID(rs.getString(3));
				board.setBoardDate(rs.getString(4));
				board.setBoardContent(rs.getString(5));
				board.setBoardAvailable(rs.getInt(6));
				board.setBoardContentText(rs.getString(7));
				board.setTopicID(rs.getInt(8));
				list.add(board);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	// 공지사항
	public ArrayList<Board> getNoticeList() {
        ArrayList<Board> list = new ArrayList<>();

        try {
            String SQL = "SELECT * FROM board WHERE topicID = 1 AND boardAvailable = 1 ORDER BY boardID DESC";
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Board board = new Board();
                board.setBoardID(rs.getInt(1));
                board.setBoardTitle(rs.getString(2));
                board.setUserID(rs.getString(3));
                board.setBoardDate(rs.getString(4));
                board.setBoardContent(rs.getString(5));
                board.setBoardAvailable(rs.getInt(6));
                board.setBoardContentText(rs.getString(7));
                board.setTopicID(rs.getInt(8));
                list.add(board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } 
        return list;
    }
	
	public String getTopicName(int topicID) {
        String topicName = "";
        switch (topicID) {
            case 1:
                topicName = "공지사항";
                break;
            case 2:
                topicName = "홍보";
                break;
            case 3:
                topicName = "자유";
                break;
            case 4:
                topicName = "정보";
                break;
            case 5:
                topicName = "질문";
                break;
            default:
                topicName = "기타";
                break;
        }
        return topicName;
    }
	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BOARD WHERE boardID < ? AND boardAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public Board getBoard(int boardID) {
		String SQL = "SELECT * FROM BOARD WHERE boardID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Board board = new Board();
				board.setBoardID(rs.getInt(1));
				board.setBoardTitle(rs.getString(2));
				board.setUserID(rs.getString(3));
				board.setBoardDate(rs.getString(4));
				board.setBoardContent(rs.getString(5));
				board.setBoardAvailable(rs.getInt(6));
				board.setBoardContentText(rs.getString(7));
				board.setTopicID(rs.getInt(8));
				return board;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int update(int boardID, String boardTitle, String boardContent, String boardContentText) {
	    String SQL = "UPDATE BOARD SET boardTitle = ?, boardContent = ?, boardContentText = ? WHERE boardID = ?";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, boardTitle);            // boardTitle
	        pstmt.setString(2, boardContent);          // boardContent
	        pstmt.setString(3, boardContentText);      // boardContentText
	        pstmt.setInt(4, boardID);                  // boardID

	        int result = pstmt.executeUpdate();

	        // 추가된 부분: 게시물이 성공적으로 업데이트되면 boardContentText도 업데이트
	        if (result > 0) {
	            SQL = "UPDATE BOARD SET boardContentText = ? WHERE boardID = ?";
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, boardContent);
	            pstmt.setInt(2, boardID);
	            pstmt.executeUpdate();
	        }

	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1; // DB 오류
	}

	
	public int delete(int boardID) {
		String SQL = "UPDATE BOARD SET boardAvailable = 0 WHERE boardID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  boardID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB 오류
	}
}
