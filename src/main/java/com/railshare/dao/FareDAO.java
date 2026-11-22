package com.railshare.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.railshare.model.Fare;

public class FareDAO {

    /**
     * Get fare for specific route
     * Supports reverse route also
     */
    public Fare getFare(String trainNumber,
                        String fromStation,
                        String toStation,
                        String ticketClass) {

        String sql =
        "SELECT * FROM fares " +
        "WHERE train_number=? " +
        "AND class=? " +
        "AND ( " +
        "(from_station=? AND to_station=?) " +
        "OR " +
        "(from_station=? AND to_station=?) " +
        ")";

        try (Connection conn =
             DBConnection.getConnection();

             PreparedStatement pstmt =
             conn.prepareStatement(sql)) {

            pstmt.setString(1,
            trainNumber);

            pstmt.setString(2,
            ticketClass);

            // Original route
            pstmt.setString(3,
            fromStation);

            pstmt.setString(4,
            toStation);

            // Reverse route
            pstmt.setString(5,
            toStation);

            pstmt.setString(6,
            fromStation);

            ResultSet rs =
            pstmt.executeQuery();

            if (rs.next()) {

                Fare fare =
                new Fare();

                fare.setId(
                rs.getInt("id"));

                fare.setTrainNumber(
                rs.getString("train_number"));

                fare.setFromStation(
                rs.getString("from_station"));

                fare.setToStation(
                rs.getString("to_station"));

                fare.setTicketClass(
                rs.getString("class"));

                fare.setFareAmount(
                rs.getBigDecimal("fare_amount"));

                return fare;
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }


    /**
     * Get fare amount
     */
    public BigDecimal getFareAmount(
            String trainNumber,
            String fromStation,
            String toStation,
            String ticketClass) {

        Fare fare =
        getFare(
                trainNumber,
                fromStation,
                toStation,
                ticketClass
        );

        return fare != null
                ? fare.getFareAmount()
                : null;
    }


    /**
     * Get all fares
     */
    public List<Fare> getAllFares() {

        List<Fare> fares =
        new ArrayList<>();

        String sql =
        "SELECT * FROM fares ORDER BY id DESC";

        try (Connection conn =
             DBConnection.getConnection();

             PreparedStatement pstmt =
             conn.prepareStatement(sql);

             ResultSet rs =
             pstmt.executeQuery()) {

            while (rs.next()) {

                Fare fare =
                new Fare();

                fare.setId(
                rs.getInt("id"));

                fare.setTrainNumber(
                rs.getString("train_number"));

                fare.setFromStation(
                rs.getString("from_station"));

                fare.setToStation(
                rs.getString("to_station"));

                fare.setTicketClass(
                rs.getString("class"));

                fare.setFareAmount(
                rs.getBigDecimal("fare_amount"));

                fares.add(fare);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return fares;
    }


    /**
     * Add fare
     */
    public boolean addFare(Fare fare) {

        String sql =
        "INSERT INTO fares (train_number, from_station, to_station, class, fare_amount) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn =
             DBConnection.getConnection();

             PreparedStatement pstmt =
             conn.prepareStatement(sql)) {

            pstmt.setString(1,
            fare.getTrainNumber());

            pstmt.setString(2,
            fare.getFromStation());

            pstmt.setString(3,
            fare.getToStation());

            pstmt.setString(4,
            fare.getTicketClass());

            pstmt.setBigDecimal(5,
            fare.getFareAmount());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }


    /**
     * Delete fare
     */
    public boolean deleteFare(int id) {

        String sql =
        "DELETE FROM fares WHERE id=?";

        try (Connection conn =
             DBConnection.getConnection();

             PreparedStatement pstmt =
             conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }


    /**
     * Get fare by ID
     */
    public Fare getFareById(int id) {

        String sql =
        "SELECT * FROM fares WHERE id=?";

        try (Connection conn =
             DBConnection.getConnection();

             PreparedStatement pstmt =
             conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            ResultSet rs =
            pstmt.executeQuery();

            if (rs.next()) {

                Fare fare =
                new Fare();

                fare.setId(
                rs.getInt("id"));

                fare.setTrainNumber(
                rs.getString("train_number"));

                fare.setFromStation(
                rs.getString("from_station"));

                fare.setToStation(
                rs.getString("to_station"));

                fare.setTicketClass(
                rs.getString("class"));

                fare.setFareAmount(
                rs.getBigDecimal("fare_amount"));

                return fare;
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }


    /**
     * Update fare
     */
    public boolean updateFare(Fare fare) {

        String sql =
        "UPDATE fares SET train_number=?, from_station=?, to_station=?, class=?, fare_amount=? WHERE id=?";

        try (Connection conn =
             DBConnection.getConnection();

             PreparedStatement pstmt =
             conn.prepareStatement(sql)) {

            pstmt.setString(1,
            fare.getTrainNumber());

            pstmt.setString(2,
            fare.getFromStation());

            pstmt.setString(3,
            fare.getToStation());

            pstmt.setString(4,
            fare.getTicketClass());

            pstmt.setBigDecimal(5,
            fare.getFareAmount());

            pstmt.setInt(6,
            fare.getId());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }
}