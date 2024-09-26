import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class DetailedUsage {
  final int id;
  final String date;           // 이용 날짜
  final int driveTime;      // 주행 시간
  final double latitude;    // 빌린 장소
  final double longitude;
  final List<LatLng> path;  // 빌린 장소, 반납 장소
  final String rentalAddress;
  final String returnAddress;

  DetailedUsage({
    required this.id,
    required this.date,
    required this.driveTime,
    required this.latitude,
    required this.longitude,
    required this.path,
    required this.rentalAddress,
    required this.returnAddress
  });

  factory DetailedUsage.fromJson(Map<String, dynamic> json) {
    return DetailedUsage(
      id: json['id'],
      date: json['rentedAt'],
      driveTime: json['duration'],
      latitude: json['rentalLocation']['latitude'],
      longitude: json['rentalLocation']['longitude'],
      path: [
                LatLng(json['rentalLocation']['latitude']?.toDouble() ?? 0.0,
                json['rentalLocation']['longitude']?.toDouble() ?? 0.0),
                LatLng(json['returnLocation']['latitude']?.toDouble() ?? 0.0,
                json['returnLocation']['longitude']?.toDouble() ?? 0.0)
      ],
      rentalAddress: json['rentalAddress'],
      returnAddress: json['returnAddress']
    );
  }
}