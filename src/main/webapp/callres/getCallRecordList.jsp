<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>





<!DOCTYPE html>

<html>

<head>
    <meta charset="UTF-8">
    <title>eta</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, viewport-fit=cover" />
    <link rel="stylesheet" type="text/css" href="/templates/styles/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="/templates/fonts/bootstrap-icons.css">
    <link rel="stylesheet" type="text/css" href="/templates/styles/style.css">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700;800&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="manifest" href="_manifest.json">
    <meta id="theme-check" name="theme-color" content="#FFFFFF">
    <link rel="apple-touch-icon" sizes="180x180" href="app/icons/icon-192x192.png">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
<style>
.record-container {
	display: flex;
	flex-direction: row;
	justify-content: flex-start;
	align-items: center;
	margin-bottom: 10px;
	cursor: pointer; /* 마우스 커서를 포인터로 설정 */
}

.record-container p {
	margin-right: 20px;
}
</style>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">

$(function () {
	function countCurrentPage() {
		let count =  $("#currentPage").val();
	    let newcount = parseInt(count) + 1;
	    $("#currentPage").val(newcount);
	}
	let isAjaxInProgress = false;
	let lastScroll = 0;

	$(document).scroll(function(e){
	    //현재 높이 저장
	    var currentScroll = $(this).scrollTop();
	    //전체 문서의 높이
	    var documentHeight = $(document).height();

	    //(현재 화면상단 + 현재 화면 높이)
	    var nowHeight = $(this).scrollTop() + $(window).height();


	    //스크롤이 아래로 내려갔을때만 해당 이벤트 진행.
	    if(currentScroll > lastScroll){

	        //nowHeight을 통해 현재 화면의 끝이 어디까지 내려왔는지 파악가능 
	        //즉 전체 문서의 높이에 일정량 근접했을때 글 더 불러오기)
	        if(documentHeight < (nowHeight + (documentHeight*0.05))){
	            console.log("이제 여기서 데이터를 더 불러와 주면 된다.");
	            if (!isAjaxInProgress) {
                    isAjaxInProgress = true;
	            countCurrentPage();
	            if($("#currentPage").val() <= ${resultPage.maxPage}){
	            	let data = {
	        				
	        				currentPage : $("#currentPage").val(),
	        				searchKeyword : $("input:text[name='searchKeyword']").val()
	        		}
				
				$.ajax( 
						{
						url : "/callres/json/listCallRecord/"+$("#currentPage").val() ,
						method : "POST" ,
						dataType : "json" ,
						headers : {
							"Accept" : "application/json",
							"Content-Type" : "application/json"
						},
						data		:  JSON.stringify(data),
						success : function(calllist , status) {
							$.each(calllist, function (index, record) {
					            // 새로운 행 추가
					            var newRow = '<tr class="appendlist"'+(index+1)+'>' +
					                '<td>' + record.callNo + '</td>' +
					                '<td>' + record.callDate + '</td>' +
					                '<td>' + record.startKeyword + '</td>' +
					                '<td>' + record.endKeyword + '</td>' +
					                '</tr>';

					            // 적절한 위치에 행 추가word
					            $('#muhanlist').append(newRow);
					            isAjaxInProgress = false;	
					        });
								   
							}  
						
					});
				
	        	}else{
	        		isAjaxInProgress = true;
	        		}
	        	}
	        }
	    }

	    //현재위치 최신화
	    lastScroll = currentScroll;

	});

	$(document).ready(function() {
	    // Event handler for 검색 button click
	    $("#searchButton").on("click", function() {
	        // Get the selected month value
	        var selectedMonth = $("#month").val();

	        // Set the selected month as a parameter in the form action
	        $("form[name='detailform']").attr("method", "POST")
	            .attr("action", "/callres/getCallResList?month=" + selectedMonth)
	            .submit();
	    });

	    // Event handler for tr click
	    $(document).on("click", "tr", function() {
	        // Redirect with the selected callNo as a parameter
	        self.location = "/callres/getRecord?callNo=" + $(this).children().eq(0).text();
	    });

	    // Set the selected value in the <select> element based on the 'month' parameter
	    var selectedMonth = "${param.month}";
	    $("#month").val(selectedMonth);
	});

	

})

</script>


</head>

<body class="theme-light">
	<form name="detailform">
        <div id="page">
            <jsp:include page="/home/top.jsp" />
            <div class="page-content header-clear-medium">
                <div class="card card-style">
                    <div class="content">
                        <h1 class="pb-2">
                            <i class="has-bg rounded-s bi bg-teal-dark bi-list-columns">&nbsp;</i>&nbsp;&nbsp;전체 운행기록
                        </h1>
                    </div>
                </div>

                <div class="card overflow-visible card-style">
                    <div class="content mb-0">
                       <div class="col-12 mb-4 pb-1" align="right" style="height: 15px">
                  <select id="month" class="form-select"  style="padding-top: 3px; padding-bottom: 3px; width: 30%; display: inline-block">
										  <option value="all">전체</option>
										  <option value="01">1월</option>
										  <option value="02">2월</option>
										  <option value="03">3월</option>
										  <option value="04">4월</option>
										  <option value="05">5월</option>
										  <option value="06">6월</option>
										  <option value="07">7월</option>
										  <option value="08">8월</option>
										  <option value="09">9월</option>
										  <option value="10">10월</option>
										  <option value="11">11월</option>
										  <option value="12">12월</option>
										</select>
              <a class="btn btn-xxs border-blue-dark color-blue-dark" id="searchButton"
                style="display: inline-block; padding-top: 5px; padding-bottom: 5px; padding-left: 20px; padding-right: 20px;margin-left: 5px; ">검색</a>
            </div>

                         <div class="table-responsive">
                        <table class="table color-theme mb-2" id="muhanlist">
                            <thead>
                                <tr>
                                    <th scope="col">배차번호</th>
                                    <th scope="col">날짜시간</th>
                                    <th scope="col">출발</th>
                                    <th scope="col">도착</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty list}">
                                        <c:forEach var="record" items="${list}" begin="0" step="1" varStatus="status">
                                            <tr class="list">
                                                <td>${record.callNo}</td>
                                                <td>${record.callDate}</td>
                                                <td>${record.startKeyword}</td>
                                                <td>${record.endKeyword}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="no-records-message">운행 기록이 없습니다.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    </div>
                </div>
                <input type="hidden" id="currentPage" name="currentPage" value=1>
            </div>
        </div>
    </form>

	<script src="/templates/scripts/bootstrap.min.js"></script>
	<script src="/templates/scripts/custom.js"></script>

</body>

</html>

