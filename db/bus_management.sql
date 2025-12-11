CREATE DATABASE IF NOT EXISTS bus_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bus_booking;

-- Xóa các bảng cũ (theo thứ tự ngược lại để tránh lỗi foreign key)
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS buses;
DROP TABLE IF EXISTS routes;

-- Tạo bảng routes trước
CREATE TABLE routes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    origin VARCHAR(150) NOT NULL,
    destination VARCHAR(150) NOT NULL,
    distance_km DECIMAL(10,2) NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng buses trước trips (vì trips có foreign key đến buses)
CREATE TABLE buses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    total_seats INT NOT NULL DEFAULT 0,
    seat_type VARCHAR(50) NOT NULL DEFAULT 'thường',
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_license_plate (license_plate),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng trips sau cùng (có foreign key đến routes và buses)
CREATE TABLE trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id INT NOT NULL,
    bus_id INT NOT NULL,
    departure_time DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE,
    FOREIGN KEY (bus_id) REFERENCES buses(id) ON DELETE RESTRICT,
    INDEX idx_route_id (route_id),
    INDEX idx_bus_id (bus_id),
    INDEX idx_departure_time (departure_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO routes (name, origin, destination, distance_km, price) VALUES
('Tuyến Sài Gòn - Đà Lạt', 'Sài Gòn', 'Đà Lạt', 310, 320000),
('Tuyến Hà Nội - Hải Phòng', 'Hà Nội', 'Hải Phòng', 120, 150000),
('Tuyến Đà Nẵng - Huế', 'Đà Nẵng', 'Huế', 95, 120000);

INSERT INTO trips (route_id, bus_id, departure_time) VALUES
(1, 1, '2025-01-01 08:00:00'),
(1, 2, '2025-01-01 13:30:00'),
(2, 3, '2025-01-02 07:00:00'),
(3, 4, '2025-01-03 09:15:00');

INSERT INTO buses (license_plate, brand, model, year, total_seats, seat_type, status) VALUES
('51A-12345', 'Thaco', 'King Long', 2020, 45, 'thường', 'active'),
('29B-67890', 'Mercedes', 'Sprinter', 2021, 35, 'giường nằm', 'active'),
('30C-11111', 'Isuzu', 'Samco', 2019, 40, 'VIP', 'active'),
('43D-22222', 'Hino', 'FC', 2022, 38, 'thường', 'active');

