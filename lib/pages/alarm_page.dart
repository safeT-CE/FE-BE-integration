import 'package:flutter/material.dart';
import 'package:safet/back/alarm.dart';  // 방금 작성한 SSE 서비스 파일을 가져옴
//
void main() {
  runApp(MaterialApp(
    home: MyApp()
  )); // MyApp을 실행합니다.
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Home Page')),
    );
  }
}

// AlarmPage를 StatefulWidget으로 변경
class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late SseService _sseService;
  String _inquiryNotification = ''; // 알림 메시지를 저장할 변수

  @override
  void initState() {
    super.initState();
    _sseService = SseService();

    // 유저 아이디를 이용해 SSE 서버에 연결
    _sseService.connect();

     // 알림 처리 메소드를 전달
    _sseService.setInquiryNotificationCallback(_handleInquiryNotification); //
  }

  @override
  void dispose() {
    _sseService.disconnect();
    super.dispose();
  }

  // 문의 알림 처리
  void _handleInquiryNotification(String event) {
    // 상태 업데이트하여 화면에 반영
    setState(() {
      _inquiryNotification = "Inquiry Notification: $event";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SSE Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Listening for notifications...'),
            SizedBox(height: 20),
            // 문의 알림 메시지를 화면에 표시
            Text(_inquiryNotification),
          ],
        ),),
    );
  }
}