-- ============================================================
-- Database Setup Script for LoginJSP Practical
-- ============================================================
-- Run this script in MySQL to create the required database,
-- table, and sample user records.
--
-- Usage:
--   mysql -u root -p < setup_database.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS userdb;

USE userdb;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

INSERT INTO users (username, password)
VALUES
('admin', 'admin123'),
('swati', 'pass123')
ON DUPLICATE KEY UPDATE password = VALUES(password);

-- Verify the data
SELECT * FROM users;
