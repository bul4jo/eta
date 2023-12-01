<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>input Address</title>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=70ef6f6883ad97593a97af6324198ac0&libraries=services"></script>
<script>
if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(async function (position) {
        const latitude = position.coords.latitude;
        const longitude = position.coords.longitude;

        var startAddress = sessionStorage.getItem('startAddress');
        var startLat = sessionStorage.getItem('startLat');
        var startLng = sessionStorage.getItem('startLng');
        var startPlaceName = sessionStorage.getItem('startPlaceName');

        console.log("지도에서 받은 startAddr!! : " + startAddress);
        console.log("지도에서 받은 startLat!! : " + startLat);
        console.log("지도에서 받은 startLng!! : " + startLng);
        console.log("지도에서 받은 startPlaceName!! : " + startPlaceName);

        // async 키워드 추가
        var result = await getAddressFromCoords(latitude, longitude);
        var firstPlaceName = result.placeName;
        var firstAddr = result.address;
        var firstLat = result.latitude;
        var firstLng = result.longitude;

        if (startAddress == null) {
            document.getElementById('startAddrKeyword').value = "현 위치 : " + firstPlaceName;
            window.selectOptionsStartData = {
                    startAddress: firstAddr,
                    startPlaceName: firstPlaceName
                };
        } else {
            document.getElementById('startAddrKeyword').value = startPlaceName;

        }

        if (startLat == null || startLng == null) {
            startLat = latitude;
            startLng = longitude;
        }

        function getAddressFromCoords(lat, lng) {
            return new Promise(async (resolve) => {
                var geocoder = new kakao.maps.services.Geocoder();
                geocoder.coord2Address(lng, lat, async function (result, status) {
                    var data = {};
                    if (status === kakao.maps.services.Status.OK) {
                        var detailAddr = !!result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
                        var placeName = await getPlaceName(detailAddr);

                        data.placeName = placeName;
                        data.address = detailAddr;
                        data.latitude = lat;
                        data.longitude = lng;

                        console.log('현재 위치 장소 이름:', placeName);
                        console.log('현재 위치 주소:', detailAddr);
                        console.log('현재 위치 lat:', lat);
                        console.log('현재 위치 lng:', lng);
                    }

                    resolve(data);
                });
            });
        }

        function getPlaceName(detailAddr) {
            return new Promise((resolve) => {
                var ps = new kakao.maps.services.Places();
                ps.keywordSearch(detailAddr, function (data, status, pagination) {
                    if (status === kakao.maps.services.Status.OK) {
                        if (data.length > 0) {
                            console.log("first_place_name : " + data[0].place_name);
                            resolve(data[0].place_name);
                        } else {
                            resolve(detailAddr);
                        }
                    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
                        resolve(detailAddr);
                    } else if (status === kakao.maps.services.Status.ERROR) {
                        alert('검색 결과 중 오류가 발생했습니다.');
                        resolve(detailAddr);
                    }
                });
            });
        }

    });
}


</script>
</head>
<body>
    <div class="map_wrap">
        <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
        <div id="menu_wrap" class="bg_white">
            <div class="startAddrSearch">
                <div>
                    <form class="form">
                        <input type="text" value="" id="startAddrKeyword" size="50px"> 
                        <button id="startSubmit" type="submit">주소검색</button> 
                    </form>
                </div>
            </div>
            <div class="endAddrSearch">
                <div>
                    <form class="form">
                        <input type="text" value="" id="endAddrKeyword" size="50px"> 
                        <button id="endSubmit" type="submit">주소검색</button> 
                    </form>
                </div>
            </div>
            <hr>
            <ul id="placesList"></ul>
            <div id="pagination"></div>
        </div>
    </div>
    <!-- 출발지, 목적지 둘다 입력되어야 넘어가게 하기 -->
    <button type="button" class="selectOptions" onclick="selectOptions()">옵션 선택</button>
    <!-- 이용내역 도착지 키워드, 주소 리스트 -->
    <c:set var="i" value="0" />
    <c:forEach var="endAddrList" items="${endAddrList}">
      <c:set var="i" value="${ i+1 }" />
      
      <div id="endAddrList">
      <p>${endAddrList.endKeyword}</p>
      <p>${endAddrList.endAddr}</p>
      <p>${endAddrList.endX}</p>
      <p>${endAddrList.endY}</p>          
      </div>
    </c:forEach>
    
    <!-- 즐겨찾기 리스트-->
    <c:set var="i" value="0" />
    <c:forEach var="likeList" items="${likeList}">
      <c:set var="i" value="${ i+1 }" />
      
      <div id="likeList">
      <p>${likeList.likeNo}</p>
      <p>${likeList.likeName}</p>
      <p>${likeList.likeAddr}</p>           
      </div>

    </c:forEach>
    
       
