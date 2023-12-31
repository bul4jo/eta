<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>eta</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style"
	content="black-translucent">
<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, viewport-fit=cover" />
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
<link rel="manifest" href="_manifest.json">
<meta id="theme-check" name="theme-color" content="#FFFFFF">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=843ae0fd7d31559bce57a18dcd82bf62&libraries=services"></script>
<script type="text/javascript"
	src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=843ae0fd7d31559bce57a18dcd82bf62"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    	
    	var passengerNo = "${passengerNo}";
    	var driverNo = "${driverNo}";
    	var waypointCoordinates; //경유지 좌표
    	var callCode = "${call.callCode}";
    	
        async function loadMapData() {
        	
        	
            const apiUrl = "https://apis-navi.kakaomobility.com/v1/directions?origin=${currentY},${currentX}&destination=${call.endX},${call.endY}&waypoints=${call.startX},${call.startY}&priority=${call.routeOpt}";
            console.log("Generated URL:", apiUrl);

            try {
                const response = await fetch(apiUrl, {
                    method: 'get',
                    headers: {
                        "Content-Type": "application/json",
                        "Authorization": "KakaoAK bb9f3068bf970e08b9d0147524d0258f"
                    }
                });

                if (!response.ok) {
                    throw new Error("Failed to fetch data");
                }

                const data = await response.json();
                console.log(data);
                drawPolylineAndMoveMarker(data, map);
                
                var waypoint = data.routes[0].sections.find(section => 
                section.guides.some(guide => guide.name === "경유지")
            	).guides.find(guide => guide.name === "경유지");

            	waypointCoordinates = { lat: waypoint.y, lng: waypoint.x };
            	console.log(waypointCoordinates);//경유지

            } catch (error) {
                console.error("Error fetching data:", error);
            }
        }

        

        const drawPolylineAndMoveMarker = (data, map) => {
            const linePath = [];
            data.routes[0].sections.forEach(section => {
                section.roads.forEach(road => {
                    road.vertexes.forEach((vertex, index) => {
                        if (index % 2 === 0) {
                            const lat = road.vertexes[index + 1];
                            const lng = road.vertexes[index];
                            linePath.push(new kakao.maps.LatLng(lat, lng));
                        }
                    });
                });
            });

            var polyline = new kakao.maps.Polyline({
                path: linePath,
                strokeWeight: 5,
                strokeColor: '#000000',
                strokeOpacity: 0.7,
                strokeStyle: 'solid'
            });

            polyline.setMap(map);
	
            var imageSrc = 'https://ifh.cc/g/6gaYnh.png', // 마커이미지의 주소입니다    
            imageSize = new kakao.maps.Size(64, 69), // 마커이미지의 크기입니다
            imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
              
        // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption),
            markerPosition = new kakao.maps.LatLng(37.54699, 127.09598);
            
            let marker = new kakao.maps.Marker({
                map: map,
                position: linePath[0],
                image: markerImage
            });
            
            let marker1 = new kakao.maps.Marker({
                map: map,
                position: waypointCoordinates,
            });
           	console.log(linePath[0]);
        	console.log(waypointCoordinates);

            let index = 0;

            const moveMarker = () => {
                if (index < linePath.length) {
                    marker.setPosition(linePath[index]);
                    map.setCenter(linePath[index]);
                    sendLocationToServer(linePath[index]);
                    index++;
                } else {
                    clearInterval(intervalId);
                }
            };

            const intervalId = setInterval(moveMarker, 100);
        };

        var locationBuffer = [];
        var firstLocation = null;
        var lastLocation = null;
        
        var stompClient = null;

        function sendLocationToServer(index) {
            if (stompClient && stompClient.connected) {
                const location = index;
                const locationData = { lat: location.getLat(), lng: location.getLng() };
                if (callCode=="S") {
                    stompClient.send("/chat/shareStart/" + ${call.callNo}, {}, JSON.stringify(locationData));
                  } else {
                    stompClient.send("/sendLocation/" + passengerNo, {}, JSON.stringify(locationData));
                  }
                
                addLocation(locationData);

                if (!firstLocation) {
                    firstLocation = locationData;
                }

                lastLocation = locationData;
            } else {
                console.error("Websocket is not connected.");
            }
        }
        var passedWaypoint = false;//경유지 지났는지 확인

        function addLocation(locationData) {
            // 경유지 좌표와 현재 위치가 일치하는지 확인
            if (locationData.lat === waypointCoordinates.lat && locationData.lng === waypointCoordinates.lng) {
                passedWaypoint = true; // 경유지를 지났음을 표시
                showPassedWaypointAlert();// 승객을 태웠을 때 알림창 표시
            }

            // 경유지를 지난 후의 위치 데이터만 추가
            if (passedWaypoint) {
                locationBuffer.push(locationData);
            }
        }

        function connectWebSocket() {
            var socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);

            stompClient.connect({}, function (frame) {
                console.log('Connected: ' + frame);
                loadMapData();
                socket.onclose = function () {
                    console.log('WebSocket connection closed');
                };
            }, function (error) {
                console.error('Websocket connection error: ', error);
            });
        }

        connectWebSocket();

        var callNo = ${call.callNo};
        console.log("callNO: "+callNo);
        var callCode = '${call.callCode}';
        console.log("callCode: "+callCode);

        function updateLocationData() {
            if (firstLocation && lastLocation) {
                addRouteMongo();
                sendEndDriving();

                $.ajax({
                    url: '/callres/callEnd',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        startX: firstLocation.lng,
                        startY: firstLocation.lat,
                        endX: lastLocation.lng,
                        endY: lastLocation.lat,
                        callNo: callNo
                    }),
                    success: function(response) {
                        console.log('서버에 데이터 전송 성공:', response);
                        if(callCode === 'D'){
                        	window.location.href = '/feedback/addBlacklist/' + callNo
                        }
                        else{
                        	window.location.href = '/callres/getRealPay?callNo=' + callNo;
                        }
                    },
                    error: function(error) {
                        console.error('서버에 데이터 전송 실패:', error);
                    }
                });
            } else {
                console.error('위치 데이터가 충분하지 않습니다.');
            }
        }

        function addRouteMongo() {
            console.log("Saving location data to MongoDB.");
            console.log(locationBuffer);

            var routeDto = {
                callNo: callNo,
                route: locationBuffer.flatMap(loc => [loc.lat, loc.lng])
            };

            console.log(routeDto);

            $.ajax({
                url: '/route/saveRoute',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(routeDto),
                success: function (response) {
                    console.log("Location data saved to MongoDB successfully.");
                },
                error: function (error) {
                    console.error("Error saving location data to MongoDB: ", error);
                }
            });

            locationBuffer = [];
        }

        var socket2 = new SockJS('/websoket');
        var stompClient2 = Stomp.over(socket2);

        function sendEndDriving() {
        	if (callCode=="S") {
                stompClient2.send("/chat/shareEnd/" + callNo, {}, '운행종료');
              } else {
                stompClient2.send("/sendNotification/" + passengerNo, {}, '운행종료');
              }
        }
        
        function showPassedWaypointAlert() {
            var toastContainer = document.createElement('div');
            toastContainer.innerHTML = '<div id="toast-top-3" class="toast toast-bar toast-top rounded-l bg-green-dark shadow-bg shadow-bg-s" data-bs-delay="3000">' +
                '<div class="align-self-center">' +
                '<i class="icon icon-s bg-green-light rounded-l bi bi-check font-28 me-2"></i>' +
                '</div>' +
                '<div class="align-self-center ps-1">' +
                '<strong class="font-13 mb-n2">승객이 탔습니다!</strong>' +
                '<span class="font-10 mt-n1 opacity-70">어서오세요!</span>' +
                '</div>' +
                '<div class="align-self-center ms-auto">' +
                '<button type="button" class="btn-close btn-close-white me-2 m-auto font-9" data-bs-dismiss="toast"></button>' +
                '</div>' +
                '</div>';

            document.body.appendChild(toastContainer.firstChild); // body에 토스트 알림창 추가
            $('.toast').toast('show'); // Bootstrap 토스트 표시 함수 호출
        }

    </script>
    
    <style>
    /* Add this style to your existing <style> section or in a <style> tag in the <head> */
    .btn{
    	padding : 10px 95%;
    	 text-align: center;
    }
    .text-start {
    white-space: nowrap; /* Prevents wrapping */
}
</style>
</head>
<body>


	<div id="map" style="width: 100%; height: 660px;"></div>
				


		<div class="card card-style">
			<div class="content">
				


				<div class="row">
				    <div class="col-6">
				        <a href="#" class="btn bg-blue-dark shadow-bg-m text-start" onclick="updateLocationData()">운행 종료</a>
				    </div>
				</div>
			</div>
		</div>


	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script
		src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=843ae0fd7d31559bce57a18dcd82bf62&libraries=services"></script>
	<script type="text/javascript"
		src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=843ae0fd7d31559bce57a18dcd82bf62"></script>
	<script>
        var mapContainer = document.getElementById('map'),
            mapOption = {
                center: new kakao.maps.LatLng(37.4939072071976, 127.0143838311636),
                level: 3
            };

        var map = new kakao.maps.Map(mapContainer, mapOption);
    </script>
	<script src="/templates/scripts/bootstrap.min.js"></script>
	<script src="/templates/scripts/custom.js"></script>
</body>
</html>
