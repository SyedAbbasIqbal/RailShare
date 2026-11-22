package com.railshare.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.railshare.model.Transfer;
import com.railshare.util.DateUtil;


public class TransferDAO {
    
    /**
     * Create a new transfer record
     */
    public boolean createTransfer(Transfer transfer) {
        String sql ="INSERT INTO transfers (ticket_id, seller_id, buyer_id, price, service_fee, total_amount, payment_status, transfer_date, passenger_name, age, gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, transfer.getTicketId());
            pstmt.setInt(2, transfer.getSellerId());
            pstmt.setInt(3, transfer.getBuyerId());
            pstmt.setBigDecimal(4, transfer.getPrice());
            pstmt.setBigDecimal(5, transfer.getServiceFee());
            pstmt.setBigDecimal(6, transfer.getTotalAmount());
            pstmt.setString(7, transfer.getPaymentStatus());
            pstmt.setTimestamp(8, DateUtil.getCurrentTimestamp());
            pstmt.setString(9, transfer.getPassengerName());
            pstmt.setInt(10, transfer.getAge());
            pstmt.setString(11, transfer.getGender());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error creating transfer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get transfers by buyer ID
     */
    public List<Transfer> getTransfersByBuyer(int buyerId) {
        List<Transfer> transfers = new ArrayList<>();
        String sql = "SELECT * FROM transfers WHERE buyer_id = ? ORDER BY transfer_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, buyerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                transfers.add(mapResultSetToTransfer(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting buyer transfers: " + e.getMessage());
            e.printStackTrace();
        }
        return transfers;
    }
    
    /**
     * Get transfers by seller ID
     */
    public List<Transfer> getTransfersBySeller(int sellerId) {
        List<Transfer> transfers = new ArrayList<>();
        String sql = "SELECT * FROM transfers WHERE seller_id = ? ORDER BY transfer_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, sellerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                transfers.add(mapResultSetToTransfer(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting seller transfers: " + e.getMessage());
            e.printStackTrace();
        }
        return transfers;
    }
    
    /**
     * Get all transfers (for admin)
     */
    public List<Transfer> getAllTransfers() {
        List<Transfer> transfers = new ArrayList<>();
        String sql = "SELECT * FROM transfers ORDER BY transfer_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                transfers.add(mapResultSetToTransfer(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all transfers: " + e.getMessage());
            e.printStackTrace();
        }
        return transfers;
    }
    
    /**
     * Get transfer statistics for admin reports
     */
    public TransferStats getTransferStats() {
        TransferStats stats = new TransferStats();
        String sql = "SELECT " +
                     "COUNT(CASE WHEN payment_status = 'SUCCESS' THEN 1 END) as total_sold, " +
                     "SUM(CASE WHEN payment_status = 'SUCCESS' THEN service_fee ELSE 0 END) as total_service_fee, " +
                     "SUM(CASE WHEN payment_status = 'SUCCESS' THEN total_amount ELSE 0 END) as total_revenue " +
                     "FROM transfers";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                stats.totalSold = rs.getInt("total_sold");
                stats.totalServiceFee = rs.getBigDecimal("total_service_fee");
                stats.totalRevenue = rs.getBigDecimal("total_revenue");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting transfer stats: " + e.getMessage());
            e.printStackTrace();
        }
        return stats;
    }
    
    /**
     * Get monthly transaction report
     */
    public List<MonthlyReport> getMonthlyReport() {
        List<MonthlyReport> reports = new ArrayList<>();
        String sql = "SELECT " +
                     "DATE_FORMAT(transfer_date, '%Y-%m') as month, " +
                     "COUNT(*) as transaction_count, " +
                     "SUM(CASE WHEN payment_status = 'SUCCESS' THEN service_fee ELSE 0 END) as service_fee " +
                     "FROM transfers " +
                     "WHERE payment_status = 'SUCCESS' " +
                     "GROUP BY DATE_FORMAT(transfer_date, '%Y-%m') " +
                     "ORDER BY month DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                MonthlyReport report = new MonthlyReport();
                report.month = rs.getString("month");
                report.transactionCount = rs.getInt("transaction_count");
                report.serviceFee = rs.getBigDecimal("service_fee");
                reports.add(report);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting monthly report: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }
    
    /**
     * Map ResultSet to Transfer object
     */
    private Transfer mapResultSetToTransfer(ResultSet rs) throws SQLException {
        Transfer transfer = new Transfer();
        transfer.setId(rs.getInt("id"));
        transfer.setTicketId(rs.getInt("ticket_id"));
        transfer.setSellerId(rs.getInt("seller_id"));
        transfer.setBuyerId(rs.getInt("buyer_id"));
        transfer.setPrice(rs.getBigDecimal("price"));
        transfer.setServiceFee(rs.getBigDecimal("service_fee"));
        transfer.setTotalAmount(rs.getBigDecimal("total_amount"));
        transfer.setTransferDate(rs.getTimestamp("transfer_date"));
        transfer.setPaymentStatus(rs.getString("payment_status"));
        transfer.setPassengerName(rs.getString("passenger_name"));
        transfer.setAge(rs.getInt("age"));
        transfer.setGender(rs.getString("gender"));
        return transfer;
    }
    
    /**
     * Inner class for transfer statistics
     */
    public static class TransferStats {
        public int totalSold;
        public BigDecimal totalServiceFee;
        public BigDecimal totalRevenue;
    }
    
    /**
     * Inner class for monthly report
     */
    public static class MonthlyReport {
        public String month;
        public int transactionCount;
        public BigDecimal serviceFee;
    }
    public List<Transfer> getFilteredTransfers(
        String fromDate,
        String toDate,
        String trainNo,
        String filter){

    List<Transfer> transfers =
            new ArrayList<>();

    StringBuilder sql =
            new StringBuilder(
            "SELECT tr.* " +
            "FROM transfers tr " +
            "JOIN tickets t " +
            "ON tr.ticket_id = t.id " +
            "WHERE 1=1 ");

    List<Object> params =
            new ArrayList<>();

    try{

        if(fromDate != null &&
                !fromDate.isEmpty()){

            sql.append(
            "AND DATE(tr.transfer_date) >= ? ");

            params.add(fromDate);
        }

        if(toDate != null &&
                !toDate.isEmpty()){

            sql.append(
            "AND DATE(tr.transfer_date) <= ? ");

            params.add(toDate);
        }

        if(trainNo != null &&
                !trainNo.isEmpty()){

            sql.append(
            "AND t.train_number = ? ");

            params.add(trainNo);
        }

        if(filter != null &&
                !filter.isEmpty()){

            switch(filter){

                case "daily":
                    sql.append(
                    "AND DATE(tr.transfer_date)=CURDATE() ");
                    break;

                case "weekly":
                    sql.append(
                    "AND YEARWEEK(tr.transfer_date,1)=YEARWEEK(CURDATE(),1) ");
                    break;

                case "monthly":
                    sql.append(
                    "AND MONTH(tr.transfer_date)=MONTH(CURDATE()) " +
                    "AND YEAR(tr.transfer_date)=YEAR(CURDATE()) ");
                    break;

                case "yearly":
                    sql.append(
                    "AND YEAR(tr.transfer_date)=YEAR(CURDATE()) ");
                    break;
            }
        }

        Connection conn =
                DBConnection.getConnection();

        PreparedStatement ps =
                conn.prepareStatement(
                        sql.toString());

        for(int i=0;
            i<params.size();
            i++){

            ps.setObject(
                    i+1,
                    params.get(i));
        }

        ResultSet rs =
                ps.executeQuery();

        while(rs.next()){

            Transfer transfer =
                    mapResultSetToTransfer(
                            rs);

            transfers.add(
                    transfer);
        }

    }catch(Exception e){

        e.printStackTrace();
    }

    return transfers;
}
public static class ReportStats{

