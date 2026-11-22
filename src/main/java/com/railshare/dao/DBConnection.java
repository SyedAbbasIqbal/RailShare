package com.railshare.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import com.railshare.config.DatabaseConfig;

public class DBConnection {
    private static Connection connection = null;
    
    /**
     * Get database connection
     */
    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                Class.forName(DatabaseConfig.DB_DRIVER);
                connection = DriverManager.getConnection(
                    DatabaseConfig.DB_URL,
                    DatabaseConfig.DB_USERNAME,
                    DatabaseConfig.DB_PASSWORD
                );
            }
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return connection;
    }
    
    /**
     * Close database connection
     */
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
