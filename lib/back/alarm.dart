/*
import 'package:safet/main.dart';
import 'package:flutter/material.dart';

import 'package:safet/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // jsonDecode를 사용하기 위해 import
import 'package:shared_preferences/shared_preferences.dart';

// 해결 중인 코드

void main() {
  runApp(MaterialApp(
    home: MyApp()
    )); // MyApp을 실행합니다.
}

class MyApp extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인 페이지'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('메인 페이지 내용'),
      ),
    );
  }
}

class AlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '벌점 알림',
          style: TextStyle(color: Colors.black),
        ),
          centerTitle: true,
          iconTheme: IconThemeData(color: safeTgreen),
          elevation: 0,
      ),
      backgroundColor: Colors.white,
      
      body: AlarmList(),
    );
  }
}

class AlarmList extends StatefulWidget {
  @override
  _AlarmListState createState() => _AlarmListState();
  // @override
  // _MyAppState createState() => _MyAppState(); // 상태 클래스를 올바르게 참조
}


class _AlarmListState extends State<AlarmList> {
  late final Stream<String> _stream;

  @override
  void initState() {
    super.initState();
    final sseService = SseService();
    _stream = sseService.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SSE Example')),
      body: StreamBuilder<String>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data received.'));
          }

          // 이벤트 데이터를 화면에 표시
          return ListView(
            children: [
              ListTile(title: Text(snapshot.data!)),
            ],
          );
        },
      ),
    );
  }
}

class SseService {
  Stream<String> subscribe() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final uri = Uri.parse('${baseUrl}subscribe/$userId');
    final response = await http.Client().send(http.Request('GET', uri));

    await for (final line in response.stream.transform(utf8.decoder).transform(LineSplitter())) {
      yield line; // 각 이벤트를 스트림으로 전달
    }
  }
}*/