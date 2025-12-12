-- Cập nhật database để hỗ trợ đặt nhiều ghế
USE bus_booking;

-- Tạo bảng booking_items để lưu từng ghế trong 1 booking
CREATE TABLE IF NOT EXISTS booking_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_price DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    INDEX idx_booking_id (booking_id),
    INDEX idx_seat_number (booking_id, seat_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Cập nhật bảng bookings: bỏ seat_number, thêm quantity
ALTER TABLE bookings 
    ADD COLUMN quantity INT NOT NULL DEFAULT 1 COMMENT 'Số lượng ghế đặt' AFTER customer_email,
    ADD COLUMN seat_numbers TEXT COMMENT 'Danh sách ghế (JSON hoặc comma-separated) để tương thích' AFTER quantity;

-- Migrate dữ liệu cũ: tạo booking_items từ dữ liệu bookings cũ
INSERT INTO booking_items (booking_id, seat_number, seat_price)
SELECT 
    id as booking_id,
    seat_number,
    total_price as seat_price
FROM bookings
WHERE seat_number IS NOT NULL AND seat_number != '';

-- Sau khi migrate xong, có thể xóa cột seat_number cũ (tùy chọn)
-- ALTER TABLE bookings DROP COLUMN seat_number;

