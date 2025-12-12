-- Thêm cột is_blocked vào bảng users
USE bus_booking;

ALTER TABLE users 
ADD COLUMN is_blocked TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Trạng thái block: 0 = active, 1 = blocked';

CREATE INDEX idx_is_blocked ON users(is_blocked);

