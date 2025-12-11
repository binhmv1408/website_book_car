-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th12 11, 2025 lúc 04:36 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `bus_booking`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `buses`
--

CREATE TABLE `buses` (
  `id` int(11) NOT NULL,
  `license_plate` varchar(20) NOT NULL COMMENT 'Biển số xe',
  `brand` varchar(100) NOT NULL COMMENT 'Hãng xe',
  `model` varchar(100) NOT NULL COMMENT 'Mẫu xe',
  `year` int(11) NOT NULL COMMENT 'Năm sản xuất',
  `total_seats` int(11) NOT NULL DEFAULT 0 COMMENT 'Tổng số ghế',
  `seat_type` varchar(50) NOT NULL DEFAULT 'thường' COMMENT 'Loại ghế: thường, giường nằm, VIP',
  `status` varchar(20) NOT NULL DEFAULT 'active' COMMENT 'Trạng thái: active, maintenance, inactive',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Thời gian tạo'
) ;

--
-- Đang đổ dữ liệu cho bảng `buses`
--

INSERT INTO `buses` (`id`, `license_plate`, `brand`, `model`, `year`, `total_seats`, `seat_type`, `status`, `created_at`) VALUES
(1, '51A-12345', 'Thaco', 'King Long', 2020, 45, 'thường', 'active', '2025-12-10 16:17:46'),
(2, '29B-67890', 'Mercedes', 'Sprinter', 2021, 35, 'giường nằm', 'active', '2025-12-10 16:17:46'),
(3, '30C-11111', 'Isuzu', 'Samco', 2019, 40, 'VIP', 'active', '2025-12-10 16:17:46'),
(4, '43D-22222', 'Hino', 'FC', 2022, 38, 'thường', 'active', '2025-12-10 16:17:46'),
(5, '212114', '4124124', '412421', 2025, 42, 'giường nằm', 'active', '2025-12-10 16:20:21');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `routes`
--

CREATE TABLE `routes` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL COMMENT 'Tên tuyến xe',
  `origin` varchar(150) NOT NULL COMMENT 'Điểm đi',
  `destination` varchar(150) NOT NULL COMMENT 'Điểm đến',
  `distance_km` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Quãng đường (km)',
  `price` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Giá vé',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Thời gian tạo'
) ;

--
-- Đang đổ dữ liệu cho bảng `routes`
--

INSERT INTO `routes` (`id`, `name`, `origin`, `destination`, `distance_km`, `price`, `created_at`) VALUES
(39, 'Tuyến Quận Tân Phú - Quận Thanh Khê', 'Quận Tân Phú', 'Quận Thanh Khê', 21321.00, 321312.00, '2025-12-11 13:41:01'),
(40, 'Tuyến Hà Nội - Đà Nẵng', 'Huyện Mê Linh', 'Quận Thanh Khê', 24214.00, 14.00, '2025-12-11 13:43:19'),
(41, 'Tuyến Quận Ba Đình - Thành phố Thủ Dầu Một', 'Quận Ba Đình', 'Thành phố Thủ Dầu Một', 3123.00, 131.00, '2025-12-11 13:43:36'),
(42, 'Tuyến Cần Thơ - Hà Nội', 'Quận Cái Răng', 'Huyện Thanh Trì', 21312.00, 321321.00, '2025-12-11 13:47:32'),
(43, 'Tuyến Thành phố Hồ Chí Minh - Nghệ An', 'Quận 1', 'Thành phố Vinh', 300.00, 400000.00, '2025-12-11 15:27:20');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `trips`
--

CREATE TABLE `trips` (
  `id` int(11) NOT NULL,
  `route_id` int(11) NOT NULL COMMENT 'ID tuyến xe',
  `bus_id` int(11) NOT NULL COMMENT 'ID xe được gán cho chuyến',
  `departure_time` datetime NOT NULL COMMENT 'Giờ khởi hành',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Thời gian tạo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `trips`
--

INSERT INTO `trips` (`id`, `route_id`, `bus_id`, `departure_time`, `created_at`) VALUES
(5, 42, 5, '2025-12-11 13:49:00', '2025-12-11 13:49:53'),
(6, 40, 4, '2025-12-11 14:01:00', '2025-12-11 14:01:41');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `buses`
--
ALTER TABLE `buses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_buses_license_plate` (`license_plate`),
  ADD KEY `idx_license_plate` (`license_plate`),
  ADD KEY `idx_status` (`status`);

--
-- Chỉ mục cho bảng `routes`
--
ALTER TABLE `routes`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `trips`
--
ALTER TABLE `trips`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_route_id` (`route_id`),
  ADD KEY `idx_bus_id` (`bus_id`),
  ADD KEY `idx_departure_time` (`departure_time`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `buses`
--
ALTER TABLE `buses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `routes`
--
ALTER TABLE `routes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `trips`
--
ALTER TABLE `trips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `trips`
--
ALTER TABLE `trips`
  ADD CONSTRAINT `fk_trips_bus` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_trips_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
