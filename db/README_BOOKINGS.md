# Hướng dẫn tạo bảng bookings

Để sử dụng tính năng đặt vé và chọn ghế, bạn cần chạy file SQL sau để tạo bảng bookings:

```sql
-- Chạy file: db/create_bookings_table.sql
```

Hoặc chạy trực tiếp lệnh SQL:

```sql
USE bus_booking;

CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    customer_email VARCHAR(100),
    seat_number VARCHAR(10) NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT 'pending, confirmed, cancelled',
    total_price DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE,
    INDEX idx_trip_id (trip_id),
    INDEX idx_seat_number (trip_id, seat_number),
    INDEX idx_status (status),
    INDEX idx_booking_date (booking_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Các tính năng đã được tạo:

1. **Bảng bookings** - Lưu thông tin đặt vé
2. **Model Booking** - Model Java cho booking
3. **BookingDAO** - DAO để quản lý bookings
4. **BookingServlet** - Servlet xử lý chọn ghế và đặt vé
5. **seatSelection.jsp** - Trang hiển thị sơ đồ ghế và cho phép chọn
6. **bookingConfirmation.jsp** - Trang xác nhận đặt vé thành công
7. **BookingConfirmationServlet** - Servlet hiển thị trang xác nhận

## Luồng hoạt động:

1. Người dùng xem chi tiết chuyến xe → Click "Chọn ghế và đặt vé"
2. Hiển thị sơ đồ ghế với các ghế đã được đặt (màu xám)
3. Người dùng chọn ghế còn trống (màu xanh)
4. Điền thông tin khách hàng
5. Xác nhận đặt vé
6. Hiển thị trang xác nhận với mã đặt vé

