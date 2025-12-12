-- Thêm cột user_id vào bảng bookings để liên kết với users
USE bus_booking;

-- Thêm cột user_id (cho phép NULL để tương thích với dữ liệu cũ)
ALTER TABLE bookings 
ADD COLUMN user_id INT NULL COMMENT 'ID của user đã đặt vé' AFTER trip_id;

-- Thêm foreign key constraint
ALTER TABLE bookings
ADD CONSTRAINT fk_bookings_user_id 
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

-- Thêm index cho user_id
CREATE INDEX idx_user_id ON bookings(user_id);

