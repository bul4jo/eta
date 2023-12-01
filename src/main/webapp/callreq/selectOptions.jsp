<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectOptions</title>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
  <style>
    /* 버튼에 적용할 스타일 */
    .hidden {
      display: none;
    }
  </style>
</head>
<body>
<form>
 <input type="hidden" name="callCode" id="callCode" value="N">
 출발지 : <input type="text" value="" id="startAddrKeyword" size="50px" name="startKeyword" class="content"><br>
 목적지 : <input type="text" value="" id="endAddrKeyword" size="50px" name="endKeyword" class="content"><br>
 <input type="hidden" name="startAddr" id="startAddrInput">
 <input type="hidden" name="endAddr" id="endAddrInput">
  <input type="hidden" name="endAddr" value=>
 차량 옵션 : <input type="text" value="4" class="content" name="carOpt"><br>
 반려동물 옵션 : <input type="text" value="0" class="content" name="petOpt"><br>
 경로 옵션 : <input type="text" value="추천" class="content" name="routeOpt"><br>
 
 잔여 Tpay : ${myMoney} 원<br>
 선결제 예상금액 : <input type="text" id = "prepay" name="realPay" value="100" class="content"> <br>
    <button type="button" class="sendBtn" onclick="addCall()">호출하기</button>
</form>
    <div id="callreq">
    <div class="msgArea"></div>
    <div id="socketAlertDiv" class="hidden"></div>
    </div>
</body>
<script>
document.addEventListener('DOMContentLoaded', function() {
		var startAddress = sessionStorage.getItem('startAddress');
		var endAddress = sessionStorage.getItem('endAddress');
		var startPlaceName = sessionStorage.getItem('startPlaceName');
	  var endPlaceName = sessionStorage.getItem('endPlaceName');
		
		var startKeywordInput = document.getElementById('startAddrKeyword'); // Add quotes around the ID
		var endKeywordInput = document.getElementById('endAddrKeyword'); // Add quotes around the ID
		
		// sessionStorage에 데이터가 있을 때만 처리
		if (startKeywordInput) {
		    startKeywordInput.value = startPlaceName;
		}
		
		if (endKeywordInput) {
		    endKeywordInput.value = endPlaceName;
		}
		
        window.selectOptionsData = {
        		startAddress: startAddress,
        		startPlaceName: startPlaceName,
            endAddress: endAddress,
            endPlaceName: endPlaceName
            };
        
});


    let socket = new WebSocket("ws://localhost:8000/websocket");

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
    function addCall(){
    	
    	 document.getElementById('startAddrInput').value = window.selectOptionsData.startAddress;
    	 document.getElementById('endAddrInput').value = window.selectOptionsData.endAddress;
    	 
    	$("form").attr("method" , "POST").attr("action" , "/callreq/addCall").submit();
    	
    	//sendMessage();
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

</script>
</html>