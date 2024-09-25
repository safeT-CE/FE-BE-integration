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
  
/* 추가(주석지우기)
// 로컬 데이터를 처리하는 생성자 (useTime을 String에서 변환)
  factory HomeData.fromLocal(String useTimeString, {String? phone, String? grade}) {
    Duration? useTime = _parseTime(useTimeString);  // String -> Duration 변환
    return HomeData(
      phone: phone,
      grade: grade,
      useTime: useTime,
    );
  }*/
  
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

/* 추가 (주석지우기)
   // Duration을 포맷팅하여 출력하는 메서드 (HH:mm:ss 형식)
  String getFormattedUseTime() {
    if (useTime == null) return '00:00:00'; // 기본값
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(useTime!.inHours);
    String minutes = twoDigits(useTime!.inMinutes.remainder(60));
    String seconds = twoDigits(useTime!.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
*/
