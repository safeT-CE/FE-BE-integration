import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import '../main.dart';
import 'detailed_usage_data.dart';

class DetailedUsageMapPage extends StatefulWidget {
  final DetailedUsage usage;

  DetailedUsageMapPage({required this.usage});

  @override
  _DetailedUsageMapPageState createState() => _DetailedUsageMapPageState();
}

class _DetailedUsageMapPageState extends State<DetailedUsageMapPage> {
  late KakaoMapController mapController;
  String? selectedMarkerId;
  Set<Marker> markers = {};
  late Polyline polyline;

  @override
  void initState() {
    super.initState();
    _setMarkersAndPolyline();
  }

  void _setMarkersAndPolyline() {
    setState(() {
      markers.add(Marker(
        markerId: 'start',
        latLng: widget.usage.path.first,
      ));

      markers.add(Marker(
        markerId: 'end',
        latLng: widget.usage.path.last,
      ));

      polyline = Polyline(
        polylineId: 'route',
        points: widget.usage.path,
        strokeColor: safeTgreen,
        strokeWidth: 5,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상세 이용 내역'),
        backgroundColor: Colors.white,
        centerTitle: true, 
        iconTheme: IconThemeData(color: safeTgreen),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          color: safeTlightgreen, // 카드 배경색 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 날짜와 닫기 버튼
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.usage.date,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // 지도와 경로 표시
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: KakaoMap(
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                    center: widget.usage.path.first,  // 경로의 시작점을 지도 중심으로 설정
                    markers: markers.toList(),
                    polylines: [polyline], // 경로 폴리라인 추가
                  ),
                ),
              ),
              // 주행 정보 표시
              Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('주행 시간: ${widget.usage.driveTime}', style: TextStyle(fontSize: 16)),
                  Text('대여장소: 위도: ${widget.usage.path.first.latitude}, 경도: ${widget.usage.path.first.longitude}', style: TextStyle(fontSize: 12)),
                  Text('반납장소: 위도: ${widget.usage.path.last.latitude}, 경도: ${widget.usage.path.last.longitude}', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

  void _showMarkerDetails(String title, LatLng position) {
    var context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('위치: ${position.latitude}, ${position.longitude}'),
          actions: [
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

