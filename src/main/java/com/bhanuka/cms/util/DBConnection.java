package com.bhanuka.cms.util;

import org.apache.commons.dbcp2.BasicDataSource;
import java.sql.SQLException;

public class DBConnection {
    private static final BasicDataSource dataSource;

    static {
        dataSource = new BasicDataSource();
        dataSource.setUrl("jdbc:mysql://localhost:3306/cms_db");
        dataSource.setUsername("root");
        dataSource.setPassword("Viraj@2002");
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        dataSource.setMaxTotal(100);
        dataSource.setMaxIdle(30);
        dataSource.setMinIdle(5);
        dataSource.setMaxWaitMillis(10000);
        dataSource.setTestOnBorrow(true);
        dataSource.setValidationQuery("SELECT 1");


        try {
            dataSource.getConnection().close();
            System.out.println("Database connection pool initialized successfully.");
        } catch (SQLException e) {
            System.err.println("Failed to initialize database connection pool: " + e.getMessage());
        }
    }

    private DBConnection() {
    }

    public static BasicDataSource getDataSource() {
        return dataSource;
    }
}