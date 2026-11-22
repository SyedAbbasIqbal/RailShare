package com.railshare.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.railshare.model.Ticket;
import com.railshare.util.DateUtil;

public class TicketDAO {

    /**
     * Create a new ticket listing
     */
    public boolean createTicket(Ticket ticket) {

        String sql =
        "INSERT INTO tickets (seller_id, train_number, from_station, to_station, travel_date, travel_time, class, seat_type, coach_no, seat_no, pnr, price, service_fee, total_amount, status, listed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (

                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)

        ) {

            pstmt.setInt(1,
                    ticket.getSellerId());

            pstmt.setString(2,
                    ticket.getTrainNumber());

            pstmt.setString(3,
                    ticket.getFromStation());

            pstmt.setString(4,
                    ticket.getToStation());

            pstmt.setDate(5,
                    ticket.getTravelDate());

            pstmt.setTime(6,
                    ticket.getTravelTime());

            pstmt.setString(7,
                    ticket.getTicketClass());

            pstmt.setString(8,
                    ticket.getSeatType());

            pstmt.setString(9,
                    ticket.getCoachNo());

            pstmt.setString(10,
                    ticket.getSeatNo());

            pstmt.setString(11,
                    ticket.getPnr());

            pstmt.setBigDecimal(12,
                    ticket.getPrice());

            pstmt.setBigDecimal(13,
                    ticket.getServiceFee());

            pstmt.setBigDecimal(14,
                    ticket.getTotalAmount());

            pstmt.setString(15,
                    ticket.getStatus());

            pstmt.setTimestamp(16,
                    DateUtil.getCurrentTimestamp());

            int result =
                    pstmt.executeUpdate();

            return result > 0;

        }

        catch (SQLException e) {

            System.err.println(
                    "Error creating ticket: "
                            + e.getMessage());

            e.printStackTrace();

            return false;
        }
    }

    /**
     * Check if PNR already exists
     */
    public boolean pnrExists(
            String pnr) {

        String sql =
                "SELECT COUNT(*) FROM tickets WHERE pnr = ?";

        try (

                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)

        ) {

            pstmt.setString(
                    1,
                    pnr);

            ResultSet rs =
                    pstmt.executeQuery();

            if (rs.next()) {

                return rs.getInt(1) > 0;
            }

        }

        catch (SQLException e) {

            System.err.println(
                    "Error checking PNR: "
                            + e.getMessage());

            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get ticket by ID
     */
    public Ticket getTicketById(
            int ticketId) {

        String sql =
                "SELECT * FROM tickets WHERE id = ?";

        try (

                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)

        ) {

            pstmt.setInt(
                    1,
                    ticketId);

            ResultSet rs =
                    pstmt.executeQuery();

            if (rs.next()) {

                return mapResultSetToTicket(
                        rs);
            }

        }

        catch (SQLException e) {

            System.err.println(
                    "Error getting ticket: "
                            + e.getMessage());

            e.printStackTrace();
        }

        return null;
    }

    /**
     * Get available tickets
     */
    public List<Ticket> getAvailableTickets(
            String searchDate,
            String searchTrain,
            String searchClass,
            String fromStation,
            String toStation,
            String timeFilter) {

        List<Ticket> tickets =
                new ArrayList<>();

        StringBuilder sql =
                new StringBuilder(

                        "SELECT * FROM tickets " +
                        "WHERE status='AVAILABLE' " +
                        "AND DATE_ADD(CONCAT(travel_date,' ',travel_time), INTERVAL -6 HOUR) > NOW() "

                );

        List<Object> params =
                new ArrayList<>();

        if (searchDate != null &&
                !searchDate.trim().isEmpty()) {

            sql.append(
                    "AND travel_date=? ");

            params.add(
                    java.sql.Date.valueOf(
                            searchDate));
        }

        if (searchTrain != null &&
                !searchTrain.trim().isEmpty()) {

            sql.append(
                    "AND train_number=? ");

            params.add(
                    searchTrain);
        }

        if (searchClass != null &&
                !searchClass.trim().isEmpty()) {

            sql.append(
                    "AND class=? ");

            params.add(
                    searchClass);
        }

        if (fromStation != null &&
                !fromStation.trim().isEmpty()) {

            sql.append(
                    "AND from_station LIKE ? ");

            params.add(
                    "%" +
                    fromStation +
                    "%");
        }

        if (toStation != null &&
                !toStation.trim().isEmpty()) {

            sql.append(
                    "AND to_station LIKE ? ");

            params.add(
                    "%" +
                    toStation +
                    "%");
        }

        sql.append(
                "ORDER BY travel_date, travel_time ASC");

        try (

                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(
                                sql.toString())

        ) {

            for (int i = 0;
                 i < params.size();
                 i++) {

                pstmt.setObject(
                        i + 1,
                        params.get(i));
            }

            ResultSet rs =
                    pstmt.executeQuery();

            while (rs.next()) {

                tickets.add(
                        mapResultSetToTicket(
                                rs));
            }

        }

        catch (SQLException e) {

            e.printStackTrace();
        }

        return tickets;
    }

    /**
     * Get seller tickets
     */
    public List<Ticket> getTicketsBySeller(
            int sellerId) {

        List<Ticket> tickets =
                new ArrayList<>();

        String sql =
                "SELECT * FROM tickets WHERE seller_id=? ORDER BY listed_at DESC";

        try (

                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)

        ) {

            pstmt.setInt(
                    1,
                    sellerId);

            ResultSet rs =
                    pstmt.executeQuery();

            while (rs.next()) {

                tickets.add(
                        mapResultSetToTicket(
                                rs));
            }

        }

        catch (SQLException e) {

            e.printStackTrace();
        }

        return tickets;
    }

    /**
     * Mark transferred
     */
    public boolean markAsTransferred(
            int ticketId) {

        String sql =
        "UPDATE tickets SET status='TRANSFERRED', transferred_at=? WHERE id=?";

        try (

                Connection conn =
                        DBConnection.getConnection();

                PreparedStatement pstmt =
                        conn.prepareStatement(sql)

        ) {

            pstmt.setTimestamp(
                    1,
                    DateUtil.getCurrentTimestamp());

            pstmt.setInt(
                    2,
                    ticketId);

            return pstmt.executeUpdate() > 0;

        }

        catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }

    /**
     * Map ResultSet
     */
    private Ticket mapResultSetToTicket(
            ResultSet rs)
            throws SQLException {

        Ticket ticket =
                new Ticket();

        ticket.setId(
                rs.getInt("id"));

        ticket.setSellerId(
                rs.getInt("seller_id"));

        ticket.setTrainNumber(
                rs.getString("train_number"));

        ticket.setFromStation(
                rs.getString("from_station"));

        ticket.setToStation(
                rs.getString("to_station"));

        ticket.setTravelDate(
                rs.getDate("travel_date"));

        ticket.setTravelTime(
                rs.getTime("travel_time"));

        ticket.setTicketClass(
                rs.getString("class"));

        ticket.setSeatType(
                rs.getString("seat_type"));

        ticket.setCoachNo(
                rs.getString("coach_no"));

        ticket.setSeatNo(
                rs.getString("seat_no"));

        ticket.setPnr(
                rs.getString("pnr"));

        ticket.setPrice(
                rs.getBigDecimal("price"));

        ticket.setServiceFee(
                rs.getBigDecimal("service_fee"));

        ticket.setTotalAmount(
                rs.getBigDecimal("total_amount"));

        ticket.setStatus(
                rs.getString("status"));

        ticket.setListedAt(
                rs.getTimestamp("listed_at"));

        ticket.setTransferredAt(
                rs.getTimestamp("transferred_at"));

        ticket.setExpiredAt(
                rs.getTimestamp("expired_at"));

        return ticket;
    }
    // Get all tickets (Admin)
