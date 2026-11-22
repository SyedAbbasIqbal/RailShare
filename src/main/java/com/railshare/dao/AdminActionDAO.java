package com.railshare.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AdminActionDAO {
    
    /**
     * Log admin action for audit trail
     */
    public boolean logAction(int adminId, String actionType, Integer targetUserId, Integer targetTicketId, String description) {
        String sql = "INSERT INTO admin_actions (admin_id, action_type, target_user_id, target_ticket_id, description) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, adminId);
            pstmt.setString(2, actionType);
            if (targetUserId != null && targetUserId > 0) {
                pstmt.setInt(3, targetUserId);
            } else {
                pstmt.setNull(3, java.sql.Types.INTEGER);
            }
            if (targetTicketId != null && targetTicketId > 0) {
                pstmt.setInt(4, targetTicketId);
            } else {
                pstmt.setNull(4, java.sql.Types.INTEGER);
            }
            pstmt.setString(5, description);
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error logging admin action: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
