<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hidro Bus - Trang quản trị</title>
    <style>
        :root {
            --sidebar: #0b1f3a;
            --sidebar-light: #122642;
            --primary: #0c62f0;
            --accent: #ffb300;
            --danger: #e74c3c;
            --text: #1f2937;
            --muted: #6b7280;
            --border: #e2e8f0;
            --surface: #ffffff;
            --bg: #f5f6fa;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: "Inter", Arial, sans-serif;
            background: var(--bg);
            color: var(--text);
        }
        a { text-decoration: none; color: inherit; }
        .layout {
            display: grid;
            grid-template-columns: 260px 1fr;
            min-height: 100vh;
        }
        .sidebar {
            background: var(--sidebar);
            color: #e5e7eb;
            padding: 24px 18px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .brand-logo {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: linear-gradient(135deg, #0c62f0, #4cc9f0);
            display: grid;
            place-items: center;
            color: #fff;
            font-size: 16px;
            font-weight: 800;
        }
        .brand-text { font-size: 20px; font-weight: 700; }
        .menu { display: flex; flex-direction: column; gap: 10px; }
        .menu a {
            padding: 12px 14px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #cbd5e1;
            transition: 0.2s;
        }
        .menu a.active, .menu a:hover {
            background: var(--sidebar-light);
            color: #fff;
        }
        .content {
            padding: 24px 32px 48px;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }
        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            margin-bottom: 16px;
        }
        .search {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 10px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 10px 12px;
        }
        .search input {
            border: none;
            outline: none;
            width: 100%;
            font-size: 14px;
        }
        .user {
            display: flex;
            align-items: center;
            gap: 10px;
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 10px 12px;
            border-radius: 12px;
        }
        .avatar {
            width: 36px; height: 36px; border-radius: 50%;
            background: #e5e7eb; color: var(--text);
            display: grid; place-items: center; font-weight: 700;
        }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 18px;
            margin-bottom: 22px;
        }
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
        }
        .card .label { color: var(--muted); font-size: 13px; }
        .card .value { font-size: 24px; font-weight: 700; margin-top: 6px; }
        .grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 12px;
            margin-top: 14px;
        }
        .chart-box, .list-box { min-height: 320px; }
        .chart-placeholder, .list-placeholder {
            height: 240px;
            border-radius: 12px;
            border: 1px dashed #d1d5db;
            background: #f8fafc;
            padding: 16px;
            color: var(--muted);
        }
        .stat-list { display: grid; gap: 10px; }
        .stat-item { display: flex; align-items: center; justify-content: space-between; gap: 10px; }
        .pill {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 999px;
            font-size: 12px;
            color: #fff;
        }
        .pill.success { background: #22c55e; }
        .pill.warning { background: #f59e0b; }
        .pill.info { background: #0ea5e9; }
        .pill.danger { background: #ef4444; }
        .bar {
            flex: 1;
            height: 8px;
            border-radius: 999px;
            background: #e5e7eb;
            overflow: hidden;
            margin: 0 10px;
        }
        .bar > span { display: block; height: 100%; background: var(--primary); }
        .mini-table { width: 100%; border-collapse: collapse; }
        .mini-table th, .mini-table td { padding: 8px 6px; font-size: 13px; text-align: left; border-bottom: 1px solid var(--border); }
        .mini-table th { color: var(--muted); font-weight: 600; }
        .tag { padding: 4px 6px; border-radius: 8px; background: #e0f2fe; color: #0ea5e9; font-size: 12px; font-weight: 700; }
        .section-title { margin: 0 0 10px; font-size: 16px; font-weight: 700; }
        .products {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 12px;
            margin-top: 14px;
        }
        .product-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 12px;
            display: grid;
            gap: 6px;
        }
        .product-card .name { font-weight: 700; }
        .product-card .muted { color: var(--muted); font-size: 13px; }
        @media (max-width: 1100px) {
            .layout { grid-template-columns: 70px 1fr; }
            .brand-text, .menu a span { display: none; }
            .sidebar { align-items: center; }
            .menu a { justify-content: center; }
        }
        @media (max-width: 900px) {
            .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-logo">HX</div>
            <div class="brand-text">Hidro Bus</div>
        </div>
        <nav class="menu">
            <a class="active" href="/doAnTu/admin"><span>Trang quản trị</span></a>
            <a href="/doAnTu/admin/tuyen-xe"><span>Tuyến xe</span></a>
            <a href="/doAnTu/admin/chuyen-xe"><span>Chuyến xe</span></a>
            <a href="/doAnTu/admin/xe-va-ghe"><span>Xe và ghế</span></a>
            <a href="#"><span>Vé đã đặt</span></a>
            <a href="#"><span>Khách hàng</span></a>
            <a href="#"><span>Nhà xe</span></a>
            <a href="#"><span>Phản hồi</span></a>
            <a href="#"><span>Quản trị viên</span></a>
        </nav>
    </aside>
    <main class="content">
        <div class="topbar">
            <div class="search">
                <span>🔍</span>
                <input type="text" placeholder="Search...">
            </div>
            <div class="user">
                <div class="avatar">AD</div>
                <div>
                    <div style="font-weight:700;">Admin</div>
                    <div style="font-size:12px; color:var(--muted);">Log out • Settings</div>
                </div>
            </div>
        </div>

        <div class="cards">
            <div class="card">
                <div class="label">Tổng tuyến</div>
                <div class="value">028</div>
            </div>
            <div class="card">
                <div class="label">Tổng chuyến</div>
                <div class="value">136</div>
            </div>
            <div class="card">
                <div class="label">Vé đã đặt</div>
                <div class="value">842</div>
            </div>
            <div class="card">
                <div class="label">Chuyến sắp khởi hành</div>
                <div class="value">12</div>
            </div>
            <div class="card">
                <div class="label">Hủy / Hoãn</div>
                <div class="value">3</div>
            </div>
        </div>

        <div class="grid">
            <div class="card chart-box">
                <div class="section-title">Lượt đặt vé tuần này</div>
                <div class="chart-placeholder">
                    <div class="stat-list">
                        <div class="stat-item">
                            <span>Thứ 2</span>
                            <div class="bar"><span style="width: 60%; background:#0ea5e9;"></span></div>
                            <strong>120</strong>
                        </div>
                        <div class="stat-item">
                            <span>Thứ 3</span>
                            <div class="bar"><span style="width: 80%; background:#22c55e;"></span></div>
                            <strong>158</strong>
                        </div>
                        <div class="stat-item">
                            <span>Thứ 4</span>
                            <div class="bar"><span style="width: 70%; background:#f59e0b;"></span></div>
                            <strong>140</strong>
                        </div>
                        <div class="stat-item">
                            <span>Thứ 5</span>
                            <div class="bar"><span style="width: 90%; background:#0c62f0;"></span></div>
                            <strong>182</strong>
                        </div>
                        <div class="stat-item">
                            <span>Thứ 6</span>
                            <div class="bar"><span style="width: 100%; background:#ef4444;"></span></div>
                            <strong>205</strong>
                        </div>
                        <div class="stat-item">
                            <span>Thứ 7</span>
                            <div class="bar"><span style="width: 85%; background:#0ea5e9;"></span></div>
                            <strong>176</strong>
                        </div>
                        <div class="stat-item">
                            <span>CN</span>
                            <div class="bar"><span style="width: 55%; background:#22c55e;"></span></div>
                            <strong>112</strong>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card list-box">
                <div class="section-title">Tỉ lệ trạng thái vé</div>
                <div class="chart-placeholder">
                    <div class="stat-list">
                        <div class="stat-item">
                            <span>Đã thanh toán</span>
                            <div class="bar"><span style="width: 74%; background:#22c55e;"></span></div>
                            <strong>74%</strong>
                        </div>
                        <div class="stat-item">
                            <span>Chờ thanh toán</span>
                            <div class="bar"><span style="width: 18%; background:#f59e0b;"></span></div>
                            <strong>18%</strong>
                        </div>
                        <div class="stat-item">
                            <span>Hủy/Hoãn</span>
                            <div class="bar"><span style="width: 8%; background:#ef4444;"></span></div>
                            <strong>8%</strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="grid" style="margin-top: 14px;">
            <div class="card list-box">
                <div class="section-title">Lịch khởi hành hôm nay</div>
                <div class="list-placeholder">
                    <table class="mini-table">
                        <tr>
                            <th>Tuyến</th>
                            <th>Giờ đi</th>
                            <th>Xe</th>
                            <th>SL ghế</th>
                            <th>Trạng thái</th>
                        </tr>
                        <tr>
                            <td>Sài Gòn - Đà Lạt</td>
                            <td>08:00</td>
                            <td>HX-18</td>
                            <td>34/40</td>
                            <td><span class="tag">Boarding</span></td>
                        </tr>
                        <tr>
                            <td>Hà Nội - Hải Phòng</td>
                            <td>09:15</td>
                            <td>HX-05</td>
                            <td>28/34</td>
                            <td><span class="tag" style="background:#dcfce7;color:#16a34a;">On time</span></td>
                        </tr>
                        <tr>
                            <td>Đà Nẵng - Huế</td>
                            <td>10:30</td>
                            <td>HX-22</td>
                            <td>31/36</td>
                            <td><span class="tag" style="background:#fef9c3;color:#d97706;">Delayed 10’</span></td>
                        </tr>
                        <tr>
                            <td>Cần Thơ - Sài Gòn</td>
                            <td>11:45</td>
                            <td>HX-11</td>
                            <td>26/40</td>
                            <td><span class="tag" style="background:#fee2e2;color:#b91c1c;">Await check</span></td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="card list-box">
                <div class="section-title">Trạng thái bến / bãi</div>
                <div class="list-placeholder">
                    <div class="stat-list">
                        <div class="stat-item">
                            <span>Bến Miền Đông</span>
                            <div class="bar"><span style="width: 68%; background:#0ea5e9;"></span></div>
                            <span class="pill info">68% công suất</span>
                        </div>
                        <div class="stat-item">
                            <span>Bến Miền Tây</span>
                            <div class="bar"><span style="width: 55%; background:#22c55e;"></span></div>
                            <span class="pill success">55% công suất</span>
                        </div>
                        <div class="stat-item">
                            <span>BX Giáp Bát</span>
                            <div class="bar"><span style="width: 72%; background:#f59e0b;"></span></div>
                            <span class="pill warning">72% công suất</span>
                        </div>
                        <div class="stat-item">
                            <span>BX Đà Nẵng</span>
                            <div class="bar"><span style="width: 80%; background:#ef4444;"></span></div>
                            <span class="pill danger">80% công suất</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="products">
            <div class="product-card">
                <div class="muted">#1 • Tuyến</div>
                <div class="name">Sài Gòn - Đà Lạt</div>
                <div class="muted">Số vé tuần này: 120</div>
                <div class="value">Giá từ: 320,000 VND</div>
            </div>
            <div class="product-card">
                <div class="muted">#2 • Tuyến</div>
                <div class="name">Hà Nội - Hải Phòng</div>
                <div class="muted">Số vé tuần này: 84</div>
                <div class="value">Giá từ: 150,000 VND</div>
            </div>
            <div class="product-card">
                <div class="muted">#3 • Tuyến</div>
                <div class="name">Đà Nẵng - Huế</div>
                <div class="muted">Số vé tuần này: 65</div>
                <div class="value">Giá từ: 120,000 VND</div>
            </div>
            <div class="product-card">
                <div class="muted">#4 • Tuyến</div>
                <div class="name">Cần Thơ - Sài Gòn</div>
                <div class="muted">Số vé tuần này: 52</div>
                <div class="value">Giá từ: 180,000 VND</div>
            </div>
            <div class="product-card">
                <div class="muted">#5 • Tuyến</div>
                <div class="name">Nha Trang - Đà Lạt</div>
                <div class="muted">Số vé tuần này: 41</div>
                <div class="value">Giá từ: 190,000 VND</div>
            </div>
            <div class="product-card">
                <div class="muted">#6 • Tuyến</div>
                <div class="name">Huế - Quảng Bình</div>
                <div class="muted">Số vé tuần này: 33</div>
                <div class="value">Giá từ: 140,000 VND</div>
            </div>
        </div>
    </main>
</div>
</body>
</html>

