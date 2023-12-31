<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>callreq test</title>
  <style>
    /* 버튼에 적용할 스타일 */
    .hidden {
      display: none;
    }
  </style>
</head> 
<body>

 <button type="button" class="inputAddress" onclick="inputAddress('N')">일반콜</button>
  <button type="button" class="inputAddress" onclick="inputAddress('R')">예약콜</button>
  <button type="button" class="inputAddress" onclick="inputAddress('D')">택시비 딜 콜</button>
  <button type="button" class="inputAddress" onclick="inputAddress('S')">합승콜</button>
 <br>
  <button type="button" class="likeAddress" onclick="likeAddress()">즐겨찾기</button>
  <br>
   <button type="button" class="TpayList" onclick="TpayList()">Tpay 이용 내역</button>
   <br>
   <button type="button" class="cashDriverList" onclick="cashDriverList()">정산 승인 대상 리스트</button>
  <br>
  <button type="button" class="myCashList" onclick="myCashList()">정산 내역 리스트</button>
  <br>
  <button type="button" class="test" onclick="test()">ui test</button>
 <!-- <input type="text" placeholder="도착지" class="content">
 <input type="text" placeholder="경로옵션" class="content">
 <input type="text" placeholder="가격" class="content">
    <button type="button" class="sendBtn" onclick="sendMessage()">전송</button>

    <div id="callreq">
    <div class="msgArea"></div>
    <div id="socketAlertDiv" class="hidden"></div>
    </div>
     -->
</body>
<script>
function test() {    
    self.location = "https://localhost:8000/callreq/ui_test.jsp"
  }
function myCashList() {    
    self.location = "/pay/myCashList?userNo="+${user.userNo }+"&month=all"
  }
  
function cashDriverList() {
    
    self.location = "/pay/cashDriverList?month=all"
  }
  
function likeAddress() {
    
	  self.location = "/callreq/likeAddress?userNo="+${user.userNo }
	}

function inputAddress(callCode) {
	var callCode = callCode;

	if(callCode === 'N'){
		self.location = "/callreq/inputAddress?userNo="+${user.userNo }+"&callCode=N"
	} else if(callCode === 'D'){
		self.location = "/callreq/inputAddress?userNo="+${user.userNo }+"&callCode=D"
	} else if(callCode === 'S'){
		 self.location = "/callreq/inputAddress?userNo="+${user.userNo }+"&callCode=S"
	} else if(callCode === 'R'){
		self.location = "/callreq/inputAddress?userNo="+${user.userNo }+"&callCode=R"
	}	
}

function TpayList() {
    
    self.location = "/pay/TpayList?userNo="+${user.userNo }+"&month=all"
  }

/*    let socket = new WebSocket("wss://localhost:8000/websocket");

    socket.onopen = function (event) {
        console.log("웹 소켓 연결 성공!");
    };

    socket.onerror = function (error) {
        console.log(`에러 발생: ${error}`);
    };

    socket.onmessage = function (event) {
        let msgArea = document.querySelector('.msgArea');
        let newMsg = document.createElement('div');
        newMsg.innerText = event.data;
        msgArea.appendChild(newMsg);
        
        showButtonWithMessage(event.data);
    };

    function sendMessageBack() {
        
        socket.send("driver가 call을 수락하였습니다.");
    }
    
    function sendMessage() {
        let contentElemenets = document.querySelectorAll('.content');
        let contentValues = [];
        contentElemenets.forEach(function (element){
        	contentValues.push(element.value);
        });
        let contentString = contentValues.join(', ');
        
        socket.send(contentString);
    }
    
    function showButtonWithMessage(message) {
      let socketAlertDiv = document.getElementById('socketAlertDiv');

      let newAcceptBtn = document.createElement('button');
      newAcceptBtn.type = 'button';
      newAcceptBtn.innerText = "수락";
      newAcceptBtn.onclick = function () {
        alert("수락!"+message);
        let callreq = document.getElementById('callreq');
        callreq.parentNode.removeChild(callreq);

        sendMessageBack();
      };

      let newDenyBtn = document.createElement('button');
      newDenyBtn.type = 'button';
      newDenyBtn.innerText = "거절";
      newDenyBtn.onclick = function () {
        alert("거절!"+message);
        let callreq = document.getElementById('callreq');
        callreq.parentNode.removeChild(callreq);
      };

      // 새로운 버튼을 기존 버튼 뒤에 추가
      socketAlertDiv.innerHTML += "<div>" + message + "</div>";
      socketAlertDiv.appendChild(newAcceptBtn);
      socketAlertDiv.appendChild(newDenyBtn);


        // 버튼이 숨겨져 있다면 표시
        if (socketAlertDiv.classList.contains('hidden')) {
          socketAlertDiv.classList.remove('hidden');
        }
      }
*/
</script>
</html>