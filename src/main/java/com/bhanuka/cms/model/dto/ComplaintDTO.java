package com.bhanuka.cms.model.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ComplaintDTO {
    private int id;
    private int userId;
    private String title;
    private String description;
    private String status;
    private String remarks;
    private Timestamp createdAt;
    private Timestamp updatedAt;
}