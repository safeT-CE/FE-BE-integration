

class ProfileResponse {
  final String phone;
  final String grade;
  final int point;
  final Duration useTime;

  ProfileResponse({
    required this.phone,
    required this.grade,
    required this.point,
    required this.useTime,
  });

  // JSON 데이터를 ProfileResponse 객체로 변환하는 factory constructor
  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      phone: json['phone'],
      grade: json['grade'],
      point: json['point'],
      useTime: _parseDuration(json['useTime']),  // 시간 데이터를 Duration으로 변환
    );
  }

  // 서버에서 받은 시간 데이터를 Duration으로 변환
  static Duration _parseDuration(String timeString) {
    List<String> parts = timeString.split(':');
    if (parts.length == 3) {
      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(parts[2]),
      );
    } else {
      throw FormatException('Invalid time format');
    }
  }
}