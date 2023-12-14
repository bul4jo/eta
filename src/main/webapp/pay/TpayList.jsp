<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, viewport-fit=cover" />
<title>TpayList</title>
<link rel="stylesheet" type="text/css" href="/templates/styles/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/templates/fonts/bootstrap-icons.css">
<link rel="stylesheet" type="text/css" href="/templates/styles/style.css">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@500;600;700;800&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="manifest" href="/templates/_manifest.json">
<meta id="theme-check" name="theme-color" content="#FFFFFF">
<link rel="apple-touch-icon" sizes="180x180" href="/templates/app/icons/icon-192x192.png">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js" ></script>
<style type="text/css">
  td{
    height: 100px;
  }
</style>
</head>
<body class="theme-light">
<form name="detailform">
  <div id="page">
    <div class="page-content header-clear-medium">
        <div class="card card-style">
          <div class="content">
            <h1 class="pb-2">
              <i class="has-bg rounded-s bi bg-teal-dark bi-list-columns">&nbsp;</i>&nbsp;&nbsp;Tpay 이용 내역
            </h1>
          </div>
        </div>
        
        <div class="card overflow-visible card-style">
          <div class="content mb-0">
            <div class="col-12 mb-4 pb-1" align="right" style="height: 15px">
               <span style="display: inline-block; padding-top: 3px; padding-bottom: 3px; float: left;" class="badge bg-warning-subtle border border-warning-subtle text-warning-emphasis rounded-pill">
								  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-currency-dollar" viewBox="0 0 16 16">
								  <path d="M4 10.781c.148 1.667 1.513 2.85 3.591 3.003V15h1.043v-1.216c2.27-.179 3.678-1.438 3.678-3.3 0-1.59-.947-2.51-2.956-3.028l-.722-.187V3.467c1.122.11 1.879.714 2.07 1.616h1.47c-.166-1.6-1.54-2.748-3.54-2.875V1H7.591v1.233c-1.939.23-3.27 1.472-3.27 3.156 0 1.454.966 2.483 2.661 2.917l.61.162v4.031c-1.149-.17-1.94-.8-2.131-1.718H4zm3.391-3.836c-1.043-.263-1.6-.825-1.6-1.616 0-.944.704-1.641 1.8-1.828v3.495l-.2-.05zm1.591 1.872c1.287.323 1.852.859 1.852 1.769 0 1.097-.826 1.828-2.2 1.939V8.73l.348.086z"/>
								</svg> 잔여 Tpay ${myMoney} 원 </span>
              <a class="btn btn-xxs bg-fade2-blue color-blue-dark"
                onclick="payRequest()"
                style="display: inline-block; padding-top: 3px; padding-bottom: 3px; float: left;" ><i class="bi bi-cash-coin"></i>충전</a>

              <select id="month" class="form-select" style="width: 20%; display: inline-block">
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

              <a class="btn btn-xxs border-blue-dark color-blue-dark"
                style="display: inline-block; padding-top: 3px; padding-bottom: 3px" id="searchButton">검색</a>
            </div>
            
            <div class="table-responsive">
              <table class="table color-theme mb-2" id="muhanlist">
                <thead>
                  <tr>
                    <th scope="col">배차번호</th>
                    <th scope="col">결제 유형</th>
                    <th scope="col">날짜</th>
                    <th scope="col">금액</th>
                  </tr>
                </thead>
                <tbody>
							    <c:choose>
							        <c:when test="${empty TpayList}">
							            이용 내역이 없습니다.
							        </c:when>
							        <c:otherwise>
							            <!-- Tpay 리스트--> 
							            <c:set var="i" value="0" />
							            <c:forEach var="TpayList" items="${TpayList}">        
							              <c:set var="i" value="${ i+1 }" />
							              <tr class="list">
							                  <td>
							                  <c:choose>
										                <c:when test="${TpayList.callNo eq 0}">
			                              </c:when>
			                              <c:otherwise>
			                               <a class="getRecord" data-callno="${TpayList.callNo} "> ${TpayList.callNo} </a>
			                              </c:otherwise>
			                          </c:choose>     
                               </td>
					                      <td>${TpayList.payType}</td>
					                      <td>${TpayList.payDate}</td>  
					                      <td>${TpayList.money} 원</td>        
							              </tr>
	                      </c:forEach>           
							        </c:otherwise>
							    </c:choose>
                </tbody>
              </table>
            </div>
                <input type="hidden" id="userNo" value="${user.userNo }">
						    <input type="hidden" id="email" value="${user.email }">
						    <input type="hidden" id="name" value="${user.name }">
						    <input type="hidden" id="phone" value="${user.phone }">
          </div>
        </div>         
     </div>
    </div>
    </form>
</body>
<script>

$(function() {
	   
	   $( "#searchButton" ).on("click" , function() {
		   var month = $("#month").val();
		   self.location = '/pay/TpayList?userNo=${user.userNo}&month='+month;
	  });
	   
	    $( ".getRecord" ).on("click" , function() { 
	        
	        var callNo = $(this).data("callno");
	          self.location = "/callres/getRecordPassenger?callNo="+callNo;
	       }); 
});

function payRequest(){
	
	  var userInput = prompt("충전할 금액을 입력하세요 :");
	  
	  if(userInput !== null && userInput < 10000){
		  alert("10000원 이상 충전이 가능합니다.");
		  payRequest();
		  
	  } else if (userInput !== null && userInput >= 10000) {
	    
		  TpayCharge(userInput);
		  
	  } else {
	    alert("충전이 취소되었습니다.");
	  }

}
function TpayCharge(Tpay) {
	  
	  var IMP = window.IMP;
	  IMP.init("imp16061541");
	  
	  var No = document.getElementById('userNo');
	  var userNo = No.value;
	  var name = document.getElementById('name');
	  var userName = name.value;
	  var phone = document.getElementById('phone');
	  var userPhone = phone.value;
	  var email = document.getElementById('email');
	  var userEmail = email.value;
	  
	  //alert(userNo, userName, userPhone, userEmail);

	    // IMP.request_pay(param, callback) 결제창 호출
	    IMP.request_pay({ // param
	       pg : 'html5_inicis',
	          pay_method : 'card',
	          merchant_uid: "merchant_" + new Date().getTime(), // 상점에서 관리하는 주문 번호를 전달
	          name : 'Tpay 충전',
	          amount : Tpay,
	          buyer_name : userName,
	          buyer_email : userEmail,
	          buyer_tel : userPhone,  //필수입력
	          //buyer_postcode : '123-456',
	          m_redirect_url : '{/purchase/addPurchase.jsp}' // 예: https://www.my-service.com/payments/complete/mobile
	    }, function (rsp) { // callback
	        if (rsp.success) {
	            alert(Tpay+"원 충전이 완료되었습니다.");
	            addCharge(Tpay, userNo);
	          
	        } else {
	           alert("충전이 실패하였습니다.");
	        }
	    });
	  }
	  
function addCharge(Tpay, userNo){
	  $.ajax({
		    type: 'POST',
		    url: '/pay/json/addCharge',
		    data: {
		      Tpay: Tpay,
		      userNo: userNo
		    },
		    success: function (response) {
		    	console.log("addCharge() 성공");		    	
		    	if (response.success) {
		            alert(response.message);
		            location.reload();
		        } else {
		            alert(response.message);
		        }
		    },
		    error: function (error) {
		      console.error('addCharge() 실패', error);
		    }
		  });

	  }
</script>
</html>