public List<Ticket> getAllTickets() {

    List<Ticket> tickets =
            new ArrayList<>();

    String sql =
            "SELECT * FROM tickets " +
            "ORDER BY listed_at DESC";

    try (

            Connection conn =
                    DBConnection.getConnection();

            PreparedStatement pstmt =
                    conn.prepareStatement(sql);

            ResultSet rs =
                    pstmt.executeQuery()

    ) {

        while (rs.next()) {

            tickets.add(
                    mapResultSetToTicket(
                            rs));
        }

    }

    catch (SQLException e) {

        System.err.println(
                "Error getting all tickets: "
                        + e.getMessage());

        e.printStackTrace();
    }

    return tickets;
}


// Delete ticket (Admin)
public boolean deleteTicket(
        int ticketId) {

    String sql =
            "DELETE FROM tickets " +
            "WHERE id=?";

    try (

            Connection conn =
                    DBConnection.getConnection();

            PreparedStatement pstmt =
                    conn.prepareStatement(sql)

    ) {

        pstmt.setInt(
                1,
                ticketId);

        int rows =
                pstmt.executeUpdate();

        return rows > 0;

    }

    catch (SQLException e) {

        System.err.println(
                "Error deleting ticket: "
                        + e.getMessage());

        e.printStackTrace();
    }

    return false;
}


// Expire tickets
public List<Ticket> expireTickets() {

    List<Ticket> expiredTickets =
            new ArrayList<>();

    String selectSql =
            "SELECT * FROM tickets " +
            "WHERE status='AVAILABLE' " +
            "AND DATE_ADD(CONCAT(travel_date,' ',travel_time), INTERVAL -6 HOUR) <= NOW()";

    String updateSql =
            "UPDATE tickets " +
            "SET status='EXPIRED' " +
            "WHERE id=?";

    try (

            Connection conn =
                    DBConnection.getConnection();

            PreparedStatement selectStmt =
                    conn.prepareStatement(
                            selectSql);

            ResultSet rs =
                    selectStmt.executeQuery()

    ) {

        while (rs.next()) {

            Ticket ticket =
                    mapResultSetToTicket(
                            rs);

            expiredTickets.add(
                    ticket);

            try (

                    PreparedStatement updateStmt =
                            conn.prepareStatement(
                                    updateSql)

            ) {

                updateStmt.setInt(
                        1,
                        ticket.getId());

                updateStmt.executeUpdate();
            }
        }

    }

    catch (SQLException e) {

        System.err.println(
                "Error expiring tickets: "
                        + e.getMessage());

        e.printStackTrace();
    }

    return expiredTickets;
}
}