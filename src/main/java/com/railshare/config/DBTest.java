package com.railshare.config;

import java.sql.Connection;
import com.railshare.dao.DBConnection;

public class DBTest {
    public static void main(String[] args) {

        Connection conn = DBConnection.getConnection();

        if (conn != null) {
            System.out.println("MySQL Connected Successfully!");
        } else {
            System.out.println("MySQL Connection Failed!");
        }
    }
}
