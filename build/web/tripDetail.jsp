<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Trip" %>
<%
    Trip trip = (Trip) request.getAttribute("trip");
    String ctx = request.getContextPath();
    java.time.format.DateTimeFormatter dtFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết chuyến xe</title>
    <link rel="stylesheet" href="<%= ctx %>/carbook/css/style.css?v=1">
    <style>
        body { background:#f3f4f6; font-family:"Inter",Arial,sans-serif; }
        .container { max-width: 960px; margin: 24px auto; padding: 0 18px; }
        .card { background:#fff; border-radius:16px; padding:20px; box-shadow:0 10px 28px rgba(0,0,0,0.07); }
        .title { margin:0 0 10px; font-size:24px; font-weight:800; }
        .muted { color:#6b7280; }
        .grid { display:grid; grid-template-columns: repeat(auto-fit,minmax(240px,1fr)); gap:12px; margin-top:12px; }
        .item { padding:12px; border:1px solid #e5e7eb; border-radius:12px; background:#fafafa; }
        .item label { display:block; font-weight:700; color:#374151; margin-bottom:4px; }
        .item span { color:#111827; }
        .actions { margin-top:16px; display:flex; gap:10px; }
        .btn { border:none; border-radius:10px; padding:10px 14px; font-weight:700; cursor:pointer; }
        .btn-primary { background:#2563eb; color:#fff; }
        .btn-ghost { background:#fff; border:1px solid #e5e7eb; color:#111827; }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <h1 class="title"><%= trip != null && trip.getRouteName() != null ? trip.getRouteName() : "Chuyến xe" %></h1>
        <div class="muted">Mã chuyến: <%= trip != null ? trip.getId() : "" %></div>
        <div class="grid">
            <div class="item">
                <label>Khởi hành</label>
                <span><%= trip != null && trip.getDepartureTime()!=null ? trip.getDepartureTime().format(dtFmt) : "--" %></span>
            </div>
            <div class="item">
                <label>Điểm đi</label>
                <span><%= trip != null ? trip.getOrigin() : "" %></span>
            </div>
            <div class="item">
                <label>Điểm đến</label>
                <span><%= trip != null ? trip.getDestination() : "" %></span>
            </div>
            <div class="item">
                <label>Quãng đường</label>
                <span><%= trip != null ? trip.getDistanceKm() + " km" : "" %></span>
            </div>
            <div class="item">
                <label>Giá vé</label>
                <span><%= trip != null && trip.getPrice()>0 ? String.format("%,.0f đ", trip.getPrice()) : "Liên hệ" %></span>
            </div>
            <div class="item">
                <label>Biển số xe</label>
                <span><%= trip != null ? trip.getBusLicensePlate() : "" %></span>
            </div>
            <div class="item">
                <label>Số chỗ</label>
                <span><%= trip != null && trip.getTotalSeats()>0 ? trip.getTotalSeats() : 0 %></span>
            </div>
        </div>
        <div class="actions">
            <a class="btn btn-ghost" href="<%= ctx %>/search-trips">Quay lại</a>
            <button class="btn btn-primary">Đặt xe</button>
        </div>
    </div>
</div>
</body>
</html>

