-- Tạo bảng users để lưu thông tin người dùng
USE bus_booking;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT 'Tên đăng nhập',
    password VARCHAR(255) NOT NULL COMMENT 'Mật khẩu (đã hash)',
    full_name VARCHAR(100) NOT NULL COMMENT 'Họ và tên',
    email VARCHAR(100) COMMENT 'Email',
    phone VARCHAR(20) COMMENT 'Số điện thoại',
    role VARCHAR(20) NOT NULL DEFAULT 'user' COMMENT 'Role: admin hoặc user',
    is_blocked TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Trạng thái block: 0 = active, 1 = blocked',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Thời gian cập nhật',
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_is_blocked (is_blocked)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo tài khoản admin mặc định (username: admin, password: admin)
-- Mật khẩu đã được hash bằng SHA-256: admin -> 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
INSERT INTO users (username, password, full_name, role) VALUES
('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Quản trị viên', 'admin')
ON DUPLICATE KEY UPDATE username=username;
