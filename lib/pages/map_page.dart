import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:safet/main.dart';

Set<Marker> markers = {}; // 마커 변수

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late KakaoMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    // 초기화 시 현재 위치를 기반으로 마커 추가
    _getCurrentLocation();
  }

  // 현재 위치 가져오기
  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        markers.add(Marker(
          markerId: UniqueKey().toString(),
          latLng: LatLng(position.latitude, position.longitude),
        ));
      });

    } catch (e) {
      print("Error while fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지도',
            style: TextStyle(color: safeTblack,
            fontFamily:"safeTboldPT",),
          ),
          centerTitle: true, // title 중앙정렬
          backgroundColor: Colors.white,
          //elevation: 0, 
          iconTheme: IconThemeData( // 뒤로 가기 화살표 색상 설정
          color: safeTgreen,
        ),
      ),
      backgroundColor: Colors.white,
      body: KakaoMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        markers: markers.toList(),
        //이브와 시연장소 위도 경도
        center: markers.isEmpty ? LatLng(37.5605524, 126.9738586) : markers.first.latLng,
        //덕성 위도 경도
        //center: markers.isEmpty ? LatLng(37.651708, 127.013911) : markers.first.latLng,
        //
        //center: markers.isEmpty ? LatLng(,) : markers.first.latLng,
      ),
    );
  }
}