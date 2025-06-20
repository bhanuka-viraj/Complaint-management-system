package com.bhanuka.cms.model.dao;

import com.bhanuka.cms.model.dto.UserDTO;
import com.bhanuka.cms.util.DBConnection;
import com.bhanuka.cms.util.DBConnection;
import org.apache.commons.dbcp2.BasicDataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    private final BasicDataSource dataSource = DBConnection.getDataSource();

    public UserDAO() {
        if (dataSource == null) {
            throw new IllegalStateException("DataSource is not initialized!");
        }
    }

    public UserDTO login(String username, String password) {
        System.out.println("Attempting login for: " + username);
        String sql = "SELECT id, username, password, role FROM users WHERE username = ? AND password = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("Login successful for: " + username);
                    return new UserDTO(rs.getInt("id"), rs.getString("username"), rs.getString("password"), rs.getString("role"));
                } else {
                    System.out.println("No user found for: " + username);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean register(String username, String password, String role) {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password); // In production, hash this password
            stmt.setString(3, role);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}