<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page import="model.BookingItem" %>
<%@ page import="model.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    int totalBookings = bookings != null ? bookings.size() : 0;
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    String ctx = request.getContextPath();
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
    <title>Quản lý vé đã đặt</title>
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
        html { scroll-behavior: smooth; }
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
        .search input {
            padding: 10px 16px;
            border: 1px solid var(--border);
            border-radius: 8px;
            width: 300px;
            font-size: 14px;
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
        }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }
        .card {
            background: var(--surface);
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid var(--border);
        }
        .card-label {
            font-size: 14px;
            color: var(--muted);
            margin-bottom: 8px;
            font-weight: 600;
        }
        .card-value {
            font-size: 32px;
            font-weight: 800;
            color: var(--primary);
        }
        .table-container {
            background: var(--surface);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid var(--border);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        thead {
            background: #f8fafc;
        }
        th {
            padding: 16px;
            text-align: left;
            font-weight: 700;
            color: #374151;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid var(--border);
        }
        td {
            padding: 16px;
            border-bottom: 1px solid var(--border);
            color: #4b5563;
        }
        tbody tr:hover {
            background: #f9fafb;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
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
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-edit {
            background: #dbeafe;
            color: #1e40af;
        }
        .btn-edit:hover {
            background: #bfdbfe;
        }
        .btn-delete {
            background: #fee2e2;
            color: #991b1b;
        }
        .btn-delete:hover {
            background: #fecaca;
        }
        .btn-view {
            background: #d1fae5;
            color: #065f46;
        }
        .btn-view:hover {
            background: #a7f3d0;
        }
        .actions {
            display: flex;
            gap: 8px;
        }
        .seats-list {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
        }
        .seat-badge {
            background: #e0e7ff;
            color: #3730a3;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
        }
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: var(--muted);
        }
        .no-data-icon {
            font-size: 64px;
            margin-bottom: 16px;
            opacity: 0.3;
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
            <div class="search">
                <input type="text" placeholder="Tìm kiếm nhanh..." id="searchInput">
            </div>
            <div class="user">
                <div class="avatar"><%= userDisplay.substring(0,1).toUpperCase() %></div>
                <span><%= userDisplay %></span>
                <a class="btn btn-primary" href="<%= ctx %>/logout" style="margin-left:8px;">Đăng xuất</a>
            </div>
        </header>

        <section class="content">
            <h1 class="page-title">Quản lý vé đã đặt</h1>

            <div class="cards">
                <div class="card">
                    <div class="card-label">Tổng số vé</div>
                    <div class="card-value"><%= totalBookings %></div>
                </div>
            </div>

            <div class="table-container">
                <% if (bookings == null || bookings.isEmpty()) { %>
                <div class="no-data">
                    <div class="no-data-icon">🎫</div>
                    <div style="font-size: 18px; font-weight: 700; margin-bottom: 8px;">Chưa có vé nào được đặt</div>
                    <div style="color: var(--muted);">Các vé đặt sẽ hiển thị ở đây</div>
                </div>
                <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người đặt</th>
                            <th>Khách hàng</th>
                            <th>SĐT</th>
                            <th>Chuyến xe</th>
                            <th>Điểm đi</th>
                            <th>Điểm đến</th>
                            <th>Số ghế</th>
                            <th>Số lượng</th>
                            <th>Giá vé</th>
                            <th>Ngày đặt</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="bookingsTable">
                        <% for (Booking booking : bookings) { 
                            User bookingUser = (User) request.getAttribute("user_" + (booking.getUserId() != null ? booking.getUserId() : 0));
                        %>
                        <tr>
                            <td><strong>#<%= booking.getId() %></strong></td>
                            <td>
                                <% if (bookingUser != null) { %>
                                    <span style="color: var(--primary); font-weight: 600;"><%= bookingUser.getUsername() %></span>
                                    <br><small style="color: var(--muted);"><%= bookingUser.getFullName() != null ? bookingUser.getFullName() : "" %></small>
                                <% } else { %>
                                    <span style="color: var(--muted);">Khách vãng lai</span>
                                <% } %>
                            </td>
                            <td><%= booking.getCustomerName() %></td>
                            <td><%= booking.getCustomerPhone() %></td>
                            <td>
                                <% 
                                    String routeName = (String) request.getAttribute("routeName_" + booking.getTripId());
                                    if (routeName == null) routeName = "Chuyến #" + booking.getTripId();
                                %>
                                <%= routeName %>
                            </td>
                            <td>
                                <% 
                                    String origin = (String) request.getAttribute("origin_" + booking.getTripId());
                                    if (origin == null) origin = "N/A";
                                %>
                                <strong><%= origin %></strong>
                            </td>
                            <td>
                                <% 
                                    String destination = (String) request.getAttribute("destination_" + booking.getTripId());
                                    if (destination == null) destination = "N/A";
                                %>
                                <strong><%= destination %></strong>
                            </td>
                            <td>
                                <div class="seats-list">
                                    <% 
                                        if (booking.getItems() != null && !booking.getItems().isEmpty()) {
                                            for (BookingItem item : booking.getItems()) {
                                    %>
                                    <span class="seat-badge"><%= item.getSeatNumber() %></span>
                                    <% 
                                            }
                                        } else {
                                    %>
                                    <span class="seat-badge"><%= booking.getSeatNumber() != null ? booking.getSeatNumber() : "N/A" %></span>
                                    <% } %>
                                </div>
                            </td>
                            <td><%= booking.getQuantity() > 0 ? booking.getQuantity() : 1 %></td>
                            <td><strong><%= String.format("%,.0f đ", booking.getTotalPrice()) %></strong></td>
                            <td>
                                <%= booking.getBookingDate() != null ? booking.getBookingDate().format(dateFormatter) : "N/A" %>
                            </td>
                            <td>
                                <span class="status-badge status-<%= booking.getStatus() != null ? booking.getStatus() : "pending" %>">
                                    <%= booking.getStatus() != null ? booking.getStatus() : "pending" %>
                                </span>
                            </td>
                            <td>
                                <div class="actions">
                                    <a href="<%= ctx %>/admin/booking-detail?id=<%= booking.getId() %>" class="btn btn-view">Xem</a>
                                    <a href="<%= ctx %>/admin/booking-edit?id=<%= booking.getId() %>" class="btn btn-edit">Sửa</a>
                                    <a href="<%= ctx %>/admin/booking-delete?id=<%= booking.getId() %>" 
                                       class="btn btn-delete" 
                                       onclick="return confirm('Bạn có chắc muốn xóa vé #<%= booking.getId() %>?')">Xóa</a>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>
        </section>
    </main>
</div>

<script>
    // Tìm kiếm
    document.getElementById('searchInput')?.addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#bookingsTable tr');
        
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? '' : 'none';
        });
    });
</script>
</body>
</html>

