

class ProfileData {
  final String phone;
  final String grade;
  final int point;
  final Duration? useTime;

  ProfileData({
    required this.phone,
    required this.grade,
    required this.point,
    required this.useTime,
  });

  // JSON 데이터를 ProfileResponse 객체로 변환하는 factory constructor
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      phone: json['phone'],
      grade: json['grade'],
      point: json['point'],
      useTime: _parseTime(json['useTime']),
    );
  }

  // Dart 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'grade': grade,
      'point' : point,
      'useTime': _durationToString(useTime), // Duration을 String으로 변환
    };
  }

  // useTime을 Duration으로 변환하는 헬퍼 메서드
  static Duration? _parseTime(String? timeString) {
    if (timeString == null) return null;
    final parts = timeString.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1])
    );
  }

  // Duration을 String으로 변환하는 메서드
  static String _durationToString(Duration? duration) {
    if (duration == null) return '00:00:00'; // 기본값 설정
    return duration.inHours.toString().padLeft(2, '0') + ':' +
    (duration.inMinutes.remainder(60)).toString().padLeft(2, '0') + ':00';
  }
}