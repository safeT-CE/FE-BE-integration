class ProfileData {
  final String phone;
  final String grade;
  final int point;
  final String useTime;

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
      useTime: json['useTime'],
    );
  }

  // Dart 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'grade': grade,
      'point' : point,
      'useTime': useTime
    };
  }
}