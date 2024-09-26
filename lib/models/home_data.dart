class HomeData {
  String? phone;
  String? grade;
  String? useTime; // Duration으로 사용하여 시와 분을 관리

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
      useTime: json['useTime'],
    );
  }
  
  // Dart 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'grade': grade,
      'useTime': useTime,
    };
  }
}
