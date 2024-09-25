import 'package:flutter/foundation.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class DetailedUsage {
  final String date;           // 이용 날짜
  final String driveTime;      // 주행 시간
  final double latitude;
  final double longitude;
  final List<LatLng> path;

  DetailedUsage({
    required this.date,
    required this.driveTime,
    required this.latitude,
    required this.longitude,
    required this.path,
  });
}

class DetailedUsageData extends ChangeNotifier {
  List<DetailedUsage> _usages = [
    DetailedUsage(
      date: '2024-08-10',
      driveTime: '30분',
      latitude: 37.5665, // 서울시청 위도
      longitude: 126.9780, // 서울시청 경도
      path: [
        LatLng(37.5665, 126.9780), // 시작점
        LatLng(37.5651, 126.9895), // 끝점
      ],
    ),
    DetailedUsage(
      date: '2024-08-11',
      driveTime: '15분',
      latitude: 37.5663, // 명동 위도
      longitude: 126.9826, // 명동 경도
      path: [
        LatLng(37.5663, 126.9826), // 시작점
        LatLng(37.5663, 126.9913), // 끝점
      ],
    ),
  ];


  List<DetailedUsage> get usages => _usages;

  void addUsage(DetailedUsage usage) {
    _usages.add(usage);
    notifyListeners();
  }
}