</body>
<script>

//마커를 담을 배열입니다
var markers = [];
let presentPosition;
 
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 5 // 지도의 확대 레벨 
    }; 
 
var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

 
////////////////////장소 검색/////////////////////////////
// 장소 검색 객체를 생성합니다
var ps = new kakao.maps.services.Places();  
 
// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});
 
//시작 주소 검색 form에 이벤트 리스너 추가
const startAddrForm = document.querySelector('.startAddrSearch .form');
startAddrForm.addEventListener('submit', function (e) {
    e.preventDefault();

    // 키워드로 장소를 검색합니다
    searchPlaces('startAddrKeyword', 'start');
});

// 종료 주소 검색 form에 이벤트 리스너 추가
const endAddrForm = document.querySelector('.endAddrSearch .form');
endAddrForm.addEventListener('submit', function (e) {
    e.preventDefault();
    // 키워드로 장소를 검색합니다
    searchPlaces('endAddrKeyword', 'end');
});
 
//키워드 검색을 요청하는 함수입니다
function searchPlaces(keywordId, type) {
	  console.log("searchPlaces type : "+type);
	
    var keyword = document.getElementById(keywordId).value;

    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!');
        return false;
    }
    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
    ps.keywordSearch(keyword, function(data, status, pagination) {
        placesSearchCB(data, status, pagination, type);
    });
}
 
// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination, type) {
	 console.log("placesSearchCB type : "+type);
    if (status === kakao.maps.services.Status.OK) {

        // 정상적으로 검색이 완료됐으면
        // 검색 목록과 마커를 표출합니다
        displayPlaces(data, type);
 
        // 페이지 번호를 표출합니다
        displayPagination(pagination);
 
    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
 
        alert('검색 결과가 존재하지 않습니다.');
        return;
 
    } else if (status === kakao.maps.services.Status.ERROR) {
 
        alert('검색 결과 중 오류가 발생했습니다.');
        return;
 
    }
}
 
// 검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places, type) {
	console.log("displayPlaces type: "+type);
    var listEl = document.getElementById('placesList'), 
    menuEl = document.getElementById('menu_wrap'),
    fragment = document.createDocumentFragment(), 
    bounds = new kakao.maps.LatLngBounds(), 
    listStr = '';
    
    // 검색 결과 목록에 추가된 항목들을 제거합니다
    removeAllChildNods(listEl);
 
    // 지도에 표시되고 있는 마커를 제거합니다
    removeMarker();
    
    for ( var i=0; i<places.length; i++ ) {
 
        const lon = places[i].x;
        const lat = places[i].y;
 
        // 마커를 생성하고 지도에 표시합니다
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
            marker = addMarker(placePosition, i), 
            itemEl = getListItem(i, places[i], type); // 검색 결과 항목 Element를 생성합니다
 
        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        // LatLngBounds 객체에 좌표를 추가합니다
        bounds.extend(placePosition);

 
        // 마커와 검색 결과를 클릭했을때 좌표를 가져온다
        (function(marker, title) {
            kakao.maps.event.addListener(marker, 'click', function() {
                searchDetailAddrFromCoords(presentPosition, function(result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        detailAddr = !!result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
                        location.href = "https://map.kakao.com/?sName="+detailAddr+"&eName="+title                                            
                    }   
                });
            })
        })(marker, places[i].place_name);
 
        fragment.appendChild(itemEl);
    }
 
    // 검색결과 항목들을 검색결과 목록 Elemnet에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;
 
    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
    map.setBounds(bounds);
}
 
// 검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places, type) {
	 console.log("getListItem : "+type);
    var el = document.createElement('li'),
    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                '<div class="info">' +
                '   <h5>' + places.place_name + '</h5>';
 
    if (places.road_address_name) {
        itemStr += '    <span>' + places.road_address_name + '</span>' +
                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
    } else {
        itemStr += '    <span>' +  places.address_name  + '</span>'; 
    }
                 
      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                '</div>';           
 
    el.innerHTML = itemStr;
    el.className = 'item';
    
    // 클릭 이벤트 핸들러에 클로저를 사용하여 좌표 정보 전달
    el.onclick = (function (place, type) {
        return function () {
        	var position = new kakao.maps.LatLng(place.y, place.x);
            displayInfowindow(place.place_name, position, type);
        };
    })(places, type);
 
    return el;
}
 
// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, idx, title) {
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });
 
    marker.setMap(map); // 지도 위에 마커를 표출합니다
    markers.push(marker);  // 배열에 생성된 마커를 추가합니다
 
    return marker;
}
 
// 지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
}
 
// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination'),
        fragment = document.createDocumentFragment(),
        i; 
 
    // 기존에 추가된 페이지번호를 삭제합니다
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }
 
    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;
 
        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }
 
        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}
 
