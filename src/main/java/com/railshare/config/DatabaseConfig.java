
package com.railshare.config;

public class DatabaseConfig {

    public static final String DB_URL =
            System.getenv("RAILSHARE_DB_URL");

    public static final String DB_USERNAME =
            System.getenv("RAILSHARE_DB_USERNAME");

    public static final String DB_PASSWORD =
            System.getenv("RAILSHARE_DB_PASSWORD");

    public static final String DB_DRIVER =
            "com.mysql.cj.jdbc.Driver";
}
