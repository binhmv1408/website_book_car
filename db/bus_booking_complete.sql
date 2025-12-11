-- ============================================
-- File SQL hoàn chỉnh cho hệ thống quản lý xe buýt
-- Import file này vào MySQL để tạo toàn bộ database
-- ============================================
--
-- CẤU TRÚC KHÓA CHÍNH VÀ KHÓA NGOẠI:
-- 
-- BẢNG ROUTES:
--   - PRIMARY KEY: id (pk_routes)
--   - UNIQUE: không có
--   - FOREIGN KEY: không có
--
-- BẢNG BUSES:
--   - PRIMARY KEY: id (pk_buses)
--   - UNIQUE: license_plate (uk_buses_license_plate)
--   - FOREIGN KEY: không có
--
-- BẢNG TRIPS:
--   - PRIMARY KEY: id (pk_trips)
--   - FOREIGN KEY: 
--     + route_id -> routes(id) (fk_trips_route) ON DELETE CASCADE
--     + bus_id -> buses(id) (fk_trips_bus) ON DELETE RESTRICT
--
-- ============================================

-- Tạo database nếu chưa tồn tại
CREATE DATABASE IF NOT EXISTS bus_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Sử dụng database
USE bus_booking;

-- Xóa các bảng cũ nếu đã tồn tại (theo thứ tự ngược lại để tránh lỗi foreign key)
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS buses;
DROP TABLE IF EXISTS routes;

-- ============================================
-- TẠO BẢNG ROUTES (Tuyến xe)
-- ============================================
CREATE TABLE routes (
    id INT AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL COMMENT 'Tên tuyến xe',
    origin VARCHAR(150) NOT NULL COMMENT 'Điểm đi',
    destination VARCHAR(150) NOT NULL COMMENT 'Điểm đến',
    distance_km DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT 'Quãng đường (km)',
    price DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT 'Giá vé',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
    CONSTRAINT pk_routes PRIMARY KEY (id),
    CONSTRAINT chk_routes_distance CHECK (distance_km >= 0),
    CONSTRAINT chk_routes_price CHECK (price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TẠO BẢNG BUSES (Xe và ghế)
-- ============================================
CREATE TABLE buses (
    id INT AUTO_INCREMENT,
    license_plate VARCHAR(20) NOT NULL COMMENT 'Biển số xe',
    brand VARCHAR(100) NOT NULL COMMENT 'Hãng xe',
    model VARCHAR(100) NOT NULL COMMENT 'Mẫu xe',
    year INT NOT NULL COMMENT 'Năm sản xuất',
    total_seats INT NOT NULL DEFAULT 0 COMMENT 'Tổng số ghế',
    seat_type VARCHAR(50) NOT NULL DEFAULT 'thường' COMMENT 'Loại ghế: thường, giường nằm, VIP',
    status VARCHAR(20) NOT NULL DEFAULT 'active' COMMENT 'Trạng thái: active, maintenance, inactive',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
    CONSTRAINT pk_buses PRIMARY KEY (id),
    CONSTRAINT uk_buses_license_plate UNIQUE (license_plate),
    CONSTRAINT chk_buses_year CHECK (year >= 1900 AND year <= 2100),
    CONSTRAINT chk_buses_total_seats CHECK (total_seats > 0 AND total_seats <= 100),
    CONSTRAINT chk_buses_seat_type CHECK (seat_type IN ('thường', 'giường nằm', 'VIP')),
    CONSTRAINT chk_buses_status CHECK (status IN ('active', 'maintenance', 'inactive')),
    INDEX idx_license_plate (license_plate),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TẠO BẢNG TRIPS (Chuyến xe)
-- ============================================
CREATE TABLE trips (
    id INT AUTO_INCREMENT,
    route_id INT NOT NULL COMMENT 'ID tuyến xe',
    bus_id INT NOT NULL COMMENT 'ID xe được gán cho chuyến',
    departure_time DATETIME NOT NULL COMMENT 'Giờ khởi hành',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
    CONSTRAINT pk_trips PRIMARY KEY (id),
    CONSTRAINT fk_trips_route FOREIGN KEY (route_id) 
        REFERENCES routes(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_trips_bus FOREIGN KEY (bus_id) 
        REFERENCES buses(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    INDEX idx_route_id (route_id),
    INDEX idx_bus_id (bus_id),
    INDEX idx_departure_time (departure_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- CHÈN DỮ LIỆU MẪU
-- ============================================

-- Chèn dữ liệu tuyến xe
INSERT INTO routes (name, origin, destination, distance_km, price) VALUES
('Tuyến Sài Gòn - Đà Lạt', 'Sài Gòn', 'Đà Lạt', 310, 320000),
('Tuyến Hà Nội - Hải Phòng', 'Hà Nội', 'Hải Phòng', 120, 150000),
('Tuyến Đà Nẵng - Huế', 'Đà Nẵng', 'Huế', 95, 120000);

-- Chèn dữ liệu xe
INSERT INTO buses (license_plate, brand, model, year, total_seats, seat_type, status) VALUES
('51A-12345', 'Thaco', 'King Long', 2020, 45, 'thường', 'active'),
('29B-67890', 'Mercedes', 'Sprinter', 2021, 35, 'giường nằm', 'active'),
('30C-11111', 'Isuzu', 'Samco', 2019, 40, 'VIP', 'active'),
('43D-22222', 'Hino', 'FC', 2022, 38, 'thường', 'active');

-- Chèn dữ liệu chuyến xe (phải chèn sau khi đã có routes và buses)
INSERT INTO trips (route_id, bus_id, departure_time) VALUES
(1, 1, '2025-01-01 08:00:00'),
(1, 2, '2025-01-01 13:30:00'),
(2, 3, '2025-01-02 07:00:00'),
(3, 4, '2025-01-03 09:15:00');

-- ============================================
-- XEM THÔNG TIN CÁC KHÓA CHÍNH VÀ KHÓA NGOẠI
-- (Chạy các câu lệnh này sau khi import thành công)
-- ============================================
-- Xem các khóa chính (Primary Keys)
/*
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE()
    AND CONSTRAINT_NAME = 'PRIMARY'
ORDER BY TABLE_NAME, ORDINAL_POSITION;
*/

-- Xem các khóa ngoại (Foreign Keys)
/*
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE()
    AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, CONSTRAINT_NAME;
*/

-- ============================================
-- KIỂM TRA DỮ LIỆU ĐÃ CHÈN
-- ============================================
SELECT 'Routes' AS 'Table', COUNT(*) AS 'Count' FROM routes
UNION ALL
SELECT 'Buses', COUNT(*) FROM buses
UNION ALL
SELECT 'Trips', COUNT(*) FROM trips
LIMIT 100;

-- Xem chi tiết chuyến xe với thông tin tuyến và xe
SELECT 
    t.id AS trip_id,
    r.name AS route_name,
    r.origin,
    r.destination,
    b.license_plate,
    b.brand,
    b.model,
    b.total_seats,
    b.seat_type,
    t.departure_time
FROM trips t
INNER JOIN routes r ON t.route_id = r.id
INNER JOIN buses b ON t.bus_id = b.id
ORDER BY t.departure_time DESC;

