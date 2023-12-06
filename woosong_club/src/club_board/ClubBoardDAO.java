package club_board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
			//Data Access Object
public class ClubBoardDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	public ClubBoardDAO() {
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
		String SQL = "SELECT club_boardID FROM club_board ORDER BY club_boardID DESC";
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
	
	public int write(String boardTitle, String userID, String boardContent, String boardContentText, int topicID, int clubID) {
		String SQL = "INSERT INTO CLUB_BOARD VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext()); // club_boardID
			pstmt.setString(2,  boardTitle); // club_boardTitle
			pstmt.setString(3,  userID); // userID
			pstmt.setString(4,  getDate()); // club_boardDate
			pstmt.setString(5,  boardContent); // club_boardContent
			pstmt.setInt(6,  1); // 삭제 가능한 상태. club_boardAvailable
			pstmt.setString(7, boardContentText);
			pstmt.setInt(8,  topicID);
			pstmt.setInt(9,  clubID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB 오류
	}
	
	public ArrayList<ClubBoard> getListByClubID(int clubID, int pageNumber) {
	    String SQL = "SELECT * FROM CLUB_BOARD WHERE clubID = ? AND club_boardID < ? AND club_boardAvailable = 1 ORDER BY club_boardID DESC LIMIT 10";
	    ArrayList<ClubBoard> list = new ArrayList<ClubBoard>();
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setInt(1, clubID);
	        pstmt.setInt(2, getNext() - (pageNumber - 1) * 10);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            ClubBoard board = new ClubBoard();
				board.setClub_boardID(rs.getInt(1));
				board.setClub_boardTitle(rs.getString(2));
				board.setUserID(rs.getString(3));
				board.setClub_boardDate(rs.getString(4));
				board.setClub_boardContent(rs.getString(5));
				board.setClub_boardAvailable(rs.getInt(6));
				board.setClub_boardContentText(rs.getString(7));
				board.setTopicID(rs.getInt(8));
				board.setClubID(rs.getInt(9));
				list.add(board);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	// 공지사항
	public ArrayList<ClubBoard> getNoticeList() {
        ArrayList<ClubBoard> list = new ArrayList<>();

        try {
            String SQL = "SELECT * FROM CLUB_BOARD WHERE topicID = 1 AND club_boardAvailable = 1 ORDER BY club_boardID DESC";
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	ClubBoard board = new ClubBoard();
				board.setClub_boardID(rs.getInt(1));
				board.setClub_boardTitle(rs.getString(2));
				board.setUserID(rs.getString(3));
				board.setClub_boardDate(rs.getString(4));
				board.setClub_boardContent(rs.getString(5));
				board.setClub_boardAvailable(rs.getInt(6));
				board.setClub_boardContentText(rs.getString(7));
                board.setTopicID(rs.getInt(8));
                board.setClubID(rs.getInt(9));
                list.add(board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } 
        return list;
    }
	
	public ArrayList<ClubBoard> getNoticeListByClubID(int clubID) {
	    ArrayList<ClubBoard> list = new ArrayList<>();

	    try {
	        String SQL = "SELECT * FROM CLUB_BOARD WHERE topicID = 1 AND club_boardAvailable = 1 AND clubID = ? ORDER BY club_boardID DESC";
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setInt(1, clubID);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            ClubBoard board = new ClubBoard();
	            board.setClub_boardID(rs.getInt(1));
	            board.setClub_boardTitle(rs.getString(2));
	            board.setUserID(rs.getString(3));
	            board.setClub_boardDate(rs.getString(4));
	            board.setClub_boardContent(rs.getString(5));
	            board.setClub_boardAvailable(rs.getInt(6));
	            board.setClub_boardContentText(rs.getString(7));
	            board.setTopicID(rs.getInt(8));
	            board.setClubID(rs.getInt(9));
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
	
	public boolean nextPageByClubID(int clubID, int pageNumber) {
	    String SQL = "SELECT * FROM CLUB_BOARD WHERE clubID = ? AND club_boardID < ? AND club_boardAvailable = 1";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setInt(1, clubID);
	        pstmt.setInt(2, getNext() - (pageNumber - 1) * 10);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            return true;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	public ClubBoard getBoard(int boardID) {
		String SQL = "SELECT * FROM CLUB_BOARD WHERE club_boardID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				ClubBoard board = new ClubBoard();
				board.setClub_boardID(rs.getInt(1));
				board.setClub_boardTitle(rs.getString(2));
				board.setUserID(rs.getString(3));
				board.setClub_boardDate(rs.getString(4));
				board.setClub_boardContent(rs.getString(5));
				board.setClub_boardAvailable(rs.getInt(6));
				board.setClub_boardContentText(rs.getString(7));
				board.setTopicID(rs.getInt(8));
				board.setClubID(rs.getInt(9));
				return board;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int update(int club_boardID, String club_boardTitle, String club_boardContent, String club_boardContentText) {
	    String SQL = "UPDATE CLUB_BOARD SET club_boardTitle = ?, club_boardContent = ?, club_boardContentText = ? WHERE club_boardID = ?";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, club_boardTitle);            // club_boardTitle
	        pstmt.setString(2, club_boardContent);          // club_boardContent
	        pstmt.setString(3, club_boardContentText);      // club_boardContentText
	        pstmt.setInt(4, club_boardID);                  // club_boardID

	        int result = pstmt.executeUpdate();

	        // 추가된 부분: 게시물이 성공적으로 업데이트되면 boardContentText도 업데이트
	        if (result > 0) {
	            SQL = "UPDATE CLUB_BOARD SET club_boardContentText = ? WHERE club_boardID = ?";
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, club_boardContent);
	            pstmt.setInt(2, club_boardID);
	            pstmt.executeUpdate();
	        }

	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1; // DB 오류
	}

	
	public int delete(int boardID) {
		String SQL = "UPDATE CLUB_BOARD SET club_boardAvailable = 0 WHERE club_boardID = ?";
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
