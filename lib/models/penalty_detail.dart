
class Penalty_detail {

  final int penaltyId;
  final String content;
  final DateTime date;
  final String photo;
  final int totalCount; // 벌점 누적 횟수
  final String location;  //
  final Map<String, double> map;
  final int detectionCount;

  Penalty_detail({
    required this.penaltyId, 
    required this.content, 
    required this.date, 
    required this.photo,
    required this.totalCount, 
    required this.location, 
    required this.map, 
    required this.detectionCount
  });

    factory Penalty_detail.fromJson(Map<String, dynamic> json) {
      return Penalty_detail(
        penaltyId: json['penaltyId'] ?? 0,
        content: json['content'] ?? '',
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        photo: json['photo'] ?? '',
        totalCount: json['totalCount'] ?? 0,
        location: json['location'] ?? '',
        detectionCount: json['detectionCount'] ?? 0,
        map: json['map'] != null && json['map'] is Map<String, dynamic> 
            ? {
                'latitude': json['map']['latitude']?.toDouble() ?? 0.0,
                'longitude': json['map']['longitude']?.toDouble() ?? 0.0,
              }
            : {}, // Map이 null인 경우
      );
    }     
}

class PenaltyDetailResponse {
  final List<Penalty_detail> penalty;
  final String message;

  PenaltyDetailResponse({
    required this.penalty,
    required this.message,
  });

  factory PenaltyDetailResponse.fromJson(Map<String, dynamic> json) {
    return PenaltyDetailResponse(
      penalty: (json['penalty'] as List)
          .map((item) => Penalty_detail.fromJson(item))
          .toList(),
      message: json['message'],
    );
  }
}