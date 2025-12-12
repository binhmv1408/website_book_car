<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    User customer = (User) request.getAttribute("customer");
    String ctx = request.getContextPath();
    String role = (String) session.getAttribute("userRole");
    String username = (String) session.getAttribute("username");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect(ctx + "/login");
        return;
    }
    if (customer == null) {
        response.sendRedirect(ctx + "/admin/customers");
        return;
    }
    String userDisplay = (username != null && !username.isEmpty()) ? username : "Admin";
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết người dùng</title>
    <style>
        :root {
            --sidebar-bg: #0b1f3a;
            --primary: #0c62f0;
            --primary-dark: #0a4ab3;
            --danger: #e74c3c;
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
            gap: 10px;
            font-weight: 600;
        }
        .avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #e2e8f0;
            display: grid;
            place-items: center;
            color: #0b1f3a;
            font-weight: 700;
        }
        .content {
            padding: 24px 32px 48px;
            max-width: 1000px;
            margin: 0 auto;
            width: 100%;
            overflow-y: auto;
        }
        .page-title {
            margin: 0 0 24px;
            font-size: 28px;
            font-weight: 700;
        }
        .card {
            background: var(--surface);
            padding: 24px;
            border-radius: 12px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
            margin-bottom: 20px;
        }
        .info-row {
            display: grid;
            grid-template-columns: 200px 1fr;
            padding: 16px 0;
            border-bottom: 1px solid var(--border);
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: var(--muted);
        }
        .info-value {
            color: #1a202c;
        }
        .btn {
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            text-decoration: none;
        }
        .btn-primary {
            background: var(--primary);
            color: #fff;
        }
        .btn-primary:hover {
            background: var(--primary-dark);
        }
        .btn-secondary {
            background: #6b7280;
            color: #fff;
        }
        .btn-secondary:hover {
            background: #4b5563;
        }
        .badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }
        .badge-warning {
            background: #fef3c7;
            color: #92400e;
        }
        .badge-danger {
            background: #fee2e2;
            color: #991b1b;
        }
        .actions {
            margin-top: 24px;
            display: flex;
            gap: 12px;
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
            <a href="<%= ctx %>/admin/bookings">Vé đã đặt</a>
            <a class="active" href="<%= ctx %>/admin/customers">Người dùng</a>
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
                <a href="<%= ctx %>/logout" class="btn btn-danger" style="margin-left: 12px;">Đăng xuất</a>
            </div>
        </header>

        <section class="content">
            <h1 class="page-title">Chi tiết người dùng</h1>

            <div class="card">
                <div class="info-row">
                    <div class="info-label">ID</div>
                    <div class="info-value"><strong><%= customer.getId() %></strong></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Tên đăng nhập</div>
                    <div class="info-value"><strong><%= customer.getUsername() %></strong></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Họ và tên</div>
                    <div class="info-value"><%= customer.getFullName() != null ? customer.getFullName() : "-" %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Email</div>
                    <div class="info-value"><%= customer.getEmail() != null && !customer.getEmail().isEmpty() ? customer.getEmail() : "-" %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Số điện thoại</div>
                    <div class="info-value"><%= customer.getPhone() != null && !customer.getPhone().isEmpty() ? customer.getPhone() : "-" %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Ngày đăng ký</div>
                    <div class="info-value">
                        <% if (customer.getCreatedAt() != null) { %>
                            <%= customer.getCreatedAt().format(dateFormatter) %>
                        <% } else { %>
                            -
                        <% } %>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label">Role</div>
                    <div class="info-value">
                        <span class="badge <%= "admin".equals(customer.getRole()) ? "badge-warning" : "badge-success" %>">
                            <%= "admin".equals(customer.getRole()) ? "Admin" : "Khách hàng" %>
                        </span>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label">Trạng thái</div>
                    <div class="info-value">
                        <% if (customer.isBlocked()) { %>
                            <span class="badge badge-danger">Đã khóa</span>
                        <% } else { %>
                            <span class="badge badge-success">Hoạt động</span>
                        <% } %>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label">Cập nhật lần cuối</div>
                    <div class="info-value">
                        <% if (customer.getUpdatedAt() != null) { %>
                            <%= customer.getUpdatedAt().format(dateFormatter) %>
                        <% } else { %>
                            -
                        <% } %>
                    </div>
                </div>
                
                <div class="actions">
                    <a href="<%= ctx %>/admin/customers" class="btn btn-secondary">← Quay lại</a>
                    <a href="<%= ctx %>/admin/customers?action=edit&id=<%= customer.getId() %>" class="btn btn-primary">Sửa thông tin</a>
                    <% 
                        String currentUsername = (String) session.getAttribute("username");
                        boolean isCurrentUser = customer.getUsername().equals(currentUsername);
                        boolean isAdmin = "admin".equals(customer.getRole());
                    %>
                    <% if (!isCurrentUser && !isAdmin) { %>
                        <% if (customer.isBlocked()) { %>
                            <form method="post" action="<%= ctx %>/admin/customers" style="display: inline;" onsubmit="return confirm('Bạn có chắc muốn mở khóa tài khoản này?');">
                                <input type="hidden" name="action" value="unblock">
                                <input type="hidden" name="id" value="<%= customer.getId() %>">
                                <button type="submit" class="btn" style="background: #10b981; color: #fff;">Mở khóa</button>
                            </form>
                        <% } else { %>
                            <form method="post" action="<%= ctx %>/admin/customers" style="display: inline;" onsubmit="return confirm('Bạn có chắc muốn khóa tài khoản này?');">
                                <input type="hidden" name="action" value="block">
                                <input type="hidden" name="id" value="<%= customer.getId() %>">
                                <button type="submit" class="btn" style="background: #f59e0b; color: #fff;">Khóa tài khoản</button>
                            </form>
                        <% } %>
                    <% } %>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>

