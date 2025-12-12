<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.Route" %>
<%@ page import="model.Trip" %>
<%@ page import="model.Bus" %>
<%
    List<Route> routes = (List<Route>) request.getAttribute("routes");
    List<Bus> buses = (List<Bus>) request.getAttribute("buses");
    List<Trip> trips = (List<Trip>) request.getAttribute("trips");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
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
    <title>Quản lý chuyến xe</title>
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
        .menu a.active, .menu a:hover { background: rgba(255,255,255,0.08); color: #fff; }
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
            <a class="active" href="/doAnTu/admin/chuyen-xe">Chuyến xe</a>
            <a href="/doAnTu/admin/xe-va-ghe">Xe và ghế</a>
            <a href="<%= ctx %>/admin/bookings">Vé đã đặt</a>
            <a href="<%= ctx %>/admin/customers">Khách hàng</a>
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
            <h1 class="page-title">Quản lý chuyến xe</h1>

            <div class="cards">
                <div class="card">
                    <div class="card-label">Tổng chuyến xe</div>
                    <div class="card-value"><%= trips != null ? trips.size() : 0 %></div>
                </div>
            </div>

            <div class="grid">
                <div class="card anchor-target">
                    <h2 class="section-title">Thêm chuyến xe</h2>
                    <form method="post" action="/doAnTu/admin/chuyen-xe">
                        <input type="hidden" name="action" value="add">
                        <div class="row">
                            <div style="flex:1">
                                <label>Tuyến xe</label>
                                <select name="routeId" required>
                                    <option value="">-- Chọn tuyến --</option>
                                    <%
                                        if (routes != null) {
                                            for (Route r : routes) {
                                    %>
                                    <option value="<%= r.getId() %>"><%= r.getName() %> (<%= r.getOrigin() %> - <%= r.getDestination() %>)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div style="flex:1">
                                <label>Xe</label>
                                <select name="busId" required>
                                    <option value="">-- Chọn xe --</option>
                                    <%
                                        if (buses != null) {
                                            for (Bus b : buses) {
                                    %>
                                    <option value="<%= b.getId() %>"><%= b.getLicensePlate() %> - <%= b.getBrand() %> <%= b.getModel() %> (<%= b.getTotalSeats() %> ghế)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div style="flex:1">
                                <label>Giờ khởi hành</label>
                                <input type="datetime-local" name="departureTime" required>
                            </div>
                        </div>
                        <button class="btn btn-primary" type="submit">Thêm chuyến</button>
                    </form>
                </div>
            </div>

            <div class="grid">
                <div class="card">
                    <h2 class="section-title">Danh sách chuyến xe</h2>
                    <table>
                        <tr>
                            <th>ID</th>
                            <th>Tuyến</th>
                            <th>Xe</th>
                            <th>Giờ khởi hành</th>
                            <th>Thao tác</th>
                        </tr>
                        <%
                            if (trips != null) {
                                for (Trip t : trips) {
                                    String departureValue = t.getDepartureTime().format(dateFormatter);
                        %>
                        <tr class="trip-row" data-id="<%= t.getId() %>">
                            <td><%= t.getId() %></td>
                            <td>
                                <select class="trip-input" name="routeId" disabled>
                                    <%
                                        if (routes != null) {
                                            for (Route r : routes) {
                                    %>
                                    <option value="<%= r.getId() %>" <%= r.getId() == t.getRouteId() ? "selected" : "" %>><%= r.getName() %> (<%= r.getOrigin() %> - <%= r.getDestination() %>)</option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </td>
                            <td>
                                <select class="trip-input" name="busId" disabled>
                                    <%
                                        if (buses != null) {
                                            for (Bus b : buses) {
                                    %>
                                    <option value="<%= b.getId() %>" <%= b.getId() == t.getBusId() ? "selected" : "" %>><%= b.getLicensePlate() %> - <%= b.getBrand() %> <%= b.getModel() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </td>
                            <td><input class="trip-input" type="datetime-local" name="departureTime" value="<%= departureValue %>" readonly></td>
                            <td class="actions">
                                <form class="trip-update-form inline-form" method="post" action="/doAnTu/admin/chuyen-xe">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="<%= t.getId() %>">
                                    <input type="hidden" name="routeId">
                                    <input type="hidden" name="busId">
                                    <input type="hidden" name="departureTime">
                                    <button class="btn btn-primary trip-edit-btn" type="button" data-mode="view">Sửa</button>
                                </form>
                                <form class="inline-form" method="post" action="/doAnTu/admin/chuyen-xe" onsubmit="return confirm('Xóa chuyến này?');">
                                    <input type="hidden" name="id" value="<%= t.getId() %>">
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
        document.querySelectorAll('.trip-row').forEach(function (row) {
            var routeSelect = row.querySelector('select.trip-input[name="routeId"]');
            var busSelect = row.querySelector('select.trip-input[name="busId"]');
            var datetime = row.querySelector('input.trip-input[name="departureTime"]');
            var btn = row.querySelector('.trip-edit-btn');
            var form = row.querySelector('.trip-update-form');
            
            if (!routeSelect || !busSelect || !datetime || !btn || !form) return;
            
            btn.addEventListener('click', function () {
                if (btn.dataset.mode === 'view') {
                    // Bật chỉnh sửa
                    routeSelect.disabled = false;
                    busSelect.disabled = false;
                    datetime.removeAttribute('readonly');
                    btn.dataset.mode = 'edit';
                    btn.textContent = 'Lưu';
                } else {
                    // Lưu dữ liệu
                    var routeIdValue = routeSelect.value;
                    var busIdValue = busSelect.value;
                    var departureTimeValue = datetime.value;
                    
                    if (!routeIdValue || !busIdValue || !departureTimeValue) {
                        alert('Vui lòng điền đầy đủ thông tin!');
                        return;
                    }
                    
                    var routeIdHidden = form.querySelector('input[name="routeId"]');
                    var busIdHidden = form.querySelector('input[name="busId"]');
                    var departureTimeHidden = form.querySelector('input[name="departureTime"]');
                    
                    if (routeIdHidden) routeIdHidden.value = routeIdValue;
                    if (busIdHidden) busIdHidden.value = busIdValue;
                    if (departureTimeHidden) departureTimeHidden.value = departureTimeValue;
                    
                    form.submit();
                }
            });
        });
    });
</script>
</body>
</html>

