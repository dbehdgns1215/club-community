package community;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

			//Data Access Object
public class CommunityDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	public CommunityDAO() {
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
		return ""; // DB ����
	}
	
	public int getNext() {
		String SQL = "SELECT communityID FROM COMMUNITY ORDER BY communityID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // ù ��° �Խù��� ��� ID �� 1�� �Ҵ�
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB ����
	}
	
	public int write(String communityTitle, String userID, String communityContent, String communityContentText, int topicID) {
		String SQL = "INSERT INTO COMMUNITY VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext()); // boardID
			pstmt.setString(2,  communityTitle); // boardTitle
			pstmt.setString(3,  userID); // userID
			pstmt.setString(4,  getDate()); // boardDate
			pstmt.setString(5,  communityContent); // boardContent
			pstmt.setInt(6,  1); // ���� ������ ����. boardAvailable
			pstmt.setString(7, communityContentText);
			pstmt.setInt(8,  topicID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB ����
	}
	
	public ArrayList<Community> getList(int pageNumber) {
		String SQL = "SELECT * FROM COMMUNITY WHERE communityID < ? AND communityAvailable = 1 ORDER BY communityID DESC LIMIT 10";
		ArrayList<Community> list = new ArrayList<Community>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			// getNext�� �������� �ۼ� �� ���� ��ȣ
			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Community community = new Community();
				community.setCommunityID(rs.getInt(1));
				community.setCommunityTitle(rs.getString(2));
				community.setUserID(rs.getString(3));
				community.setCommunityDate(rs.getString(4));
				community.setCommunityContent(rs.getString(5));
				community.setCommunityAvailable(rs.getInt(6));
				community.setCommunityContentText(rs.getString(7));
				community.setTopicID(rs.getInt(8));
				list.add(community);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	// ��������
	public ArrayList<Community> getNoticeList() {
        ArrayList<Community> list = new ArrayList<>();

        try {
            String SQL = "SELECT * FROM COMMUNITY WHERE topicID = 1 AND communityAvailable = 1 ORDER BY communityID DESC";
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	Community community = new Community();
				community.setCommunityID(rs.getInt(1));
				community.setCommunityTitle(rs.getString(2));
				community.setUserID(rs.getString(3));
				community.setCommunityDate(rs.getString(4));
				community.setCommunityContent(rs.getString(5));
				community.setCommunityAvailable(rs.getInt(6));
				community.setCommunityContentText(rs.getString(7));
				community.setTopicID(rs.getInt(8));
				list.add(community);
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
                topicName = "��������";
                break;
            case 2:
                topicName = "ȫ��";
                break;
            case 3:
                topicName = "����";
                break;
            case 4:
                topicName = "����";
                break;
            case 5:
                topicName = "����";
                break;
            default:
                topicName = "��Ÿ";
                break;
        }
        return topicName;
    }
	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM COMMUNITY WHERE communityID < ? AND communityAvailable = 1";
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
	
	public Community getCommunity(int communityID) {
		String SQL = "SELECT * FROM COMMUNITY WHERE communityID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, communityID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Community community = new Community();
				community.setCommunityID(rs.getInt(1));
				community.setCommunityTitle(rs.getString(2));
				community.setUserID(rs.getString(3));
				community.setCommunityDate(rs.getString(4));
				community.setCommunityContent(rs.getString(5));
				community.setCommunityAvailable(rs.getInt(6));
				community.setCommunityContentText(rs.getString(7));
				community.setTopicID(rs.getInt(8));
				return community;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int update(int communityID, String communityTitle, String communityContent, String communityContentText) {
	    String SQL = "UPDATE COMMUNITY SET communityTitle = ?, communityContent = ?, communityContentText = ? WHERE communityID = ?";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, communityTitle);            // boardTitle
	        pstmt.setString(2, communityContent);          // boardContent
	        pstmt.setString(3, communityContentText);      // boardContentText
	        pstmt.setInt(4, communityID);                  // boardID

	        int result = pstmt.executeUpdate();

	        // �߰��� �κ�: �Խù��� ���������� ������Ʈ�Ǹ� boardContentText�� ������Ʈ
	        if (result > 0) {
	            SQL = "UPDATE COMMUNITY SET communityContentText = ? WHERE communityID = ?";
	            pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, communityContent);
	            pstmt.setInt(2, communityID);
	            pstmt.executeUpdate();
	        }

	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1; // DB ����
	}

	
	public int delete(int communityID) {
		String SQL = "UPDATE COMMUNITY SET communityAvailable = 0 WHERE communityID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  communityID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB ����
	}
}
