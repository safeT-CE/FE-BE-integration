
class Penalty_detail {

  final int penaltyId;
  final String content;
  final DateTime date;
  final String photo;
  final int totalCount; // 벌점 누적 횟수
  final String location;  //
  final Map<String, double> map;  // 위도, 경도를 보내주면 그걸 바탕으로 지도맵 좌표점 찍어서 표시하는 거 추천
  final int detectionCount; // 한 번 감지할 때 감지한 횟수  //

  Penalty_detail({required this.penaltyId, required this.content, required this.date
          , required this.photo, required this.totalCount, required this.location, required this.map, required this.detectionCount});

    factory Penalty_detail.fromJson(Map<String, dynamic> json) {
      return Penalty_detail(
        penaltyId: json['penaltyId'] is int 
            ? json['penaltyId'] 
            : int.tryParse(json['penaltyId']?.toString() ?? '0') ?? 0, // Null 체크 및 기본값 설정
        content: json['content'] ?? '', // 기본값 설정
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(), // Null 체크 및 기본값 설정
        photo: json['photo'] ?? '', // 기본값 설정
        totalCount: json['totalCount'] is int 
            ? json['totalCount'] 
            : int.tryParse(json['totalCount']?.toString() ?? '0') ?? 0, // Null 체크 및 기본값 설정
        location: json['location'] ?? '', // 기본값 설정
        detectionCount: json['detectionCount'] is int 
            ? json['detectionCount'] 
            : int.tryParse(json['detectionCount']?.toString() ?? '0') ?? 0, // Null 체크 및 기본값 설정
        map: json['map'] != null && json['map'] is Map<String, dynamic> 
            ? {
                'latitude': json['map']['latitude']?.toDouble() ?? 0.0,
                'longitude': json['map']['longitude']?.toDouble() ?? 0.0,
              }
            : {}, // Map이 null인 경우 빈 맵으로 설정
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