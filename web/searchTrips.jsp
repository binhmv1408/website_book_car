<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Trip" %>
<%
    String ctx = request.getContextPath();
    String assets = ctx + "/carbook";
    List<Trip> trips = (List<Trip>) request.getAttribute("trips");
    if (trips == null) {
        trips = java.util.Collections.emptyList();
    }
    String from = (String) request.getAttribute("from");
    String to = (String) request.getAttribute("to");
    String date = (String) request.getAttribute("date");
    String error = (String) request.getAttribute("error");
    java.time.format.DateTimeFormatter timeFmt = java.time.format.DateTimeFormatter.ofPattern("HH:mm");
    java.time.format.DateTimeFormatter dateFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
    java.time.format.DateTimeFormatter dateTimeFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm chuyến xe</title>
    <link rel="stylesheet" href="<%= ctx %>/carbook/css/style.css?v=1">
    <style>
        body {
            background: #f3f4f6;
            font-family: "Inter", Arial, sans-serif;
            background-image:
                url('<%= ctx %>/carbook/images/bg_1.jpg'),
                radial-gradient(circle at 20% 20%, rgba(99, 102, 241, 0.08), transparent 30%),
                radial-gradient(circle at 80% 0%, rgba(16, 185, 129, 0.08), transparent 26%),
                linear-gradient(180deg, #f8fafc 0%, #f1f5f9 35%, #f8fafc 100%);
            background-size: cover, auto, auto, auto;
            background-repeat: no-repeat, no-repeat, no-repeat, no-repeat;
            background-attachment: fixed;
            background-position: center, 20% 20%, 80% 0%, center;
            padding-top: 80px;
        }
        #ftco-navbar {
            position: sticky;
            top: 0;
            z-index: 1000;
            background: rgba(15, 23, 42, 0.45) !important;
            backdrop-filter: blur(6px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.12);
        }
        .page { max-width: 1200px; margin: 20px auto 30px; padding: 0 20px; }
        .layout { display: grid; grid-template-columns: 280px 1fr; gap: 16px; align-items: start; }
        .card { background: #fff; border-radius: 14px; padding: 20px; box-shadow: 0 10px 32px rgba(0,0,0,0.06); }
        .form-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px; }
        .form-group label { font-weight: 700; color: #374151; }
        .btn-primary { background: #2d5bff; border: none; }
        .results { margin-top: 16px; display: grid; gap: 12px; }
        .trip-card {
            display: grid;
            grid-template-columns: 120px 1fr 180px;
            gap: 16px;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 16px;
            background: #fff;
            box-shadow: 0 6px 18px rgba(0,0,0,0.04);
            align-items: center;
            transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
        }
        .trip-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.08);
            border-color: #cbd5e1;
        }
        .trip-thumb {
            width: 120px; height: 86px; border-radius: 12px; background: linear-gradient(135deg,#2563eb,#60a5fa);
            position: relative; overflow: hidden; display: grid; place-items: center; color: #fff; font-weight: 700;
        }
        .badge {
            display: inline-flex; align-items: center; gap: 6px;
            background: #ecfdf3; color: #0a8a3a; padding: 6px 10px; border-radius: 999px; font-weight: 700; font-size: 13px;
        }
        .trip-title { font-size: 18px; font-weight: 800; margin: 2px 0 6px; }
        .trip-meta { color: #4b5563; font-size: 14px; display: flex; gap: 10px; flex-wrap: wrap; }
        .dot { width: 6px; height: 6px; border-radius: 50%; background: #d1d5db; display: inline-block; }
        .pill { display: inline-flex; align-items: center; gap: 6px; padding: 6px 10px; background: #eef2ff; color: #4338ca; border-radius: 999px; font-weight: 600; font-size: 13px; }
        .price { text-align: right; }
        .price strong { font-size: 22px; color: #111827; }
        .sub { color: #6b7280; font-size: 13px; margin-top: 4px; }
        .actions { text-align: right; margin-top: 8px; }
        .btn-ghost { background: #fff; border: 1px solid #e5e7eb; color: #111827; }
        .empty { padding: 16px; color: #6c757d; }
        .route-block { margin-top: 8px; display: grid; gap: 8px; }
        .route-row { display: grid; grid-template-columns: 20px 1fr; gap: 10px; align-items: start; }
        .route-icon { color: #4b5563; font-size: 16px; line-height: 1; }
        .route-time { font-weight: 800; color: #1f2937; }
        .route-place { color: #374151; }
        .route-dots { height: 16px; border-left: 2px dashed #d1d5db; margin-left: 8px; }
        .duration { color: #6b7280; font-size: 13px; margin: 2px 0 0 0; }
        .btn.btn-primary {
            transition: transform 0.16s ease, box-shadow 0.16s ease, background-color 0.16s ease;
        }
        .btn.btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 16px rgba(37, 99, 235, 0.25);
            background-color: #1d4ed8;
        }
        .side-card { background:#fff; border-radius:14px; padding:14px 16px; box-shadow:0 8px 20px rgba(0,0,0,0.05); border:1px solid #e5e7eb; }
        .side-card h3 { margin:0 0 8px; font-size:18px; }
        .side-card h4 { margin:8px 0 4px; font-size:16px; }
        .filter-group { margin: 8px 0; padding: 8px 0; border-top:1px solid #e5e7eb; }
        .filter-group:first-of-type { border-top: none; }
        .filter-option { display:flex; align-items:center; gap:8px; margin:6px 0; color:#111827; font-size:14px; }
        .filter-option input { accent-color:#2563eb; }
        .hero {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.9), rgba(59, 130, 246, 0.75)), url('<%= ctx %>/carbook/images/bg_1.jpg');
            background-size: cover;
            background-position: center;
            border-radius: 18px;
            color: #fff;
            padding: 22px;
            margin-bottom: 16px;
            box-shadow: 0 18px 36px rgba(37, 99, 235, 0.25);
        }
        .hero h1 { margin: 0 0 6px; font-size: 24px; font-weight: 800; }
        .hero p { margin: 0; opacity: 0.92; }
        @media (max-width: 900px) {
            .layout { grid-template-columns: 1fr; }
            .trip-card { grid-template-columns: 1fr; }
            .price, .actions { text-align: left; }
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
    <div class="container">
        <a class="navbar-brand" href="<%= ctx %>/index.jsp">Car<span>Book</span></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="oi oi-menu"></span> Menu
        </button>

        <div class="collapse navbar-collapse" id="ftco-nav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item active"><a href="<%= ctx %>/index.jsp" class="nav-link">Trang chủ</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Giới thiệu</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Dịch vụ</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Bảng giá</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Xe</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Blog</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Liên hệ</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="page">
    <div class="layout">
        <aside class="side-card">
            <h3>Sắp xếp</h3>
            <div class="filter-group">
                <label class="filter-option"><input type="radio" name="sort" checked> Mặc định</label>
                <label class="filter-option"><input type="radio" name="sort"> Giờ đi sớm nhất</label>
                <label class="filter-option"><input type="radio" name="sort"> Giờ đi muộn nhất</label>
                <label class="filter-option"><input type="radio" name="sort"> Giá tăng dần</label>
                <label class="filter-option"><input type="radio" name="sort"> Giá giảm dần</label>
            </div>
            <h4>Lọc</h4>
            <div class="filter-group">
                <strong class="muted" style="display:block;margin-bottom:6px;">Giờ đi</strong>
                <label class="filter-option"><input type="checkbox"> Sáng (05:00 - 11:00)</label>
                <label class="filter-option"><input type="checkbox"> Chiều (11:00 - 17:00)</label>
                <label class="filter-option"><input type="checkbox"> Tối (17:00 - 24:00)</label>
            </div>
            <div class="filter-group">
                <strong class="muted" style="display:block;margin-bottom:6px;">Nhà xe</strong>
                <label class="filter-option"><input type="checkbox"> Limousine</label>
                <label class="filter-option"><input type="checkbox"> Giường nằm</label>
            </div>
            <div class="filter-group">
                <strong class="muted" style="display:block;margin-bottom:6px;">Giá vé</strong>
                <label class="filter-option"><input type="checkbox"> Dưới 300k</label>
                <label class="filter-option"><input type="checkbox"> 300k - 500k</label>
                <label class="filter-option"><input type="checkbox"> Trên 500k</label>
            </div>
        </aside>

        <div>
            <div class="hero">
                <h1>Đặt vé nhanh – Giá rõ ràng</h1>
                <p>Chọn điểm đi/đến, xem giá và chỗ trống tức thì. Hỗ trợ 24/7.</p>
            </div>
            <div class="card">
                <h2 style="margin-bottom:12px;">Tìm kiếm chuyến xe</h2>
                <form method="get" action="<%= ctx %>/search-trips">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="from">Điểm đi</label>
                            <input type="text" id="from" name="from" class="form-control" value="<%= from == null ? "" : from %>" placeholder="VD: Hà Nội">
                        </div>
                        <div class="form-group">
                            <label for="to">Điểm đến</label>
                            <input type="text" id="to" name="to" class="form-control" value="<%= to == null ? "" : to %>" placeholder="VD: Đà Nẵng">
                        </div>
                        <div class="form-group">
                            <label for="date">Ngày đi</label>
                            <input type="date" id="date" name="date" class="form-control" value="<%= date == null ? "" : date %>">
                        </div>
                    </div>
                    <div style="margin-top:12px;">
                        <button type="submit" class="btn btn-primary px-4">Tìm chuyến</button>
                        <a href="<%= ctx %>/index.jsp" class="btn btn-link">Trang chủ</a>
                    </div>
                </form>
                <% if (error != null) { %>
                    <div class="alert alert-danger" style="margin-top:12px;"><%= error %></div>
                <% } %>
            </div>

            <div class="card" style="margin-top:16px;">
                <h3 style="margin-bottom:12px;">Kết quả</h3>
                <% if (trips.isEmpty()) { %>
                    <div class="empty">Không có chuyến phù hợp hoặc bạn chưa nhập tiêu chí tìm kiếm.</div>
                <% } else { %>
                    <div class="results">
                    <% for (Trip t : trips) {
                           String routeName = t.getRouteName() == null ? "Chuyến #" + t.getId() : t.getRouteName();
                           String bus = t.getBusLicensePlate() == null ? ("Xe #" + t.getBusId()) : t.getBusLicensePlate();
                    %>
                        <div class="trip-card">
                            <div class="trip-thumb">
                                <span>Xe</span>
                                <div style="position:absolute;top:8px;left:8px;" class="badge">Xác nhận tức thì</div>
                            </div>
                            <div>
                                <div class="trip-title"><%= routeName %></div>
                                <div class="trip-meta">
                                    <span><strong><%= t.getDepartureTime() != null ? t.getDepartureTime().format(dateTimeFmt) : "--" %></strong></span>
                                    <span class="dot"></span>
                                    <span><%= bus %></span>
                                </div>
                                <div class="route-block">
                                    <div class="route-row">
                                        <span class="route-icon">⦿</span>
                                        <div>
                                            <div class="route-time"><%= t.getDepartureTime() != null ? t.getDepartureTime().format(timeFmt) : "--:--" %></div>
                                            <div class="route-place"><%= t.getOrigin() == null ? "Điểm đi" : t.getOrigin() %></div>
                                            <div class="duration"><%
                                                if (t.getDepartureTime() != null) {
                                                    out.print(t.getDepartureTime().toLocalDate().format(dateFmt));
                                                }
                                            %></div>
                                        </div>
                                    </div>
                                    <div class="route-dots"></div>
                                    <div class="route-row">
                                        <span class="route-icon">⌂</span>
                                        <div>
                                            <div class="route-time muted"><%
                                                java.time.LocalDateTime arr = null;
                                                if (t.getDepartureTime() != null && t.getDistanceKm() > 0) {
                                                    long minutes = Math.round(t.getDistanceKm()); // 60 km/h => phút ≈ km
                                                    arr = t.getDepartureTime().plusMinutes(minutes);
                                                    out.print(arr.format(timeFmt));
                                                } else { out.print("--:--"); }
                                            %></div>
                                            <div class="route-place"><%= t.getDestination() == null ? "Điểm đến" : t.getDestination() %></div>
                                            <div class="duration"><%
                                                if (arr != null) {
                                                    out.print(arr.toLocalDate().format(dateFmt));
                                                }
                                            %></div>
                                            <div class="duration"><%
                                                if (t.getDistanceKm() > 0) {
                                                    long minutes = Math.round(t.getDistanceKm());
                                                    long h = minutes / 60;
                                                    long m = minutes % 60;
                                                    out.print(h + "h" + (m < 10 ? "0" + m : m));
                                                }
                                            %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <div class="price">
                                    <strong><%
                                        double price = t.getPrice();
                                        if (price > 0) {
                                            out.print(String.format("%,.0f đ", price));
                                        } else {
                                            out.print("Liên hệ");
                                        }
                                    %></strong>
                                    <div class="sub"><%
                                        int seats = t.getTotalSeats();
                                        if (seats > 0) {
                                            out.print("Còn " + seats + " chỗ");
                                        } else {
                                            out.print("Sức chứa đang cập nhật");
                                        }
                                    %></div>
                                </div>
                                <div class="actions" style="display:flex; flex-direction:column; gap:8px; align-items:flex-end;">
                                    <a class="btn btn-ghost" style="width:120px; text-align:center;" href="<%= ctx %>/trip-detail?id=<%= t.getId() %>">Xem chi tiết</a>
                                    <button class="btn btn-primary" style="width:120px;">Đặt xe</button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>

