<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Booking" %>
<%@ page import="model.BookingItem" %>
<%@ page import="model.Trip" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
    Trip trip = (Trip) request.getAttribute("trip");
    String ctx = request.getContextPath();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    String role = (String) session.getAttribute("userRole");
    String username = (String) session.getAttribute("username");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect(ctx + "/login");
        return;
    }
    String userDisplay = (username != null && !username.isEmpty()) ? username : "Admin";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa vé đã đặt</title>
    <style>
        :root {
            --sidebar-bg: #0b1f3a;
            --primary: #0c62f0;
            --primary-dark: #0a4ab3;
            --danger: #e74c3c;
            --success: #10b981;
            --warning: #f59e0b;
            --surface: #ffffff;
            --muted: #718096;
            --border: #e2e8f0;
            --bg: #f5f6fa;
        }
        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Inter", Arial, sans-serif; background: var(--bg); color: #1a202c; font-size: 15px; }
        a { text-decoration: none; color: inherit; }
        .layout { display: grid; grid-template-columns: 260px 1fr; min-height: 100vh; }
        .sidebar {
            background: var(--sidebar-bg);
            color: #e5e7eb;
            padding: 24px 18px;
            display: flex; flex-direction: column; gap: 24px;
        }
        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 700;
            font-size: 18px;
        }
        .brand-logo {
            width: 40px;
            height: 40px;
            background: var(--primary);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
        }
        .menu {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .menu a {
            padding: 12px 16px;
            border-radius: 8px;
            transition: all 0.2s;
            color: #cbd5e1;
        }
        .menu a:hover {
            background: rgba(255,255,255,0.1);
            color: #fff;
        }
        .menu a.active {
            background: var(--primary);
            color: #fff;
        }
        main {
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .header {
            background: var(--surface);
            padding: 20px 32px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .user {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .avatar {
            width: 40px;
            height: 40px;
            background: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 700;
        }
        .content {
            padding: 32px;
            overflow-y: auto;
        }
        .page-title {
            font-size: 28px;
            font-weight: 800;
            margin: 0 0 24px;
            color: #1a202c;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .back-btn {
            padding: 8px 16px;
            background: #e2e8f0;
            border-radius: 8px;
            color: #4b5563;
            font-weight: 600;
            transition: all 0.2s;
        }
        .back-btn:hover {
            background: #cbd5e0;
        }
        .edit-card {
            background: var(--surface);
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid var(--border);
            max-width: 800px;
        }
        .form-group {
            margin-bottom: 24px;
        }
        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        .form-input, .form-select {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.2s;
        }
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(12, 98, 240, 0.1);
        }
        .status-badge {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            margin-top: 8px;
        }
        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }
        .status-confirmed {
            background: #d1fae5;
            color: #065f46;
        }
        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }
        .seats-display {
            background: #f8fafc;
            padding: 16px;
            border-radius: 8px;
            margin-top: 8px;
        }
        .seats-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .seat-badge {
            background: #e0e7ff;
            color: #3730a3;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 700;
        }
        .actions {
            display: flex;
            gap: 12px;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid var(--border);
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: var(--primary);
            color: #fff;
        }
        .btn-primary:hover {
            background: var(--primary-dark);
        }
        .btn-secondary {
            background: #e2e8f0;
            color: #4b5563;
        }
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        .info-text {
            color: var(--muted);
            font-size: 13px;
            margin-top: 4px;
        }
    </style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-logo">HX</div>
            <span>Hidro Bus</span>
        </div>
        <nav class="menu">
            <a href="<%= ctx %>/admin">Trang quản trị</a>
            <a href="<%= ctx %>/admin/tuyen-xe">Tuyến xe</a>
            <a href="<%= ctx %>/admin/chuyen-xe">Chuyến xe</a>
            <a href="<%= ctx %>/admin/xe-va-ghe">Xe và ghế</a>
            <a class="active" href="<%= ctx %>/admin/bookings">Vé đã đặt</a>
            <a href="<%= ctx %>/admin/customers">Khách hàng</a>
            <a href="#">Nhà xe</a>
            <a href="#">Phản hồi</a>
            <a href="#">Quản trị viên</a>
        </nav>
    </aside>
    <main>
        <header class="header">
            <div></div>
            <div class="user">
                <div class="avatar"><%= userDisplay.substring(0,1).toUpperCase() %></div>
                <span><%= userDisplay %></span>
                <a class="btn btn-primary" href="<%= ctx %>/logout" style="margin-left:8px;">Đăng xuất</a>
            </div>
        </header>

        <section class="content">
            <div class="page-title">
                <a href="<%= ctx %>/admin/bookings" class="back-btn">← Quay lại</a>
                <span>Sửa vé #<%= booking != null ? booking.getId() : "" %></span>
            </div>

            <% if (booking != null) { %>
            <div class="edit-card">
                <form method="POST" action="<%= ctx %>/admin/booking-update-status">
                    <input type="hidden" name="id" value="<%= booking.getId() %>">
                    
                    <div class="form-group">
                        <label class="form-label">Mã vé</label>
                        <input type="text" class="form-input" value="#<%= booking.getId() %>" disabled>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Tên khách hàng</label>
                        <input type="text" class="form-input" name="customer_name" value="<%= booking.getCustomerName() %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" class="form-input" name="customer_phone" value="<%= booking.getCustomerPhone() %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-input" name="customer_email" value="<%= booking.getCustomerEmail() != null ? booking.getCustomerEmail() : "" %>">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Chuyến xe</label>
                        <input type="text" class="form-input" value="<%= trip != null && trip.getRouteName() != null ? trip.getRouteName() : "Chuyến #" + booking.getTripId() %>" disabled>
                        <div class="info-text">Không thể thay đổi chuyến xe</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Ghế đã đặt</label>
                        <div class="seats-display">
                            <div class="seats-list">
                                <% 
                                    if (booking.getItems() != null && !booking.getItems().isEmpty()) {
                                        for (BookingItem item : booking.getItems()) {
                                %>
                                <span class="seat-badge"><%= item.getSeatNumber() %></span>
                                <% 
                                        }
                                    } else if (booking.getSeatNumber() != null) {
                                %>
                                <span class="seat-badge"><%= booking.getSeatNumber() %></span>
                                <% } %>
                            </div>
                        </div>
                        <div class="info-text">Không thể thay đổi ghế đã đặt</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Tổng tiền</label>
                        <input type="text" class="form-input" value="<%= String.format("%,.0f đ", booking.getTotalPrice()) %>" disabled>
                        <div class="info-text">Không thể thay đổi giá vé</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select" required>
                            <option value="pending" <%= "pending".equals(booking.getStatus()) ? "selected" : "" %>>Pending</option>
                            <option value="confirmed" <%= "confirmed".equals(booking.getStatus()) ? "selected" : "" %>>Confirmed</option>
                            <option value="cancelled" <%= "cancelled".equals(booking.getStatus()) ? "selected" : "" %>>Cancelled</option>
                        </select>
                        <div class="info-text">Chọn trạng thái mới cho vé</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Ngày đặt</label>
                        <input type="text" class="form-input" value="<%= booking.getBookingDate() != null ? booking.getBookingDate().format(dateFormatter) : "N/A" %>" disabled>
                    </div>

                    <div class="actions">
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        <a href="<%= ctx %>/admin/booking-detail?id=<%= booking.getId() %>" class="btn btn-secondary">Hủy</a>
                    </div>
                </form>
            </div>
            <% } else { %>
            <div class="edit-card">
                <p>Không tìm thấy thông tin vé.</p>
                <a href="<%= ctx %>/admin/bookings" class="btn btn-secondary">Quay lại danh sách</a>
            </div>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>

