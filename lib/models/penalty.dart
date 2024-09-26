
class Penalty {

  final int penaltyId;
  final String content;
  final DateTime date;
  final String photo;
  final int totalCount; // 벌점 누적 횟수
  final Map<String, double> map;  // 위도, 경도
  
  Penalty({required this.penaltyId, required this.content, required this.date
          , required this.photo, required this.totalCount, required this.map});

  factory Penalty.fromJson(Map<String, dynamic> json) {
    return Penalty(
      penaltyId : json['penaltyId'] ?? '',
      content : json['content'] ?? '',
      date: DateTime.parse(json['date']),
      photo : json['photo'] ?? '',
      totalCount: json['totalCount'] ?? 0, // 기본값 0으로 설정
      map: (json['map'] != null && json['map'] is Map<String, dynamic>) 
        ? {
            'latitude': json['map']['latitude']?.toDouble() ?? 0.0,
            'longitude': json['map']['longitude']?.toDouble() ?? 0.0,
          } 
        : {'latitude': 0.0, 'longitude': 0.0}, // map이 null인 경우 빈 맵으로 설정
    );
  }
}
