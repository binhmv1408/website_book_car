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
    <title>Chi tiết vé đã đặt</title>
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
        .detail-card {
            background: var(--surface);
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid var(--border);
            margin-bottom: 24px;
        }
        .detail-section {
            margin-bottom: 32px;
        }
        .detail-section:last-child {
            margin-bottom: 0;
        }
        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--border);
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .info-label {
            font-size: 13px;
            color: var(--muted);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 16px;
            color: #1a202c;
            font-weight: 600;
        }
        .status-badge {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
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
        .price-highlight {
            font-size: 32px;
            font-weight: 800;
            color: var(--primary);
        }
        .actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
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
        .btn-danger {
            background: var(--danger);
            color: #fff;
        }
        .btn-danger:hover {
            background: #c0392b;
        }
        .btn-secondary {
            background: #e2e8f0;
            color: #4b5563;
        }
        .btn-secondary:hover {
            background: #cbd5e0;
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
                <span>Chi tiết vé #<%= booking != null ? booking.getId() : "" %></span>
            </div>

            <% if (booking != null) { %>
            <div class="detail-card">
                <div class="detail-section">
                    <div class="section-title">Thông tin khách hàng</div>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Họ và tên</div>
                            <div class="info-value"><%= booking.getCustomerName() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Số điện thoại</div>
                            <div class="info-value"><%= booking.getCustomerPhone() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Email</div>
                            <div class="info-value"><%= booking.getCustomerEmail() != null ? booking.getCustomerEmail() : "N/A" %></div>
                        </div>
                    </div>
                </div>

                <div class="detail-section">
                    <div class="section-title">Thông tin chuyến xe</div>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Mã chuyến</div>
                            <div class="info-value">#<%= trip != null ? trip.getId() : booking.getTripId() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Tuyến xe</div>
                            <div class="info-value"><%= trip != null && trip.getRouteName() != null ? trip.getRouteName() : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Ngày khởi hành</div>
                            <div class="info-value"><%= trip != null && trip.getDepartureTime() != null ? trip.getDepartureTime().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "N/A" %></div>
                        </div>
                    </div>
                </div>

                <div class="detail-section">
                    <div class="section-title">Thông tin ghế</div>
                    <div class="info-item">
                        <div class="info-label">Số lượng ghế</div>
                        <div class="info-value" style="margin-bottom: 12px;"><%= booking.getQuantity() > 0 ? booking.getQuantity() : 1 %> ghế</div>
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
                </div>

                <div class="detail-section">
                    <div class="section-title">Thông tin thanh toán</div>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Tổng tiền</div>
                            <div class="info-value price-highlight"><%= String.format("%,.0f đ", booking.getTotalPrice()) %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Ngày đặt</div>
                            <div class="info-value"><%= booking.getBookingDate() != null ? booking.getBookingDate().format(dateFormatter) : "N/A" %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Trạng thái</div>
                            <div class="info-value">
                                <span class="status-badge status-<%= booking.getStatus() != null ? booking.getStatus() : "pending" %>">
                                    <%= booking.getStatus() != null ? booking.getStatus() : "pending" %>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="actions">
                    <a href="<%= ctx %>/admin/booking-edit?id=<%= booking.getId() %>" class="btn btn-primary">Sửa vé</a>
                    <a href="<%= ctx %>/admin/bookings" class="btn btn-secondary">Quay lại danh sách</a>
                    <a href="<%= ctx %>/admin/booking-delete?id=<%= booking.getId() %>" 
                       class="btn btn-danger" 
                       onclick="return confirm('Bạn có chắc muốn xóa vé #<%= booking.getId() %>? Hành động này không thể hoàn tác!')">Xóa vé</a>
                </div>
            </div>
            <% } else { %>
            <div class="detail-card">
                <p>Không tìm thấy thông tin vé.</p>
                <a href="<%= ctx %>/admin/bookings" class="btn btn-secondary">Quay lại danh sách</a>
            </div>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>

