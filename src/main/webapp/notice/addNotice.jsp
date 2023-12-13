<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, viewport-fit=cover" />
<title>공지사항 등록</title>
<link rel="stylesheet" type="text/css"
	href="/templates/styles/bootstrap.css">
<link rel="stylesheet" type="text/css"
	href="/templates/fonts/bootstrap-icons.css">
<link rel="stylesheet" type="text/css"
	href="/templates/styles/style.css">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700;800&family=Roboto:wght@400;500;700&display=swap"
	rel="stylesheet">
<link rel="manifest" href="/templates/_manifest.json">
<meta id="theme-check" name="theme-color" content="#FFFFFF">
<link rel="apple-touch-icon" sizes="180x180"
	href="/templates/app/icons/icon-192x192.png">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script type="text/javascript">
$(function () {
	$("h3:cantains('등록')").on("click",function(){
		$('#toast-bottom-4').removeClass('toast toast-pill toast-bottom toast-s rounded-l bg-green-dark shadow-bg shadow-bg-s').addClass('toast toast-pill toast-bottom toast-s rounded-l bg-green-dark shadow-bg shadow-bg-s fade show');
	})
	setTimeout( "document.form.submit()", 3000 );
	
})
</script>
<link rel="stylesheet" type="text/css" href="/templates/styles/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/templates/fonts/bootstrap-icons.css">
<link rel="stylesheet" type="text/css" href="/templates/styles/style.css">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700;800&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="manifest" href="/templates/_manifest.json">
<meta id="theme-check" name="theme-color" content="#FFFFFF">
<link rel="apple-touch-icon" sizes="180x180" href="/templates/app/icons/icon-192x192.png">
</head>
<body class="theme-light">
	<form action="/notice/addNotice" method="post">
		<div id="page">
		
			<div class="page-content header-clear-medium">
				<div class="card card-style">
					<div class="content">
						<!-- <h6 class="font-700 mb-n1 color-highlight">Split Content</h6> -->

						<h1 class="pb-2" style="width: 140px; display: inline-block;">
						<i class="has-bg rounded-s bi bg-teal-dark bi-list-columns">&nbsp;</i>&nbsp;&nbsp;공지사항
						/
					</h1>
					<h3 class="font-400 mb-0"style="display: inline-block;">등록</h3>

					</div>
				</div>

				<div class="card card-style mb-3">
					<div class="content">
						<div class="form-custom form-label form-icon mb-3">
							<h5 class="font-700 mb-nl color-highlight"
								style="padding-bottom: 3px">제목</h5>

							<div class="divider bg-fade-blue" style="width: 9%;margin-bottom: 15px"></div>
							<i class="bi bi-pencil-fill font-12"></i> <input type="text"
								name="noticeTitle" class="form-control rounded-xs" id="c1"
								placeholder="입력해주세요." required />


						</div>
						<div class="mb-3 pb-2"></div>
						<div class="form-custom form-label form-icon mb-3">
							<h5 class="font-700 mb-nl color-highlight"
								style="padding-bottom: 3px">내용</h5>
							<div class="divider bg-fade-blue" style="width: 9%;margin-bottom: 15px"></div>
							<i class="bi bi-pencil-fill font-12"></i>
							<textarea class="form-control rounded-xs" name="noticeDetail"
								placeholder="입력해주세요." id="c7"></textarea>

						</div>
					</div>
				</div>
				

				<button data-toast="toast-bottom-4" class="btn-full btn bg-fade2-blue color-blue-dark"
					type="submit" style="float: right; margin-right: 15px;">등록하기</button>
				

			</div>
		<div id="toast-bottom-4"  class="toast toast-pill toast-bottom toast-s rounded-l bg-blue-dark shadow-bg shadow-bg-s " data-bs-delay="2000" style="width: 130px"><span class="font-12"><i class="bi bi-check font-20"></i>등록되었습니다!</span></div>
		</div>
		
	</form>
<script src="/templates/scripts/bootstrap.min.js"></script>
<script src="/templates/scripts/custom.js"></script>
</body>
</html>