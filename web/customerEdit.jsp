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
    
    String errorMessage = (String) request.getAttribute("errorMessage");
    boolean isCurrentUser = customer.getUsername().equals(username);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa thông tin khách hàng</title>
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
            max-width: 800px;
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
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-weight: 600;
            color: var(--muted);
            margin-bottom: 8px;
            font-size: 14px;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 14px;
            border: 2px solid var(--border);
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f9fafb;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            background: #fff;
            box-shadow: 0 0 0 4px rgba(12, 98, 240, 0.1);
        }
        .form-group .readonly {
            background: #f3f4f6;
            color: var(--muted);
            cursor: not-allowed;
        }
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #93c5fd;
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
        .actions {
            margin-top: 24px;
            display: flex;
            gap: 12px;
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
            <a class="active" href="<%= ctx %>/admin/customers">Khách hàng</a>
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
            <h1 class="page-title">Sửa thông tin khách hàng</h1>

            <% if (errorMessage != null) { %>
                <div class="alert alert-error"><%= errorMessage %></div>
            <% } %>
            
            <% if (isCurrentUser) { %>
                <div class="alert alert-info">
                    ⚠️ Bạn đang sửa thông tin của chính mình. Không thể thay đổi role của chính mình.
                </div>
            <% } %>

            <div class="card">
                <form method="post" action="<%= ctx %>/admin/customers">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= customer.getId() %>">
                    
                    <div class="form-group">
                        <label>ID</label>
                        <input type="text" value="<%= customer.getId() %>" readonly class="readonly">
                    </div>
                    
                    <div class="form-group">
                        <label>Tên đăng nhập</label>
                        <input type="text" value="<%= customer.getUsername() %>" readonly class="readonly">
                    </div>
                    
                    <div class="form-group">
                        <label>Họ và tên *</label>
                        <input type="text" name="fullName" value="<%= customer.getFullName() != null ? customer.getFullName() : "" %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="<%= customer.getEmail() != null ? customer.getEmail() : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="tel" name="phone" value="<%= customer.getPhone() != null ? customer.getPhone() : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label>Role *</label>
                        <select name="role" <%= isCurrentUser ? "disabled" : "" %> required>
                            <option value="user" <%= "user".equals(customer.getRole()) ? "selected" : "" %>>Khách hàng</option>
                            <option value="admin" <%= "admin".equals(customer.getRole()) ? "selected" : "" %>>Admin</option>
                        </select>
                        <% if (isCurrentUser) { %>
                            <input type="hidden" name="role" value="<%= customer.getRole() %>">
                            <p style="margin-top: 8px; color: var(--muted); font-size: 13px;">
                                ⚠️ Không thể thay đổi role của chính mình
                            </p>
                        <% } %>
                    </div>
                    
                    <div class="actions">
                        <a href="<%= ctx %>/admin/customers?action=detail&id=<%= customer.getId() %>" class="btn btn-secondary">Hủy</a>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </section>
    </main>
</div>
</body>
</html>