// 검색결과 목록 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
async function displayInfowindow(title, position, type) {
	console.log("displayInfowindow type : "+type);
	console.log("title : "+title);
	
    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';
 
    infowindow.setContent(content);
    
    // 클릭한 검색 결과 항목의 좌표 정보를 활용하여 주소 정보를 가져옵니다
    var result = await new Promise((resolve) => {
        searchDetailAddrFromCoords(position, function(result, status) {
            resolve({ result, status });
        });
    });
    
    if (result.status === kakao.maps.services.Status.OK) {
        var detailAddr = !!result.result[0].road_address ? result.result[0].road_address.address_name : result.result[0].address.address_name;
        console.log('Clicked Position:', position);
        console.log('Detail Address:', detailAddr);
        
        // 결과를 input text에 넣어줍니다
        var keywordId = type === 'start' ? 'startAddrKeyword' : 'endAddrKeyword';
        var keywordInput = document.getElementById(keywordId);
        if (keywordInput) {
        	
        	 if(title == null){       		 
        		 keywordInput.value = detailAddr;
        	 } else{
        		 keywordInput.value = title;
        	 }
 
         // 세션 스토리지에 정보 저장
            sessionStorage.setItem('lat', position.getLat());
            sessionStorage.setItem('lng', position.getLng());
            sessionStorage.setItem('address', detailAddr);
            sessionStorage.setItem('type', type);
            
            location.href ='http://localhost:8000/callreq/inputAddressMap.jsp';                       
            //inputAddress.jsp
        }
    }
}
 
 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
}
 
//좌표 -> 주소
var geocoder = new kakao.maps.services.Geocoder();

// 좌표를 이용하여 주소를 검색하고 콜백 함수를 호출하는 함수
function searchDetailAddrFromCoords(coords, callback) {
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}

document.addEventListener('DOMContentLoaded', function() {
    // 세션 스토리지에서 데이터 가져오기
    var startAddress = sessionStorage.getItem('startAddress');
    var endAddress = sessionStorage.getItem('endAddress');
    var startPlaceName = sessionStorage.getItem('startPlaceName');
    var endPlaceName = sessionStorage.getItem('endPlaceName');
    var startLat = sessionStorage.getItem('startLat');
    var endLat = sessionStorage.getItem('endLat');
    var startLng = sessionStorage.getItem('startLng');
    var endLng = sessionStorage.getItem('endLng');

    console.log("start : "+startAddress); // 옵션선택화면으로 넘길 최종 값
    console.log("end : "+endAddress); // 옵션선택화면으로 넘길 최종 값
    console.log("start place: "+startPlaceName); // 옵션선택화면으로 넘길 최종 값
    console.log("end place: "+endPlaceName); // 옵션선택화면으로 넘길 최종 값
    console.log("start lat : "+startLat); // 옵션선택화면으로 넘길 최종 값
    console.log("end lat : "+endLat); // 옵션선택화면으로 넘길 최종 값
    console.log("start lng: "+startLng); // 옵션선택화면으로 넘길 최종 값
    console.log("end lng: "+endLng); // 옵션선택화면으로 넘길 최종 값
    
    var startKeywordInput = document.getElementById('startAddrKeyword'); // Add quotes around the ID
    var endKeywordInput = document.getElementById('endAddrKeyword'); // Add quotes around the ID
    
    // sessionStorage에 데이터가 있을 때만 처리
    if (startKeywordInput) {
        startKeywordInput.value = startPlaceName;
    }
    
    if (endKeywordInput) {
        endKeywordInput.value = endPlaceName;
    }
    
    // selectOptions 함수에 전달할 데이터 설정
    window.selectOptionsEndData = {
        endAddress: endAddress,
        endPlaceName: endPlaceName
    };
    
    window.selectOptionsStartDataMap = {
            startAddress: startAddress,
            startPlaceName: startPlaceName
        };
});


function selectOptions(){
	  
	  // 세션 스토리지에 정보 저장	 
	  if(window.selectOptionsStartDataMap.startAddress != null){
		  sessionStorage.setItem('startAddress', window.selectOptionsStartDataMap.startAddress);
		  sessionStorage.setItem('startPlaceName', window.selectOptionsStartDataMap.startPlaceName);
	  } else{
	      sessionStorage.setItem('startAddress', window.selectOptionsStartData.startAddress);
	      sessionStorage.setItem('startPlaceName', window.selectOptionsStartData.startPlaceName);
	  }
    
    sessionStorage.setItem('endAddress', window.selectOptionsEndData.endAddress);    
    sessionStorage.setItem('endPlaceName', window.selectOptionsEndData.endPlaceName);

	  
	  self.location = "/callreq/selectOptions?userNo=1004"
	}
</script>

</body>

</html>