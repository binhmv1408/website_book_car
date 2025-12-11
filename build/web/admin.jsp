<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="model.Route" %>
<%
    List<Route> routes = (List<Route>) request.getAttribute("routes");
    int totalRoutes = routes != null ? routes.size() : 0;
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    String[] provinces = {
            "An Giang","Bà Rịa - Vũng Tàu","Bắc Giang","Bắc Kạn","Bạc Liêu","Bắc Ninh",
            "Bến Tre","Bình Định","Bình Dương","Bình Phước","Bình Thuận","Cà Mau",
            "Cần Thơ","Cao Bằng","Đà Nẵng","Đắk Lắk","Đắk Nông","Điện Biên","Đồng Nai",
            "Đồng Tháp","Gia Lai","Hà Giang","Hà Nam","Hà Nội","Hà Tĩnh","Hải Dương",
            "Hải Phòng","Hậu Giang","Hòa Bình","Hưng Yên","Khánh Hòa","Kiên Giang",
            "Kon Tum","Lai Châu","Lâm Đồng","Lạng Sơn","Lào Cai","Long An","Nam Định",
            "Nghệ An","Ninh Bình","Ninh Thuận","Phú Thọ","Phú Yên","Quảng Bình",
            "Quảng Nam","Quảng Ngãi","Quảng Ninh","Quảng Trị","Sóc Trăng","Sơn La",
            "Tây Ninh","Thái Bình","Thái Nguyên","Thanh Hóa","Thừa Thiên Huế",
            "Tiền Giang","TP. Hồ Chí Minh","Trà Vinh","Tuyên Quang","Vĩnh Long",
            "Vĩnh Phúc","Yên Bái"
    };
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý tuyến xe</title>
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
        .modal-overlay {
            position: fixed; inset: 0; background: rgba(0,0,0,0.4);
            display: none; align-items: center; justify-content: center; padding: 16px;
            z-index: 20;
        }
        .modal-overlay.show { display: flex; }
        .modal {
            background: var(--surface); border-radius: 14px; padding: 18px; width: min(640px, 95vw);
            box-shadow: 0 16px 50px rgba(0,0,0,0.18); border: 1px solid var(--border);
        }
        .modal-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
        .modal-close {
            background: none; border: none; font-size: 22px; cursor: pointer; color: #4a5568; padding: 6px;
        }
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
            <a class="active" href="/doAnTu/admin/tuyen-xe">Tuyến xe</a>
            <a href="/doAnTu/admin/chuyen-xe">Chuyến xe</a>
            <a href="/doAnTu/admin/xe-va-ghe">Xe và ghế</a>
            <a href="#">Vé đã đặt</a>
            <a href="#">Khách hàng</a>
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
                <div class="avatar">AD</div>
                <span>Admin</span>
            </div>
        </header>

        <section class="content">
            <h1 class="page-title">Quản lý tuyến xe</h1>

            <div class="cards">
                <div class="card">
                    <div class="card-label">Tổng tuyến xe</div>
                    <div class="card-value"><%= totalRoutes %></div>
                </div>
            </div>

        <div class="grid">
            <div class="card anchor-target" id="routes">
                <h2 class="section-title">Thêm tuyến xe</h2>
                <form id="addRouteForm" method="post" action="/doAnTu/admin/tuyen-xe">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="nameFromValue" id="nameFromValue">
                    <input type="hidden" name="nameToValue" id="nameToValue">
                    <div class="row">
                        <div style="flex:1">
                            <label>Tỉnh đi (đặt tên tuyến)</label>
                            <select id="nameFrom" required>
                                <% for (String p : provinces) { %>
                                    <option value="<%= p %>"><%= p %></option>
                                <% } %>
                            </select>
                        </div>
                        <div style="flex:1">
                            <label>Tỉnh đến (đặt tên tuyến)</label>
                            <select id="nameTo" required>
                                <% for (String p : provinces) { %>
                                    <option value="<%= p %>"><%= p %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    <input type="hidden" name="name" id="routeName" required>
                    <div class="row">
                        <div style="flex:1">
                            <label>Điểm đi (huyện/quận)</label>
                            <select name="origin" id="districtFrom" required>
                                <option value="">Chọn huyện/quận</option>
                            </select>
                        </div>
                        <div style="flex:1">
                            <label>Điểm đến (huyện/quận)</label>
                            <select name="destination" id="districtTo" required>
                                <option value="">Chọn huyện/quận</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div style="flex:1">
                            <label>Quãng đường (km)</label>
                            <input type="number" step="0.1" name="distanceKm" required>
                        </div>
                        <div style="flex:1">
                            <label>Giá vé</label>
                            <input type="number" step="0.01" name="price" required>
                        </div>
                    </div>
                    <button class="btn btn-primary" type="submit">Thêm tuyến</button>
                </form>
            </div>
        </div>

            <div class="grid">
                <div class="card">
                    <h2 class="section-title">Danh sách tuyến xe</h2>
                    <table>
                        <tr>
                            <th>ID</th>
                            <th>Tên tuyến</th>
                            <th>Điểm đi</th>
                            <th>Điểm đến</th>
                            <th>Km</th>
                            <th>Giá vé</th>
                            <th>Thao tác</th>
                        </tr>
                        <%
                            if (routes != null) {
                                for (Route r : routes) {
                        %>
                        <tr class="route-row" data-id="<%= r.getId() %>">
                            <td><%= r.getId() %></td>
                            <td><input class="route-input" type="text" name="name" value="<%= r.getName() %>" readonly></td>
                            <td><input class="route-input" type="text" name="origin" value="<%= r.getOrigin() %>" readonly></td>
                            <td><input class="route-input" type="text" name="destination" value="<%= r.getDestination() %>" readonly></td>
                            <td><input class="route-input" type="number" step="0.1" name="distanceKm" value="<%= r.getDistanceKm() %>" readonly></td>
                            <td><input class="route-input" type="number" step="0.01" name="price" value="<%= r.getPrice() %>" readonly></td>
                            <td class="actions">
                                <button
                                        class="btn btn-primary open-edit"
                                        type="button"
                                        data-id="<%= r.getId() %>"
                                        data-name="<%= r.getName() %>"
                                        data-origin="<%= r.getOrigin() %>"
                                        data-destination="<%= r.getDestination() %>"
                                        data-distance="<%= r.getDistanceKm() %>"
                                        data-price="<%= r.getPrice() %>">
                                    Sửa
                                </button>
                                <form class="inline-form delete-form" method="post" action="/doAnTu/admin/tuyen-xe" onsubmit="return confirm('Xóa tuyến này?');">
                                    <input type="hidden" name="id" value="<%= r.getId() %>">
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
            <div id="editRouteOverlay" class="modal-overlay">
                <div class="modal">
                    <div class="modal-header">
                        <h3 style="margin:0">Chỉnh sửa tuyến xe</h3>
                        <button type="button" class="modal-close" id="editModalClose">&times;</button>
                    </div>
                    <form id="editRouteForm" method="post" action="/doAnTu/admin/tuyen-xe">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="editId">
                        <input type="hidden" name="name" id="editName">
                        <input type="hidden" name="nameFromValue" id="editNameFrom">
                        <input type="hidden" name="nameToValue" id="editNameTo">
                        <div class="row">
                            <div style="flex:1">
                                <label>Tỉnh đi (đặt tên tuyến)</label>
                                <select id="editFromProvince" required></select>
                            </div>
                            <div style="flex:1">
                                <label>Tỉnh đến (đặt tên tuyến)</label>
                                <select id="editToProvince" required></select>
                            </div>
                        </div>
                        <div class="row">
                            <div style="flex:1">
                                <label>Điểm đi (huyện/quận)</label>
                                <select name="origin" id="editFromDistrict" required></select>
                            </div>
                            <div style="flex:1">
                                <label>Điểm đến (huyện/quận)</label>
                                <select name="destination" id="editToDistrict" required></select>
                            </div>
                        </div>
                        <div class="row">
                            <div style="flex:1">
                                <label>Quãng đường (km)</label>
                                <input type="number" step="0.1" name="distanceKm" id="editDistance" required>
                            </div>
                            <div style="flex:1">
                                <label>Giá vé</label>
                                <input type="number" step="0.01" name="price" id="editPrice" required>
                            </div>
                        </div>
                        <div style="display:flex; justify-content:flex-end; gap:10px; margin-top: 4px;">
                            <button type="button" class="btn" id="editModalCancel">Hủy</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </section>
    </main>
</div>
<script>
    (function() {
        const addForm = document.getElementById('addRouteForm');
        const fromSelect = addForm ? addForm.querySelector('#nameFrom') : null;
        const toSelect = addForm ? addForm.querySelector('#nameTo') : null;
        const originInput = addForm ? addForm.querySelector('#districtFrom') : null;
        const destInput = addForm ? addForm.querySelector('#districtTo') : null;
        const nameInput = addForm ? addForm.querySelector('#routeName') : null;
        const fromHidden = addForm ? addForm.querySelector('#nameFromValue') : null;
        const toHidden = addForm ? addForm.querySelector('#nameToValue') : null;
        const editOverlay = document.getElementById('editRouteOverlay');
        const editForm = document.getElementById('editRouteForm');
        const editFromProvince = document.getElementById('editFromProvince');
        const editToProvince = document.getElementById('editToProvince');
        const editFromDistrict = document.getElementById('editFromDistrict');
        const editToDistrict = document.getElementById('editToDistrict');
        const editDistance = document.getElementById('editDistance');
        const editPrice = document.getElementById('editPrice');
        const editId = document.getElementById('editId');
        const editNameHidden = document.getElementById('editName');
        const editFromHidden = document.getElementById('editNameFrom');
        const editToHidden = document.getElementById('editNameTo');
        const closeBtn = document.getElementById('editModalClose');
        const cancelBtn = document.getElementById('editModalCancel');
        let provinceData = [];
        let provinceMap = {};

        function optionize(select, items, keepValue) {
            if (!select) return;
            const prev = keepValue !== undefined ? keepValue : select.value;
            select.innerHTML = '';
            items.forEach(function (pv) {
                const opt = document.createElement('option');
                opt.value = pv;
                opt.textContent = pv;
                select.appendChild(opt);
            });
            if (prev && items.includes(prev)) select.value = prev;
        }

        function populateProvinces() {
            if (!provinceData || provinceData.length === 0) return;
            const provNames = provinceData.map(function (p) { return p.province; });
            [fromSelect, toSelect, editFromProvince, editToProvince].forEach(function (sel) {
                optionize(sel, provNames);
            });
        }

        function setDistrictOptions(select, provinceName, selected) {
            if (!select) return;
            select.innerHTML = '<option value="">Chọn huyện/quận</option>';
            (provinceMap[provinceName] || []).forEach(function (d) {
                const opt = document.createElement('option');
                opt.value = d;
                opt.textContent = d;
                select.appendChild(opt);
            });
            if (selected && provinceMap[provinceName] && provinceMap[provinceName].includes(selected)) {
                select.value = selected;
            } else if (select.options.length > 1) {
                select.selectedIndex = 1;
            }
        }

        function getSelectValue(sel) {
            if (!sel || !sel.options || sel.options.length === 0) return '';
            let idx = sel.selectedIndex;
            if (idx < 0) idx = 0;
            const opt = sel.options[idx];
            const txt = opt && (opt.text || opt.value) ? (opt.text || opt.value).trim() : '';
            return txt;
        }

        // Luôn lấy giá trị tỉnh từ dropdown tỉnh, tránh bị ảnh hưởng bởi chọn huyện
        function getProvinceValue(sel) {
            return sel && typeof sel.value === 'string' ? sel.value.trim() : '';
        }

        function buildRouteName(fromVal, toVal) {
            return (fromVal && toVal) ? 'Tuyến ' + fromVal + ' - ' + toVal : '';
        }

        function syncAddForm() {
            const fromVal = getProvinceValue(fromSelect);
            const toVal = getProvinceValue(toSelect);
            if (fromHidden) fromHidden.value = fromVal;
            if (toHidden) toHidden.value = toVal;
            if (nameInput) nameInput.value = buildRouteName(fromVal, toVal);
            setDistrictOptions(originInput, fromVal, originInput ? originInput.value : '');
            setDistrictOptions(destInput, toVal, destInput ? destInput.value : '');
        }

        if (fromSelect) fromSelect.addEventListener('change', syncAddForm);
        if (toSelect) toSelect.addEventListener('change', syncAddForm);

        // đảm bảo tên tuyến luôn có giá trị trước khi submit
        if (addForm) {
            addForm.addEventListener('submit', function (e) {
                syncAddForm();
                const fromVal = getProvinceValue(fromSelect);
                const toVal = getProvinceValue(toSelect);
                if (!fromVal || !toVal) {
                    e.preventDefault();
                    alert('Vui lòng chọn tỉnh đi và tỉnh đến để tạo tên tuyến.');
                    return;
                }
                if (fromHidden) fromHidden.value = fromVal;
                if (toHidden) toHidden.value = toVal;
                if (nameInput) nameInput.value = buildRouteName(fromVal, toVal);
                if (!originInput || !originInput.value) {
                    e.preventDefault();
                    alert('Vui lòng chọn huyện/quận đi.');
                    return;
                }
                if (!destInput || !destInput.value) {
                    e.preventDefault();
                    alert('Vui lòng chọn huyện/quận đến.');
                    return;
                }
            });
        }

        function parseName(nameVal) {
            if (!nameVal || !nameVal.startsWith('Tuyến ')) return { from: '', to: '' };
            const parts = nameVal.replace('Tuyến ', '').split(' - ');
            return { from: (parts[0] || '').trim(), to: (parts[1] || '').trim() };
        }

        function findProvinceByDistrict(districtName) {
            if (!districtName) return '';
            let found = '';
            Object.keys(provinceMap).some(function (p) {
                if ((provinceMap[p] || []).includes(districtName)) {
                    found = p;
                    return true;
                }
                return false;
            });
            return found;
        }

        function syncEditHidden() {
            const fromVal = getProvinceValue(editFromProvince);
            const toVal = getProvinceValue(editToProvince);
            if (editNameHidden) editNameHidden.value = buildRouteName(fromVal, toVal);
            if (editFromHidden) editFromHidden.value = fromVal;
            if (editToHidden) editToHidden.value = toVal;
        }

        function openEditModal(route) {
            if (!editOverlay || !editForm) return;
            const parsed = parseName(route.name || '');
            const detectedFrom = findProvinceByDistrict(route.origin) || parsed.from || getSelectValue(editFromProvince);
            const detectedTo = findProvinceByDistrict(route.destination) || parsed.to || getSelectValue(editToProvince);
            if (editId) editId.value = route.id || '';
            optionize(editFromProvince, provinceData.map(function (p){return p.province;}), detectedFrom);
            optionize(editToProvince, provinceData.map(function (p){return p.province;}), detectedTo);
            setDistrictOptions(editFromDistrict, getSelectValue(editFromProvince), route.origin);
            setDistrictOptions(editToDistrict, getSelectValue(editToProvince), route.destination);
            if (editDistance) editDistance.value = route.distance || '';
            if (editPrice) editPrice.value = route.price || '';
            syncEditHidden();
            editOverlay.classList.add('show');
        }

        function closeEditModal() {
            if (editOverlay) editOverlay.classList.remove('show');
        }

        if (closeBtn) closeBtn.addEventListener('click', closeEditModal);
        if (cancelBtn) cancelBtn.addEventListener('click', closeEditModal);
        if (editOverlay) {
            editOverlay.addEventListener('click', function (e) {
                if (e.target === editOverlay) closeEditModal();
            });
        }

        [editFromProvince, editToProvince].forEach(function (sel) {
            if (!sel) return;
            sel.addEventListener('change', function (e) {
                if (e.target === editFromProvince) {
                    setDistrictOptions(editFromDistrict, getSelectValue(editFromProvince));
                } else {
                    setDistrictOptions(editToDistrict, getSelectValue(editToProvince));
                }
                syncEditHidden();
            });
        });

        [editFromDistrict, editToDistrict].forEach(function (sel) {
            if (!sel) return;
            sel.addEventListener('change', syncEditHidden);
        });

        if (editForm) {
            editForm.addEventListener('submit', function (e) {
                syncEditHidden();
                if (!editNameHidden.value) {
                    e.preventDefault();
                    alert('Vui lòng chọn tỉnh đi và tỉnh đến.');
                }
            });
        }

        // Load provinces/districts data
        fetch('/doAnTu/tinhthanh.json')
            .then(function (res) { return res.json(); })
            .then(function (data) {
                provinceData = (data && data.VietnamProvinces) ? data.VietnamProvinces : [];
                provinceData.forEach(function (p) {
                    provinceMap[p.province] = p.districts || [];
                });
                populateProvinces();
                syncAddForm();
                document.querySelectorAll('.open-edit').forEach(function (btn) {
                    btn.addEventListener('click', function () {
                        openEditModal({
                            id: btn.dataset.id,
                            name: btn.dataset.name,
                            origin: btn.dataset.origin,
                            destination: btn.dataset.destination,
                            distance: btn.dataset.distance,
                            price: btn.dataset.price
                        });
                    });
                });
            })
            .catch(function () {
                // fallback nếu load thất bại
                provinceMap = {};
                syncAddForm();
            });
    })();

        // Giữ nguyên submit đồng bộ cho xóa (làm việc trực tiếp với DB qua servlet)
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.delete-form').forEach(function (form) {
                form.addEventListener('submit', function () {
                    return confirm('Xóa tuyến này?');
                });
            });
        });
</script>
</body>
</html>
