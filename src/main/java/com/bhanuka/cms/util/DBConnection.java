package com.bhanuka.cms.util;

import org.apache.commons.dbcp2.BasicDataSource;
import java.sql.SQLException;

public class DBConnection {
    private static final BasicDataSource dataSource;

    static {
        dataSource = new BasicDataSource();
        dataSource.setUrl("jdbc:mysql://localhost:3306/cms_db");
        dataSource.setUsername("root"); // Update with your MySQL username
        dataSource.setPassword("Viraj@2002"); // Update with your MySQL password
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        dataSource.setMaxTotal(100); // Maximum number of active connections
        dataSource.setMaxIdle(30);  // Maximum number of idle connections
        dataSource.setMinIdle(5);   // Minimum number of idle connections
        dataSource.setMaxWaitMillis(10000); // Max wait time for a connection
        dataSource.setTestOnBorrow(true);   // Test connection before borrowing
        dataSource.setValidationQuery("SELECT 1"); // Validation query

        // Validate initial configuration
        try {
            dataSource.getConnection().close(); // Test the connection
            System.out.println("Database connection pool initialized successfully.");
        } catch (SQLException e) {
            System.err.println("Failed to initialize database connection pool: " + e.getMessage());
        }
    }

    private DBConnection() {
        // Private constructor to prevent instantiation
    }

    public static BasicDataSource getDataSource() {
        return dataSource;
    }
}