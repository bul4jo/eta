<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE HTML>

<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, viewport-fit=cover" />
<title>Duo Mobile PWA Kit</title>
<link rel="stylesheet" type="text/css" href="/templates/styles/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/templates/fonts/bootstrap-icons.css">
<link rel="stylesheet" type="text/css" href="/templates/styles/style.css">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700;800&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="manifest" href="_manifest.json">
<meta id="theme-check" name="theme-color" content="#FFFFFF">
<link rel="apple-touch-icon" sizes="180x180" href="/templates/icons/icon-192x192.png">
 <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="/templates/scripts/bootstrap.min.js"></script>
<script src="/templates/scripts/custom.js"></script>

<script type="text/javascript">

</script>

</head>

<body class="theme-light">

<div id="preloader"><div class="spinner-border color-highlight" role="status"></div></div>



    <!-- Header -->
    <div class="header-bar header-fixed header-app header-bar-detached">
    <a data-back-button href="#"><i class="bi bi-caret-left-fill font-11 color-theme ps-2"></i></a>
    <a href="#" class="header-title color-theme font-13">Back to Components</a>
    <a data-bs-toggle="offcanvas" data-bs-target="#menu-color" href="#"><i class="bi bi-palette-fill font-13 color-highlight"></i></a>
    <a href="#" class="show-on-theme-light" data-toggle-theme><i class="bi bi-moon-fill font-13"></i></a>
    <a href="#" class="show-on-theme-dark" data-toggle-theme ><i class="bi bi-lightbulb-fill color-yellow-dark font-13"></i></a>
  </div>

  <!-- Footer Bar-->
    <div id="footer-bar" class="footer-bar footer-bar-detached">
       <a data-back-button href="#"><i class="bi bi-caret-left-fill font-11 color-theme ps-2"></i></a>
        <a href="/home.jsp"><i class="bi bi-house-fill font-16"></i><span>Home</span></a>
        <a href="#" data-bs-toggle="offcanvas" data-bs-target="#menu-main"><i class="bi bi-list"></i><span>Menu</span></a>
    </div>

  <!-- Main Sidebar-->
  <div id="menu-main" data-menu-active="nav-comps" data-menu-load="menu-main.html"
    style="width:280px;" class="offcanvas offcanvas-start offcanvas-detached rounded-m">
  </div>
  <!-- Menu Highlights-->
  <div id="menu-color" data-menu-load="menu-highlights.html"
    style="height:340px" class="offcanvas offcanvas-bottom offcanvas-detached rounded-m">
  </div>

    <!-- Your Page Content Goes Here-->





 </body>