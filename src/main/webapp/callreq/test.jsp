<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>searchCall</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
</head>
<body>

<div class="msgArea"></div>   <!--websocket 전송받기 test -->

배차 탐색 중<br>
배차번호 : ${callNo} <br>

    <c:set var="i" value="0" />
    <c:forEach var="callDriverList" items="${callDriverList}">
      <c:set var="i" value="${ i+1 }" />
      
      <div id="callDriverList">
      <p> petOpt, carOpt에 해당하는 driver : ${callDriverList.userNo}</p>        
      </div>
    </c:forEach>
    
<form>
<input type="hidden" name="callNo" id="callNo" value="${callNo}">
<button type="button" onclick="deleteCall()">취소</button>
</form>

</body>
<script>
document.addEventListener('DOMContentLoaded', function() {
  
  var callNo = document.getElementById('callNo').value;
  
    window.callNo = {
        callNo: callNo
            };
    
});

function deleteCall(){
  alert("배차 탐색을 취소하시겠습니까?");
  $("form").attr("method" , "POST").attr("action" , "/callreq/deleteCall").submit();
}

let socket = new WebSocket("ws://localhost:8000/websocket");

socket.onopen = function (event) {
    console.log("웹 소켓 연결 성공!");
    
    var callNo = window.callNo.callNo;
    sendMessage(callNo);
};

socket.onerror = function (error) {
    console.log(`에러 발생: ${error}`);
};

socket.onmessage = function (event) {
    let msgArea = document.querySelector('.msgArea');
    let newMsg = document.createElement('div');
    newMsg.innerText = event.data;
    msgArea.appendChild(newMsg);
    
    //showButtonWithMessage(event.data);
};

function sendMessageBack() {
    
    socket.send("driver가 call을 수락하였습니다.");
}

function sendMessage(callNo) {    
    
    console.log("push 된 callNo : "+callNo);

    // 'user01'에게 위치 데이터 전송
   // template.convertAndSend("/topic/location/user01", location);

      
    socket.send("/topic/location/user01", callNo);
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

</script>
</html>