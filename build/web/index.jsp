<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
    String assets = ctx + "/carbook";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Carbook - Giao diện thuê xe</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= assets %>/css/open-iconic-bootstrap.min.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/animate.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/owl.carousel.min.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/owl.theme.default.min.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/magnific-popup.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/aos.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/ionicons.min.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/bootstrap-datepicker.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/jquery.timepicker.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/flaticon.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/icomoon.css?v=1">
    <link rel="stylesheet" href="<%= assets %>/css/style.css?v=1">
    <style>
        /* Loại bỏ margin âm mặc định để form không chồng lên nội dung phía dưới */
        .featured-top {
            margin-top: 0 !important;
        }
        /* Bố cục form nổi như template */
        .booking-section {
            /* kéo cao đè lên ảnh, dùng top thay vì margin để không đẩy nội dung dưới */
            position: relative;
            top: clamp(-160px, -22vw, -420px);
            z-index: 3;
            padding-top: 0;
            padding-bottom: 20px;
            margin-top: 0;
        }

        /* Giữ navbar nổi trên cùng khi block tràn lên */
        .ftco_navbar {
            z-index: 1050;
        }
        .booking-row {
            align-items: flex-start;
            gap: 20px;
            flex-wrap: nowrap;
        }
        .booking-form-col {
            flex: 0 0 45%;
            max-width: 45%;
            min-width: 420px;
        }
        .request-form {
            width: 100%;
            box-shadow: 0 18px 38px rgba(0, 0, 0, 0.12);
        }
        .booking-info-col {
            flex: 1 1 55%;
            min-width: 0;
        }
        .booking-info-col .card {
            height: 100%;
        }
        /* Hiển thị dropdown rõ trên nền xanh */
        .request-form select.form-control {
            background: #fff;
            color: #1a202c;
            border: 1px solid #dee2e6;
        }
        .request-form select.form-control:focus {
            box-shadow: 0 0 0 0.15rem rgba(12, 98, 240, 0.25);
            border-color: #0c62f0;
        }
        .request-form select.form-control option {
            color: #1a202c;
            background: #fff;
        }
        @media (max-width: 992px) {
            .booking-section {
                margin-top: -60px;
                padding-top: 20px;
            }
            .booking-row {
                gap: 12px;
                flex-wrap: wrap;
            }
            .booking-form-col,
            .booking-info-col {
                flex: 1 1 100%;
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
        <div class="container">
            <a class="navbar-brand" href="#">Car<span>Book</span></a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="oi oi-menu"></span> Menu
            </button>

            <div class="collapse navbar-collapse" id="ftco-nav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item active"><a href="#" class="nav-link">Trang chủ</a></li>
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

    <div class="hero-wrap ftco-degree-bg" style="background-image: url('<%= assets %>/images/bg_1.jpg');" data-stellar-background-ratio="0.5">
        <div class="overlay"></div>
        <div class="container">
            <div class="row no-gutters slider-text justify-content-start align-items-center justify-content-center">
                <div class="col-lg-8 ftco-animate">
                    <div class="text w-100 text-center mb-md-5 pb-md-5">
                        <h1 class="mb-4">Thuê xe nhanh, giá minh bạch</h1>
                        <p style="font-size: 18px;">Đặt xe trong vài bước, hỗ trợ 24/7, theo dõi hành trình và chi phí rõ ràng.</p>
                        <div style="margin-top:12px; font-weight:600; color:#fff;">
                            Giá rõ ràng • Hủy miễn phí linh hoạt • Hỗ trợ toàn quốc
                        </div>
                        <a href="https://vimeo.com/45830194" class="icon-wrap popup-vimeo d-flex align-items-center mt-4 justify-content-center">
                            <div class="icon d-flex align-items-center justify-content-center">
                                <span class="ion-ios-play"></span>
                            </div>
                            <div class="heading-title ml-5">
                                <span>Các bước thuê xe đơn giản</span>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <section class="ftco-section ftco-no-pt bg-light">
        <div class="container">
            <div class="row no-gutters">
                <div class="col-md-12 featured-top booking-section">
                    <div class="row no-gutters booking-row">
                        <div class="col-md-4 d-flex align-items-center booking-form-col">
                            <form action="<%= ctx %>/search-trips" method="get" class="request-form ftco-animate bg-primary">
                                <h2>Lên chuyến đi</h2>
                                <div class="form-group">
                                    <label class="label">Điểm đón</label>
                                    <select class="form-control" name="from" id="searchFrom">
                                        <option value="">Chọn tỉnh/thành</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="label">Điểm trả</label>
                                    <select class="form-control" name="to" id="searchTo">
                                        <option value="">Chọn tỉnh/thành</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="label">Ngày đi (không bắt buộc)</label>
                                    <input type="date" class="form-control" id="book_pick_date" name="date" autocomplete="off">
                                </div>
                                <div class="form-group">
                                    <input type="submit" value="Tìm chuyến xe" class="btn btn-secondary py-3 px-4">
                                </div>
                            </form>
                        </div>
                        <div class="col-md-8 d-flex align-items-center booking-info-col">
                            <div class="card w-100 shadow-sm border-0 p-4" style="border-radius:16px;">
                                <h3 class="heading-section mb-4">Giải pháp thuê xe hoàn hảo</h3>
                                <div class="row text-center mb-3">
                                    <div class="col-md-4 d-flex flex-column align-items-center mb-3">
                                        <div class="icon d-flex align-items-center justify-content-center mb-2" style="width:72px;height:72px;border-radius:50%;background:#eef2ff;">
                                            <span class="flaticon-route" style="font-size:28px;color:#2d5bff;"></span>
                                        </div>
                                        <h5 class="mb-1">Chọn điểm đón</h5>
                                        <p class="text-muted mb-0">Xác định vị trí đón/trả rõ ràng.</p>
                                    </div>
                                    <div class="col-md-4 d-flex flex-column align-items-center mb-3">
                                        <div class="icon d-flex align-items-center justify-content-center mb-2" style="width:72px;height:72px;border-radius:50%;background:#eef2ff;">
                                            <span class="flaticon-handshake" style="font-size:28px;color:#2d5bff;"></span>
                                        </div>
                                        <h5 class="mb-1">Chọn gói phù hợp</h5>
                                        <p class="text-muted mb-0">So sánh giá, loại xe, khuyến mãi.</p>
                                    </div>
                                    <div class="col-md-4 d-flex flex-column align-items-center mb-3">
                                        <div class="icon d-flex align-items-center justify-content-center mb-2" style="width:72px;height:72px;border-radius:50%;background:#eef2ff;">
                                            <span class="flaticon-rent" style="font-size:28px;color:#2d5bff;"></span>
                                        </div>
                                        <h5 class="mb-1">Giữ chỗ xe ngay</h5>
                                        <p class="text-muted mb-0">Xác nhận nhanh, hỗ trợ đổi lịch.</p>
                                    </div>
                                </div>
                                <div class="text-center">
                                    <a href="#" class="btn btn-primary py-3 px-5">Giữ chỗ ngay</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="ftco-section ftco-no-pt bg-light">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-12 heading-section text-center ftco-animate mb-5">
                    <span class="subheading">Chúng tôi cung cấp</span>
                    <h2 class="mb-2">Xe nổi bật</h2>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="carousel-car owl-carousel">
                        <div class="item">
                            <div class="car-wrap rounded ftco-animate">
                                <div class="img rounded d-flex align-items-end" style="background-image: url('<%= assets %>/images/car-1.jpg');"></div>
                                <div class="text">
                                    <h2 class="mb-0"><a href="#">Mercedes Grand Sedan</a></h2>
                                    <div class="d-flex mb-3">
                                        <span class="cat">Cheverolet</span>
                                        <p class="price ml-auto">$500 <span>/day</span></p>
                                    </div>
                                    <p class="d-flex mb-0 d-block"><a href="#" class="btn btn-primary py-2 mr-1">Book now</a> <a href="#" class="btn btn-secondary py-2 ml-1">Details</a></p>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <div class="car-wrap rounded ftco-animate">
                                <div class="img rounded d-flex align-items-end" style="background-image: url('<%= assets %>/images/car-2.jpg');"></div>
                                <div class="text">
                                    <h2 class="mb-0"><a href="#">Mercedes Grand Sedan</a></h2>
                                    <div class="d-flex mb-3">
                                        <span class="cat">Cheverolet</span>
                                        <p class="price ml-auto">$500 <span>/day</span></p>
                                    </div>
                                    <p class="d-flex mb-0 d-block"><a href="#" class="btn btn-primary py-2 mr-1">Book now</a> <a href="#" class="btn btn-secondary py-2 ml-1">Details</a></p>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <div class="car-wrap rounded ftco-animate">
                                <div class="img rounded d-flex align-items-end" style="background-image: url('<%= assets %>/images/car-3.jpg');"></div>
                                <div class="text">
                                    <h2 class="mb-0"><a href="#">Mercedes Grand Sedan</a></h2>
                                    <div class="d-flex mb-3">
                                        <span class="cat">Cheverolet</span>
                                        <p class="price ml-auto">$500 <span>/day</span></p>
                                    </div>
                                    <p class="d-flex mb-0 d-block"><a href="#" class="btn btn-primary py-2 mr-1">Book now</a> <a href="#" class="btn btn-secondary py-2 ml-1">Details</a></p>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <div class="car-wrap rounded ftco-animate">
                                <div class="img rounded d-flex align-items-end" style="background-image: url('<%= assets %>/images/car-4.jpg');"></div>
                                <div class="text">
                                    <h2 class="mb-0"><a href="#">Mercedes Grand Sedan</a></h2>
                                    <div class="d-flex mb-3">
                                        <span class="cat">Cheverolet</span>
                                        <p class="price ml-auto">$500 <span>/day</span></p>
                                    </div>
                                    <p class="d-flex mb-0 d-block"><a href="#" class="btn btn-primary py-2 mr-1">Book now</a> <a href="#" class="btn btn-secondary py-2 ml-1">Details</a></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="ftco-section ftco-about">
        <div class="container">
            <div class="row no-gutters">
                <div class="col-md-6 p-md-5 img img-2 d-flex justify-content-center align-items-center" style="background-image: url('<%= assets %>/images/about.jpg');"></div>
                <div class="col-md-6 wrap-about ftco-animate">
                    <div class="heading-section heading-section-white pl-md-5">
                        <span class="subheading">Về chúng tôi</span>
                        <h2 class="mb-4">Chào mừng đến Carbook</h2>
                        <p>Giải pháp thuê xe linh hoạt cho mọi nhu cầu di chuyển: công tác, du lịch, đám cưới hay đón tiễn sân bay.</p>
                        <p>Đội ngũ hỗ trợ 24/7, xe được bảo dưỡng định kỳ, giá minh bạch, thủ tục nhanh chóng.</p>
                        <p><a href="#" class="btn btn-primary py-3 px-4">Tìm xe ngay</a></p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="ftco-section">
        <div class="container">
            <div class="row justify-content-center mb-5">
                <div class="col-md-7 text-center heading-section ftco-animate">
                    <span class="subheading">Dịch vụ</span>
                    <h2 class="mb-3">Dịch vụ nổi bật</h2>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <div class="services services-2 w-100 text-center">
                        <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-wedding-car"></span></div>
                        <div class="text w-100">
                            <h3 class="heading mb-2">Xe đám cưới</h3>
                            <p>Đưa đón ngày trọng đại với đội xe sang trọng, lái xe kinh nghiệm.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="services services-2 w-100 text-center">
                        <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-transportation"></span></div>
                        <div class="text w-100">
                            <h3 class="heading mb-2">Di chuyển nội đô</h3>
                            <p>Đi lại linh hoạt trong thành phố, đặt xe theo giờ hoặc theo chuyến.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="services services-2 w-100 text-center">
                        <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-car"></span></div>
                        <div class="text w-100">
                            <h3 class="heading mb-2">Đón/trả sân bay</h3>
                            <p>Theo dõi chuyến bay, đón đúng giờ, hỗ trợ hành lý.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="services services-2 w-100 text-center">
                        <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-transportation"></span></div>
                        <div class="text w-100">
                            <h3 class="heading mb-2">Tour tham quan</h3>
                            <p>Lịch trình linh hoạt, tài xế thông thạo điểm đến, tư vấn địa điểm đẹp.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="ftco-section ftco-intro" style="background-image: url('<%= assets %>/images/bg_3.jpg');">
        <div class="overlay"></div>
        <div class="container">
            <div class="row justify-content-end">
                <div class="col-md-6 heading-section heading-section-white ftco-animate">
                    <h2 class="mb-3">Muốn kiếm thêm cùng chúng tôi? Đừng bỏ lỡ.</h2>
                    <a href="#" class="btn btn-primary btn-lg">Trở thành tài xế</a>
                </div>
            </div>
        </div>
    </section>

    <section class="ftco-section testimony-section bg-light">
        <div class="container">
            <div class="row justify-content-center mb-5">
                <div class="col-md-7 text-center heading-section ftco-animate">
                    <span class="subheading">Khách hàng nói</span>
                    <h2 class="mb-3">Khách hàng hài lòng</h2>
                </div>
            </div>
            <div class="row ftco-animate">
                <div class="col-md-12">
                    <div class="carousel-testimony owl-carousel ftco-owl">
                        <div class="item">
                            <div class="testimony-wrap rounded text-center py-4 pb-5">
                                <div class="user-img mb-2" style="background-image: url('<%= assets %>/images/person_1.jpg');"></div>
                                <div class="text pt-4">
                                    <p class="mb-4">Dịch vụ tận tâm, xe sạch đẹp, đặt xe rất nhanh chóng.</p>
                                    <p class="name">Minh Anh</p>
                                    <span class="position">Trưởng phòng Marketing</span>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <div class="testimony-wrap rounded text-center py-4 pb-5">
                                <div class="user-img mb-2" style="background-image: url('<%= assets %>/images/person_2.jpg');"></div>
                                <div class="text pt-4">
                                    <p class="mb-4">Tài xế đúng giờ, hỗ trợ nhiệt tình, giá minh bạch.</p>
                                    <p class="name">Khánh Linh</p>
                                    <span class="position">Thiết kế giao diện</span>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <div class="testimony-wrap rounded text-center py-4 pb-5">
                                <div class="user-img mb-2" style="background-image: url('<%= assets %>/images/person_3.jpg');"></div>
                                <div class="text pt-4">
                                    <p class="mb-4">Rất hài lòng về chuyến đi, xe mới và lái xe chuyên nghiệp.</p>
                                    <p class="name">Quốc Huy</p>
                                    <span class="position">Thiết kế UI</span>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <div class="testimony-wrap rounded text-center py-4 pb-5">
                                <div class="user-img mb-2" style="background-image: url('<%= assets %>/images/person_1.jpg');"></div>
                                <div class="text pt-4">
                                    <p class="mb-4">Hỗ trợ 24/7, xử lý thay đổi lịch rất nhanh.</p>
                                    <p class="name">Bảo Ngọc</p>
                                    <span class="position">Lập trình viên</span>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <div class="testimony-wrap rounded text-center py-4 pb-5">
                                <div class="user-img mb-2" style="background-image: url('<%= assets %>/images/person_1.jpg');"></div>
                                <div class="text pt-4">
                                    <p class="mb-4">Đặt xe nhóm lớn vẫn dễ dàng, giá tốt.</p>
                                    <p class="name">Thuận Lợi</p>
                                    <span class="position">Phân tích hệ thống</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="ftco-section">
        <div class="container">
            <div class="row justify-content-center mb-5">
                <div class="col-md-7 heading-section text-center ftco-animate">
                    <span class="subheading">Blog</span>
                    <h2>Bài viết mới</h2>
                </div>
            </div>
            <div class="row d-flex">
                <div class="col-md-4 d-flex ftco-animate">
                    <div class="blog-entry justify-content-end">
                        <a href="#" class="block-20" style="background-image: url('<%= assets %>/images/image_1.jpg');"></a>
                        <div class="text pt-4">
                            <div class="meta mb-3">
                                <div><a href="#">Oct. 29, 2019</a></div>
                                <div><a href="#">Admin</a></div>
                                <div><a href="#" class="meta-chat"><span class="icon-chat"></span> 3</a></div>
                            </div>
                            <h3 class="heading mt-2"><a href="#">Vì sao tối ưu đặt xe giúp tăng trưởng</a></h3>
                            <p><a href="#" class="btn btn-primary">Đọc tiếp</a></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 d-flex ftco-animate">
                    <div class="blog-entry justify-content-end">
                        <a href="#" class="block-20" style="background-image: url('<%= assets %>/images/image_2.jpg');"></a>
                        <div class="text pt-4">
                            <div class="meta mb-3">
                                <div><a href="#">Oct. 29, 2019</a></div>
                                <div><a href="#">Admin</a></div>
                                <div><a href="#" class="meta-chat"><span class="icon-chat"></span> 3</a></div>
                            </div>
                            <h3 class="heading mt-2"><a href="#">Kinh nghiệm thuê xe công tác hiệu quả</a></h3>
                            <p><a href="#" class="btn btn-primary">Đọc tiếp</a></p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 d-flex ftco-animate">
                    <div class="blog-entry">
                        <a href="#" class="block-20" style="background-image: url('<%= assets %>/images/image_3.jpg');"></a>
                        <div class="text pt-4">
                            <div class="meta mb-3">
                                <div><a href="#">Oct. 29, 2019</a></div>
                                <div><a href="#">Admin</a></div>
                                <div><a href="#" class="meta-chat"><span class="icon-chat"></span> 3</a></div>
                            </div>
                            <h3 class="heading mt-2"><a href="#">Mẹo chọn xe cho chuyến du lịch dài ngày</a></h3>
                            <p><a href="#" class="btn btn-primary">Đọc tiếp</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="ftco-counter ftco-section img bg-light" id="section-counter">
        <div class="overlay"></div>
        <div class="container">
            <div class="row">
                <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                    <div class="block-18">
                        <div class="text text-border d-flex align-items-center">
                            <strong class="number" data-number="60">0</strong>
                            <span>Năm <br>Kinh nghiệm</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                    <div class="block-18">
                        <div class="text text-border d-flex align-items-center">
                            <strong class="number" data-number="1090">0</strong>
                            <span>Tổng số <br>Xe</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                    <div class="block-18">
                        <div class="text text-border d-flex align-items-center">
                            <strong class="number" data-number="2590">0</strong>
                            <span>Khách hàng <br>Hài lòng</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                    <div class="block-18">
                        <div class="text d-flex align-items-center">
                            <strong class="number" data-number="67">0</strong>
                            <span>Tổng số <br>Chi nhánh</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="ftco-footer ftco-bg-dark ftco-section">
        <div class="container">
            <div class="row mb-5">
                <div class="col-md">
                    <div class="ftco-footer-widget mb-4">
                        <h2 class="ftco-heading-2"><a href="#" class="logo">Car<span>book</span></a></h2>
                        <p>Dịch vụ thuê xe linh hoạt, hỗ trợ 24/7, giá minh bạch và xe luôn sẵn sàng.</p>
                        <ul class="ftco-footer-social list-unstyled float-md-left float-lft mt-5">
                            <li class="ftco-animate"><a href="#"><span class="icon-twitter"></span></a></li>
                            <li class="ftco-animate"><a href="#"><span class="icon-facebook"></span></a></li>
                            <li class="ftco-animate"><a href="#"><span class="icon-instagram"></span></a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md">
                    <div class="ftco-footer-widget mb-4 ml-md-5">
                        <h2 class="ftco-heading-2">Thông tin</h2>
                        <ul class="list-unstyled">
                            <li><a href="#" class="py-2 d-block">Giới thiệu</a></li>
                            <li><a href="#" class="py-2 d-block">Dịch vụ</a></li>
                            <li><a href="#" class="py-2 d-block">Điều khoản</a></li>
                            <li><a href="#" class="py-2 d-block">Cam kết giá tốt</a></li>
                            <li><a href="#" class="py-2 d-block">Chính sách bảo mật</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md">
                    <div class="ftco-footer-widget mb-4">
                        <h2 class="ftco-heading-2">Hỗ trợ khách hàng</h2>
                        <ul class="list-unstyled">
                            <li><a href="#" class="py-2 d-block">Câu hỏi thường gặp</a></li>
                            <li><a href="#" class="py-2 d-block">Phương thức thanh toán</a></li>
                            <li><a href="#" class="py-2 d-block">Mẹo đặt xe</a></li>
                            <li><a href="#" class="py-2 d-block">Cách hoạt động</a></li>
                            <li><a href="#" class="py-2 d-block">Liên hệ</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md">
                    <div class="ftco-footer-widget mb-4">
                        <h2 class="ftco-heading-2">Bạn cần hỗ trợ?</h2>
                        <div class="block-23 mb-3">
                            <ul>
                                <li><span class="icon icon-map-marker"></span><span class="text">203 Fake St. Mountain View, San Francisco, California, USA</span></li>
                                <li><a href="#"><span class="icon icon-phone"></span><span class="text">+2 392 3929 210</span></a></li>
                                <li><a href="#"><span class="icon icon-envelope"></span><span class="text">info@yourdomain.com</span></a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 text-center">
                    <p>Copyright &copy;<script>document.write(new Date().getFullYear());</script>
                        All rights reserved | Template by <a href="https://colorlib.com/" target="_blank">Colorlib</a></p>
                </div>
            </div>
        </div>
    </footer>

    <div id="ftco-loader" class="show fullscreen">
        <svg class="circular" width="48px" height="48px">
            <circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/>
            <circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/>
        </svg>
    </div>

    <script src="<%= assets %>/js/jquery.min.js?v=1"></script>
    <script src="<%= assets %>/js/jquery-migrate-3.0.1.min.js?v=1"></script>
    <script src="<%= assets %>/js/popper.min.js?v=1"></script>
    <script src="<%= assets %>/js/bootstrap.min.js?v=1"></script>
    <script src="<%= assets %>/js/jquery.easing.1.3.js?v=1"></script>
    <script src="<%= assets %>/js/jquery.waypoints.min.js?v=1"></script>
    <script src="<%= assets %>/js/jquery.stellar.min.js?v=1"></script>
    <script src="<%= assets %>/js/owl.carousel.min.js?v=1"></script>
    <script src="<%= assets %>/js/jquery.magnific-popup.min.js?v=1"></script>
    <script src="<%= assets %>/js/aos.js?v=1"></script>
    <script src="<%= assets %>/js/jquery.animateNumber.min.js?v=1"></script>
    <script src="<%= assets %>/js/bootstrap-datepicker.js?v=1"></script>
    <script src="<%= assets %>/js/jquery.timepicker.min.js?v=1"></script>
    <script src="<%= assets %>/js/scrollax.min.js?v=1"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
    <script src="<%= assets %>/js/google-map.js"></script>
    <script src="<%= assets %>/js/main.js"></script>
    <script>
        // Tắt datepicker/timepicker của template để dùng picker native (datetime-local)
        (function ($) {
            $(function () {
                if ($.fn.datepicker) {
                    $('#book_pick_date,#book_off_date').datepicker('destroy');
                }
                if ($.fn.timepicker) {
                    $('#time_pick').timepicker('remove');
                }
            });
        })(jQuery);
    </script>
    <script>
        (function() {
            const fromSelect = document.getElementById('searchFrom');
            const toSelect = document.getElementById('searchTo');
            const provinceFallback = [
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
            ];

            function fillSelect(sel, provinces) {
                if (!sel) return;
                const current = sel.value;
                sel.innerHTML = '<option value="">Chọn tỉnh/thành</option>';
                provinces.forEach(function(p) {
                    const opt = document.createElement('option');
                    opt.value = p;
                    opt.textContent = p;
                    sel.appendChild(opt);
                });
                if (current && provinces.includes(current)) sel.value = current;
            }

            function populate(provinces) {
                fillSelect(fromSelect, provinces);
                fillSelect(toSelect, provinces);
            }

            fetch('/doAnTu/tinhthanh.json')
                .then(function(res){ return res.json(); })
                .then(function(data){
                    const provs = (data && data.VietnamProvinces)
                        ? data.VietnamProvinces.map(function(p){ return p.province; })
                        : provinceFallback;
                    populate(provs);
                })
                .catch(function(){
                    populate(provinceFallback);
                });
        })();
    </script>
</body>
</html>
