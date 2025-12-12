-- Script migration để chuẩn hóa format số ghế trong bảng bookings
-- Chuyển từ format "1", "2", "3" sang "01", "02", "03"
-- Giữ nguyên các format không phải số (như "A1T", "A1D" nếu có)

USE bus_booking;

-- Kiểm tra dữ liệu hiện tại
SELECT seat_number, COUNT(*) as count 
FROM bookings 
GROUP BY seat_number 
ORDER BY seat_number;

-- Cập nhật các số ghế từ "1" -> "01", "2" -> "02", v.v.
-- Chỉ cập nhật các ghế là số thuần túy (không có chữ cái)
UPDATE bookings 
SET seat_number = LPAD(seat_number, 2, '0')
WHERE seat_number REGEXP '^[0-9]+$' 
  AND LENGTH(seat_number) = 1;

-- Kiểm tra kết quả sau khi migrate
SELECT seat_number, COUNT(*) as count 
FROM bookings 
GROUP BY seat_number 
ORDER BY seat_number;

-- Lưu ý: 
-- - Script này chỉ cập nhật các số ghế có 1 chữ số (1-9) thành 2 chữ số (01-09)
-- - Các số ghế đã có 2 chữ số (10, 11, 12...) sẽ không bị thay đổi
-- - Các format không phải số (như "A1T", "A1D") sẽ không bị thay đổi
-- - Nên backup database trước khi chạy script này

