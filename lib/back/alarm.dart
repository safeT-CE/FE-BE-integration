import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse_client/sse_client.dart';
import 'package:safet/utils/constants.dart';


class SseService {
  SseClient? _sseClient; // Nullable로 선언
  Function(String)? _inquiryNotificationCallback; // 알림 콜백 저장할 변수

  // SSE 서버에 연결하는 메서드
  Future<void> connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    // userId가 null인지 확인
    if (userId != null) {
      try {
        // 서버의 SSE 엔드포인트로 연결
        _sseClient = SseClient.connect(Uri.parse('${baseUrl}notifications/subscribe/$userId'));

        // SSE에서 메시지를 받을 때마다 처리
        final stream = _sseClient?.stream;
        if (stream != null) {
          stream.listen((event) {
            print("Received SSE event: $event");


            // 이벤트 이름이나 데이터에 따라 다르게 처리
            if (event.contains('penalty')) {
              _handlePenaltyNotification(event);
            } else if (event.contains('inquiry')) {
              if (_inquiryNotificationCallback != null) {
                //print("Penalty Notification Comment2: ${event.comment}");
                _inquiryNotificationCallback!(event); // 콜백 호출
              }
            }
          });
        } else {
          print("SSE Client stream is null.");
        }
      } catch (e) {
        print("Failed to connect to SSE: $e");
      }
    } else {
      print("User ID not found in SharedPreferences.");
    }
  }

  // SSE 연결 해제 메서드
  void disconnect() {
    if (_sseClient != null) {
      print("sseClient null");
      //_sseClient!.close();
    }
  }

  // 패널티 알림 처리
  void _handlePenaltyNotification(String event) {
    print("Penalty Notification: $event");
  }

  // 문의 알림 콜백 설정
  void setInquiryNotificationCallback(void Function(String) callback) {
    
    _inquiryNotificationCallback = callback; // 콜백 변수에 값 설정
  }
}