    public int ticketsSold;
    public int ticketsPurchased;
    public BigDecimal revenue;
    public BigDecimal serviceFee;
    public int transferCount;
    public int successPayments;
    public int failedPayments;
}
public ReportStats getReportStats(
        String filter,
        String fromDate,
        String toDate,
        String trainNo){

    ReportStats stats =
            new ReportStats();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try{

        StringBuilder sql =
                new StringBuilder(
                "SELECT " +
                "COUNT(*) AS total_transfers, " +
                "SUM(total_amount) AS revenue, " +
                "SUM(service_fee) AS service_fee, " +
                "COUNT(CASE WHEN payment_status='SUCCESS' THEN 1 END) AS success_payments, " +
                "COUNT(CASE WHEN payment_status='FAILED' THEN 1 END) AS failed_payments " +
                "FROM transfers tr " +
                "WHERE 1=1 "
                );

        List<Object> params =
                new ArrayList<>();


        // DAILY REPORT
        if("daily".equals(filter)){

            sql.append(
            "AND DATE(tr.transfer_date)=CURDATE() ");
        }


        // WEEKLY REPORT
        else if("weekly".equals(filter)){

            sql.append(
            "AND tr.transfer_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) ");
        }


        // MONTHLY REPORT
        else if("monthly".equals(filter)){

            sql.append(
            "AND MONTH(tr.transfer_date)=MONTH(CURDATE()) " +
            "AND YEAR(tr.transfer_date)=YEAR(CURDATE()) ");
        }


        // YEARLY REPORT
        else if("yearly".equals(filter)){

            sql.append(
            "AND YEAR(tr.transfer_date)=YEAR(CURDATE()) ");
        }


        // CUSTOM FROM DATE
        if(fromDate != null &&
        !fromDate.trim().isEmpty()){

            sql.append(
            "AND DATE(tr.transfer_date) >= ? ");

            params.add(fromDate);
        }


        // CUSTOM TO DATE
        if(toDate != null &&
        !toDate.trim().isEmpty()){

            sql.append(
            "AND DATE(tr.transfer_date) <= ? ");

            params.add(toDate);
        }


        // TRAIN FILTER
        if(trainNo != null &&
        !trainNo.trim().isEmpty()){

            sql.append(
            "AND tr.ticket_id IN (" +
            "SELECT id FROM tickets " +
            "WHERE train_number = ?) ");

            params.add(trainNo);
        }


        conn =
        DBConnection.getConnection();

        ps =
        conn.prepareStatement(
        sql.toString());


        for(int i = 0;
            i < params.size();
            i++){

            ps.setObject(
            i + 1,
            params.get(i));
        }


        rs =
        ps.executeQuery();


        if(rs.next()){

            int totalTransfers =
            rs.getInt(
            "total_transfers");

            stats.ticketsSold =
            totalTransfers;

            stats.ticketsPurchased =
            totalTransfers;

            stats.transferCount =
            totalTransfers;

            stats.revenue =
            rs.getBigDecimal(
            "revenue");

            stats.serviceFee =
            rs.getBigDecimal(
            "service_fee");

            stats.successPayments =
            rs.getInt(
            "success_payments");

            stats.failedPayments =
            rs.getInt(
            "failed_payments");
        }

    }catch(Exception e){

        System.out.println(
        "Report Error: "
        + e.getMessage());

        e.printStackTrace();
    }

    finally{

        try{
            if(rs != null)
            rs.close();
        }catch(Exception e){}

        try{
            if(ps != null)
            ps.close();
        }catch(Exception e){}

        try{
            if(conn != null)
            conn.close();
        }catch(Exception e){}
    }

    return stats;
}
}
