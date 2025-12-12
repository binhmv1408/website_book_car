<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    List<User> customers = (List<User>) request.getAttribute("customers");
    int totalCustomers = customers != null ? customers.size() : 0;
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    String ctx = request.getContextPath();
    String role = (String) session.getAttribute("userRole");
    String username = (String) session.getAttribute("username");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect(ctx + "/login");
        return;
    }
    String userDisplay = (username != null && !username.isEmpty()) ? username : "Admin";
    
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
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
            width: 320px;
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
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
            overflow-y: auto;
        }
        .page-title {
            margin: 0 0 16px;
            font-size: 28px;
            font-weight: 700;
        }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 18px;
            margin-bottom: 22px;
        }
        .card {
            background: var(--surface);
            padding: 16px;
            border-radius: 12px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
            display: grid;
            gap: 6px;
        }
        .card-label {
            color: var(--muted);
            font-size: 13px;
        }
        .card-value {
            font-size: 24px;
            font-weight: 700;
        }
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #6ee7b7;
        }
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 8px;
            background: var(--surface);
            border-radius: 12px;
            overflow: hidden;
        }
        th, td {
            padding: 15px 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
            font-size: 16px;
        }
        th {
            color: var(--muted);
            font-size: 15px;
            letter-spacing: 0.2px;
            font-weight: 700;
            background: #f8fafc;
        }
        tr:hover {
            background: #f8fafc;
        }
        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .btn {
            border: none;
            border-radius: 8px;
            padding: 8px 14px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
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
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--muted);
        }
        .empty-state svg {
            width: 120px;
            height: 120px;
            margin: 0 auto 20px;
            opacity: 0.5;
        }
        @media (max-width: 1100px) {
            .layout { grid-template-columns: 70px 1fr; }
            .sidebar { align-items: center; padding: 18px 10px; }
            .brand span, .menu a span { display: none; }
            .menu a { justify-content: center; }
            .search { width: 200px; }
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
            <div class="search">
                <input type="text" placeholder="Tìm kiếm nhanh..." id="searchInput">
            </div>
            <div class="user">
                <div class="avatar"><%= userDisplay.substring(0,1).toUpperCase() %></div>
                <span><%= userDisplay %></span>
                <a href="<%= ctx %>/logout" class="btn btn-danger" style="margin-left: 12px;">Đăng xuất</a>
            </div>
        </header>

        <section class="content">
            <h1 class="page-title">Quản lý người dùng</h1>

            <% if (successMessage != null) { %>
                <div class="alert alert-success"><%= successMessage %></div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-error"><%= errorMessage %></div>
            <% } %>

            <div class="cards">
                <div class="card">
                    <div class="card-label">Tổng số người dùng</div>
                    <div class="card-value"><%= totalCustomers %></div>
                </div>
            </div>

            <div class="card">
                <h2 style="margin: 0 0 16px; font-size: 20px;">Danh sách người dùng</h2>
                
                <% if (customers == null || customers.isEmpty()) { %>
                    <div class="empty-state">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        <h3>Chưa có người dùng nào</h3>
                        <p>Người dùng sẽ xuất hiện ở đây sau khi đăng ký tài khoản.</p>
                    </div>
                <% } else { %>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên đăng nhập</th>
                                <th>Họ và tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Role</th>
                                <th>Trạng thái</th>
                                <th>Ngày đăng ký</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="customerTableBody">
                            <% for (User customer : customers) { %>
                                <tr>
                                    <td><%= customer.getId() %></td>
                                    <td><strong><%= customer.getUsername() %></strong></td>
                                    <td><%= customer.getFullName() != null ? customer.getFullName() : "-" %></td>
                                    <td><%= customer.getEmail() != null && !customer.getEmail().isEmpty() ? customer.getEmail() : "-" %></td>
                                    <td><%= customer.getPhone() != null && !customer.getPhone().isEmpty() ? customer.getPhone() : "-" %></td>
                                    <td>
                                        <span class="badge <%= "admin".equals(customer.getRole()) ? "badge-warning" : "badge-success" %>">
                                            <%= "admin".equals(customer.getRole()) ? "Admin" : "Khách hàng" %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (customer.isBlocked()) { %>
                                            <span class="badge badge-danger">Đã khóa</span>
                                        <% } else { %>
                                            <span class="badge badge-success">Hoạt động</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (customer.getCreatedAt() != null) { %>
                                            <%= customer.getCreatedAt().format(dateFormatter) %>
                                        <% } else { %>
                                            -
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="<%= ctx %>/admin/customers?action=detail&id=<%= customer.getId() %>" class="btn btn-primary">Xem</a>
                                            <a href="<%= ctx %>/admin/customers?action=edit&id=<%= customer.getId() %>" class="btn btn-secondary">Sửa</a>
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
                                                        <button type="submit" class="btn" style="background: #f59e0b; color: #fff;">Khóa</button>
                                                    </form>
                                                <% } %>
                                            <% } %>
                                            <% if (!isAdmin) { %>
                                            <form method="post" action="<%= ctx %>/admin/customers" style="display: inline;" onsubmit="return confirm('Bạn có chắc muốn xóa khách hàng này?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= customer.getId() %>">
                                                <button type="submit" class="btn btn-danger">Xóa</button>
                                            </form>
                                            <% } %>
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
    // Tìm kiếm khách hàng
    document.getElementById('searchInput')?.addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#customerTableBody tr');
        
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? '' : 'none';
        });
    });
</script>
</body>
</html>

