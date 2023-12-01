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
<input type="hidden" name="callNo" value="${callNo}">
<button type="button" onclick="deleteCall()">취소</button>
</form>

</body>
<script>
function deleteCall(){
	alert("배차 탐색을 취소하시겠습니까?");
	$("form").attr("method" , "POST").attr("action" , "/callreq/deleteCall").submit();
}

</script>
</html>