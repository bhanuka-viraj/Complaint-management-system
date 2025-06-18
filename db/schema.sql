-- MySQL Schema for Complaint Management System
DROP DATABASE IF EXISTS cms_db;
CREATE DATABASE IF NOT EXISTS cms_db;
USE cms_db;

-- Users table
CREATE TABLE users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            role ENUM('Employee', 'Admin') NOT NULL
);

-- Complaints table
CREATE TABLE complaints (
            id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            title VARCHAR(100) NOT NULL,
            description TEXT NOT NULL,
            status ENUM('Pending', 'In Progress', 'Resolved') DEFAULT 'Pending',
            remarks TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert sample data
INSERT INTO users (username, password, role) VALUES
            ('admin', 'admin123', 'Admin'),
            ('employee', 'emp123', 'Employee');