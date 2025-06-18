package com.bhanuka.cms.model.dao;

import com.bhanuka.cms.model.dto.ComplaintDTO;
import javax.sql.DataSource;
import javax.naming.InitialContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {
    private DataSource dataSource;

    public ComplaintDAO() {
        try {
            InitialContext ctx = new InitialContext();
            dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/CMS");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void saveComplaint(ComplaintDTO complaint) {
        String sql = "INSERT INTO complaints (user_id, title, description, status, remarks) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaint.getUserId());
            stmt.setString(2, complaint.getTitle());
            stmt.setString(3, complaint.getDescription());
            stmt.setString(4, complaint.getStatus());
            stmt.setString(5, complaint.getRemarks());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<ComplaintDTO> getComplaintsByUserId(int userId) {
        List<ComplaintDTO> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE user_id = ? AND status != 'Resolved'";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                complaints.add(new ComplaintDTO(
                        rs.getInt("id"), rs.getInt("user_id"), rs.getString("title"), rs.getString("description"),
                        rs.getString("status"), rs.getString("remarks"), rs.getString("created_at"), rs.getString("updated_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public List<ComplaintDTO> getAllComplaints() {
        List<ComplaintDTO> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                complaints.add(new ComplaintDTO(
                        rs.getInt("id"), rs.getInt("user_id"), rs.getString("title"), rs.getString("description"),
                        rs.getString("status"), rs.getString("remarks"), rs.getString("created_at"), rs.getString("updated_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public void updateComplaint(ComplaintDTO complaint) {
        String sql = "UPDATE complaints SET status = ?, remarks = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, complaint.getStatus());
            stmt.setString(2, complaint.getRemarks());
            stmt.setInt(3, complaint.getId());
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteComplaint(int id) {
        String sql = "DELETE FROM complaints WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}