-- ============================================
-- File SQL độc lập cho quản lý xe và ghế
-- Chạy file này để tạo database và bảng buses
-- ============================================

-- Tạo database nếu chưa tồn tại
CREATE DATABASE IF NOT EXISTS bus_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Sử dụng database
USE bus_booking;

-- Xóa bảng buses nếu đã tồn tại (tùy chọn)
DROP TABLE IF EXISTS buses;

-- Tạo bảng buses
CREATE TABLE buses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license_plate VARCHAR(20) NOT NULL UNIQUE COMMENT 'Biển số xe',
    brand VARCHAR(100) NOT NULL COMMENT 'Hãng xe',
    model VARCHAR(100) NOT NULL COMMENT 'Mẫu xe',
    year INT NOT NULL COMMENT 'Năm sản xuất',
    total_seats INT NOT NULL DEFAULT 0 COMMENT 'Tổng số ghế',
    seat_type VARCHAR(50) NOT NULL DEFAULT 'thường' COMMENT 'Loại ghế: thường, giường nằm, VIP',
    status VARCHAR(20) NOT NULL DEFAULT 'active' COMMENT 'Trạng thái: active, maintenance, inactive',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
    INDEX idx_license_plate (license_plate),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chèn dữ liệu mẫu
INSERT INTO buses (license_plate, brand, model, year, total_seats, seat_type, status) VALUES
('51A-12345', 'Thaco', 'King Long', 2020, 45, 'thường', 'active'),
('29B-67890', 'Mercedes', 'Sprinter', 2021, 35, 'giường nằm', 'active'),
('30C-11111', 'Isuzu', 'Samco', 2019, 40, 'VIP', 'active'),
('43D-22222', 'Hino', 'FC', 2022, 38, 'thường', 'active');

-- Kiểm tra dữ liệu đã chèn
SELECT * FROM buses;

