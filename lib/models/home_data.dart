class HomeData {
  String? phone;
  String? grade;
  Duration? useTime; // Duration으로 사용하여 시와 분을 관리

  HomeData({
    this.phone,
    this.grade,
    this.useTime,
  });

  // JSON 데이터를 Dart 객체로 변환하는 생성자
  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      phone: json['phone'],
      grade: json['grade'],
      useTime: _parseTime(json['useTime']), // String을 Duration으로 변환
    );
  }

  // Dart 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'grade': grade,
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