<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Bus" %>
<%
    List<Bus> buses = (List<Bus>) request.getAttribute("buses");
    int totalBuses = buses != null ? buses.size() : 0;
    Integer totalBusesAttr = (Integer) request.getAttribute("totalBuses");
    if (totalBusesAttr != null) {
        totalBuses = totalBusesAttr;
    }
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
    <title>Quản lý xe và ghế</title>
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
        .brand { display: flex; align-items: center; gap: 10px; font-weight: 700; font-size: 20px; }
        .brand-logo {
            width: 40px; height: 40px; border-radius: 10px;
            background: linear-gradient(135deg,#0c62f0,#4cc9f0);
            display: grid; place-items: center; color: #fff; font-weight: 800; font-size: 16px;
        }
        .menu { display: flex; flex-direction: column; gap: 10px; }
        .menu a {
            padding: 12px 14px; border-radius: 10px; color: #cbd5e1;
            display: flex; align-items: center; gap: 10px; transition: 0.2s;
        }
        .menu a.active, .menu a:hover {
            background: rgba(255,255,255,0.08); color: #fff;
        }
        .header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 18px 24px; background: var(--surface); border-bottom: 1px solid var(--border);
            position: sticky; top: 0; z-index: 5;
        }
        .search { width: 320px; }
        .search input {
            width: 100%; padding: 10px 12px; border-radius: 10px; border: 1px solid var(--border);
            background: #f8fafc;
        }
        .user { display: flex; align-items: center; gap: 10px; font-weight: 600; }
        .avatar {
            width: 36px; height: 36px; border-radius: 50%; background: #e2e8f0;
            display: grid; place-items: center; color: #0b1f3a; font-weight: 700;
        }
        .content { padding: 24px 32px 48px; max-width: 1400px; margin: 0 auto; width: 100%; }
        .page-title { margin: 0 0 16px; font-size: 28px; font-weight: 700; }
        .cards { display: grid; grid-template-columns: repeat(auto-fit,minmax(260px,1fr)); gap: 18px; margin-bottom: 22px; }
        .card {
            background: var(--surface); padding: 16px; border-radius: 12px; border: 1px solid var(--border);
            box-shadow: 0 4px 12px rgba(0,0,0,0.04); display: grid; gap: 6px;
        }
        .card.anchor-target { scroll-margin-top: 80px; }
        .card-label { color: var(--muted); font-size: 13px; }
        .card-value { font-size: 24px; font-weight: 700; }
        .grid { display: grid; grid-template-columns: 1fr; gap: 18px; margin-top: 12px; }
        .section-title { font-size: 18px; margin: 0 0 12px; }
        form .row { display: flex; gap: 12px; margin-bottom: 10px; flex-wrap: wrap; }
        form label { font-weight: 700; color: var(--muted); display: block; margin-bottom: 4px; font-size: 16px; }
        form input, form select {
            padding: 13px 14px; border-radius: 10px; border: 1px solid var(--border); width: 100%;
            background: #f8fafc; font-size: 15.5px;
        }
        .btn {
            border: none; border-radius: 10px; padding: 10px 14px; font-weight: 600; cursor: pointer;
            transition: 0.2s; display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-primary:hover { background: var(--primary-dark); }
        .btn-danger { background: var(--danger); color: #fff; }
        table { width: 100%; border-collapse: collapse; margin-top: 8px; }
        th, td { padding: 15px 12px; border-bottom: 1px solid var(--border); text-align: left; font-size: 16px; }
        th { color: var(--muted); font-size: 15px; letter-spacing: 0.2px; font-weight: 700; }
        tr:hover { background: #f8fafc; }
        .actions { display: flex; gap: 8px; flex-wrap: wrap; }
        .inline-form { display: inline; }
        .status-badge {
            padding: 4px 10px; border-radius: 6px; font-size: 13px; font-weight: 600;
            display: inline-block;
        }
        .status-active { background: #d4edda; color: #155724; }
        .status-maintenance { background: #fff3cd; color: #856404; }
        .status-inactive { background: #f8d7da; color: #721c24; }
        @media (max-width: 1100px) {
            .layout { grid-template-columns: 70px 1fr; }
            .sidebar { align-items: center; padding: 18px 10px; }
            .brand span, .menu a span { display: none; }
            .menu a { justify-content: center; }
            .search { width: 200px; }
        }
        @media (max-width: 800px) {
            .grid { grid-template-columns: 1fr; }
            .cards { grid-template-columns: repeat(auto-fit,minmax(160px,1fr)); }
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
            <a href="/doAnTu/admin">Trang quản trị</a>
            <a href="/doAnTu/admin/tuyen-xe">Tuyến xe</a>
            <a href="/doAnTu/admin/chuyen-xe">Chuyến xe</a>
            <a class="active" href="/doAnTu/admin/xe-va-ghe">Xe và ghế</a>
            <a href="/doAnTu/admin/bookings">Vé đã đặt</a>
            <a href="/doAnTu/admin/customers">Khách hàng</a>
            <a href="#">Nhà xe</a>
            <a href="#">Phản hồi</a>
            <a href="#">Quản trị viên</a>
        </nav>
    </aside>
    <main>
        <header class="header">
            <div class="search">
                <input type="text" placeholder="Tìm kiếm nhanh...">
            </div>
            <div class="user">
                <div class="avatar"><%= userDisplay.substring(0,1).toUpperCase() %></div>
                <span><%= userDisplay %></span>
                <a class="btn btn-primary" href="<%= ctx %>/logout" style="margin-left:8px;">Đăng xuất</a>
            </div>
        </header>

        <section class="content">
            <h1 class="page-title">Quản lý xe và ghế</h1>

            <div class="cards">
                <div class="card">
                    <div class="card-label">Tổng số xe</div>
                    <div class="card-value"><%= totalBuses %></div>
                </div>
            </div>

        <div class="grid">
            <div class="card anchor-target" id="buses">
                <h2 class="section-title">Thêm xe mới</h2>
                <form method="post" action="/doAnTu/admin/xe-va-ghe">
                    <input type="hidden" name="action" value="add">
                    <div class="row">
                        <div style="flex:1">
                            <label>Biển số xe</label>
                            <input type="text" name="licensePlate" required placeholder="VD: 51A-12345">
                        </div>
                        <div style="flex:1">
                            <label>Hãng xe</label>
                            <input type="text" name="brand" required placeholder="VD: Thaco, Mercedes">
                        </div>
                    </div>
                    <div class="row">
                        <div style="flex:1">
                            <label>Mẫu xe</label>
                            <input type="text" name="model" required placeholder="VD: King Long, Sprinter">
                        </div>
                        <div style="flex:1">
                            <label>Năm sản xuất</label>
                            <input type="number" name="year" required min="2000" max="2030" placeholder="VD: 2020">
                        </div>
                    </div>
                    <div class="row">
                        <div style="flex:1">
                            <label>Số lượng ghế</label>
                            <input type="number" name="totalSeats" required min="1" max="60" placeholder="VD: 45">
                        </div>
                        <div style="flex:1">
                            <label>Loại ghế</label>
                            <select name="seatType" required>
                                <option value="thường">Thường</option>
                                <option value="giường nằm">Giường nằm</option>
                                <option value="VIP">VIP</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div style="flex:1">
                            <label>Trạng thái</label>
                            <select name="status" required>
                                <option value="active">Đang hoạt động</option>
                                <option value="maintenance">Bảo trì</option>
                                <option value="inactive">Ngừng hoạt động</option>
                            </select>
                        </div>
                    </div>
                    <button class="btn btn-primary" type="submit">Thêm xe</button>
                </form>
            </div>
        </div>

            <div class="grid">
                <div class="card">
                    <h2 class="section-title">Danh sách xe</h2>
                    <table>
                        <tr>
                            <th>ID</th>
                            <th>Biển số</th>
                            <th>Hãng xe</th>
                            <th>Mẫu xe</th>
                            <th>Năm SX</th>
                            <th>Số ghế</th>
                            <th>Loại ghế</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        <%
                            if (buses != null) {
                                for (Bus b : buses) {
                        %>
                        <tr class="bus-row" data-id="<%= b.getId() %>">
                            <td><%= b.getId() %></td>
                            <td><input class="bus-input" type="text" name="licensePlate" value="<%= b.getLicensePlate() %>" readonly></td>
                            <td><input class="bus-input" type="text" name="brand" value="<%= b.getBrand() %>" readonly></td>
                            <td><input class="bus-input" type="text" name="model" value="<%= b.getModel() %>" readonly></td>
                            <td><input class="bus-input" type="number" name="year" value="<%= b.getYear() %>" readonly min="2000" max="2030"></td>
                            <td><input class="bus-input" type="number" name="totalSeats" value="<%= b.getTotalSeats() %>" readonly min="1" max="60"></td>
                            <td>
                                <select class="bus-input" name="seatType" disabled style="width: 100%;">
                                    <option value="thường" <%= "thường".equals(b.getSeatType()) ? "selected" : "" %>>Thường</option>
                                    <option value="giường nằm" <%= "giường nằm".equals(b.getSeatType()) ? "selected" : "" %>>Giường nằm</option>
                                    <option value="VIP" <%= "VIP".equals(b.getSeatType()) ? "selected" : "" %>>VIP</option>
                                </select>
                            </td>
                            <td>
                                <select class="bus-input" name="status" disabled style="width: 100%;">
                                    <option value="active" <%= "active".equals(b.getStatus()) ? "selected" : "" %>>Đang hoạt động</option>
                                    <option value="maintenance" <%= "maintenance".equals(b.getStatus()) ? "selected" : "" %>>Bảo trì</option>
                                    <option value="inactive" <%= "inactive".equals(b.getStatus()) ? "selected" : "" %>>Ngừng hoạt động</option>
                                </select>
                            </td>
                            <td class="actions">
                                <form class="update-form inline-form" method="post" action="/doAnTu/admin/xe-va-ghe">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="<%= b.getId() %>">
                                    <input type="hidden" name="licensePlate">
                                    <input type="hidden" name="brand">
                                    <input type="hidden" name="model">
                                    <input type="hidden" name="year">
                                    <input type="hidden" name="totalSeats">
                                    <input type="hidden" name="seatType">
                                    <input type="hidden" name="status">
                                    <button class="btn btn-primary edit-btn" type="button" data-mode="view">Sửa</button>
                                </form>
                                <form class="inline-form" method="post" action="/doAnTu/admin/xe-va-ghe" onsubmit="return confirm('Xóa xe này?');">
                                    <input type="hidden" name="id" value="<%= b.getId() %>">
                                    <input type="hidden" name="action" value="delete">
                                    <button class="btn btn-danger" type="submit">Xóa</button>
                                </form>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </table>
                </div>

            </div>
        </section>
    </main>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.bus-row').forEach(function (row) {
            var inputs = row.querySelectorAll('.bus-input');
            var btn = row.querySelector('.edit-btn');
            var updateForm = row.querySelector('.update-form');
            btn.addEventListener('click', function () {
                if (btn.dataset.mode === 'view') {
                    inputs.forEach(function (i) { 
                        i.readOnly = false; 
                        i.disabled = false;
                    });
                    btn.dataset.mode = 'edit';
                    btn.textContent = 'Lưu';
                } else {
                    var licensePlateInput = row.querySelector('input[name="licensePlate"]');
                    var brandInput = row.querySelector('input[name="brand"]');
                    var modelInput = row.querySelector('input[name="model"]');
                    var yearInput = row.querySelector('input[name="year"]');
                    var totalSeatsInput = row.querySelector('input[name="totalSeats"]');
                    var seatTypeSelect = row.querySelector('select[name="seatType"]');
                    var statusSelect = row.querySelector('select[name="status"]');
                    
                    if (licensePlateInput && brandInput && modelInput && yearInput && totalSeatsInput && seatTypeSelect && statusSelect) {
                        updateForm.querySelector('input[name="licensePlate"]').value = licensePlateInput.value;
                        updateForm.querySelector('input[name="brand"]').value = brandInput.value;
                        updateForm.querySelector('input[name="model"]').value = modelInput.value;
                        updateForm.querySelector('input[name="year"]').value = yearInput.value;
                        updateForm.querySelector('input[name="totalSeats"]').value = totalSeatsInput.value;
                        updateForm.querySelector('input[name="seatType"]').value = seatTypeSelect.value;
                        updateForm.querySelector('input[name="status"]').value = statusSelect.value;
                        updateForm.submit();
                    }
                }
            });
        });
    });
</script>
</body>
</html>

