-- ============================================
-- File SQL cập nhật bảng trips để thêm bus_id
-- Chạy file này để cập nhật bảng trips hiện có
-- ============================================

USE bus_booking;

-- Xóa dữ liệu cũ trong trips (nếu cần)
-- DELETE FROM trips;

-- Xóa bảng trips cũ và tạo lại với bus_id
DROP TABLE IF EXISTS trips;

CREATE TABLE trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id INT NOT NULL,
    bus_id INT NOT NULL COMMENT 'ID của xe được gán cho chuyến này',
    departure_time DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE,
    FOREIGN KEY (bus_id) REFERENCES buses(id) ON DELETE RESTRICT,
    INDEX idx_route_id (route_id),
    INDEX idx_bus_id (bus_id),
    INDEX idx_departure_time (departure_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chèn lại dữ liệu với bus_id
INSERT INTO trips (route_id, bus_id, departure_time) VALUES
(1, 1, '2025-01-01 08:00:00'),
(1, 2, '2025-01-01 13:30:00'),
(2, 3, '2025-01-02 07:00:00'),
(3, 4, '2025-01-03 09:15:00');

-- Kiểm tra dữ liệu
SELECT t.id, t.route_id, r.name AS route_name, t.bus_id, b.license_plate, t.departure_time 
FROM trips t 
INNER JOIN routes r ON t.route_id = r.id 
INNER JOIN buses b ON t.bus_id = b.id;

