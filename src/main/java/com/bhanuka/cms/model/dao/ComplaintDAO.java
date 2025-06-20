package com.bhanuka.cms.model.dao;

import com.bhanuka.cms.model.dto.ComplaintDTO;
import com.bhanuka.cms.util.DBConnection;
import org.apache.commons.dbcp2.BasicDataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {
    private final BasicDataSource dataSource = DBConnection.getDataSource();

    public ComplaintDAO() {
        if (dataSource == null) {
            throw new IllegalStateException("DataSource is not initialized!");
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
        String sql = "SELECT * FROM complaints WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    complaints.add(new ComplaintDTO(
                            rs.getInt("id"),
                            rs.getInt("user_id"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getString("status"),
                            rs.getString("remarks"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("updated_at")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public List<ComplaintDTO> getAllComplaints() {
        List<ComplaintDTO> complaints = new ArrayList<>();
        String sql = "SELECT * FROM complaints ORDER BY created_at DESC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                complaints.add(new ComplaintDTO(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("status"),
                        rs.getString("remarks"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public void updateComplaint(ComplaintDTO complaint) {
        String sql = "UPDATE complaints SET title = ?, description = ?, status = ?, remarks = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, complaint.getTitle());
            stmt.setString(2, complaint.getDescription());
            stmt.setString(3, complaint.getStatus());
            stmt.setString(4, complaint.getRemarks());
            stmt.setInt(5, complaint.getId());
            stmt.executeUpdate();

            System.out.println("updated");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteComplaint(int complaintId) {
        String sql = "DELETE FROM complaints WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaintId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ComplaintDTO getComplaintById(int id) {
        String sql = "SELECT * FROM complaints WHERE id = ?";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                ComplaintDTO complaint = new ComplaintDTO();
                complaint.setId(rs.getInt("id"));
                complaint.setUserId(rs.getInt("user_id"));
                complaint.setTitle(rs.getString("title"));
                complaint.setDescription(rs.getString("description"));
                complaint.setStatus(rs.getString("status"));
                complaint.setRemarks(rs.getString("remarks"));
                complaint.setUpdatedAt(rs.getTimestamp("updated_at"));
                return complaint;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}