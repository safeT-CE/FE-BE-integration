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

// MyApp은 StatefulWidget이므로 상태를 반환하는 createState를 구현해야 합니다.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// 상태 관리 클래스인 _MyAppState에서 build 메서드를 구현합니다.
class _MyAppState extends State<MyApp> {
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
          '알림 내역',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.green),
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
}

class _AlarmListState extends State<AlarmList> {
  late final Stream<String> _stream;

  @override
  void initState() {
    super.initState();
    final sseService = SseService();
    _stream = sseService.subscribe().asBroadcastStream(); // BroadcastStream 사용

    _stream.listen((data) {
      setState(() {
        notifications.add(data); // 수신한 데이터를 리스트에 추가
      });
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   final sseService = SseService();
  //   _stream = sseService.subscribe();
  // }

  List<String> notifications = [];
  
  // @override
  // Widget build(BuildContext context) {
  //   return ListView.builder(
  //     itemCount: notifications.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(title: Text(notifications[index]));
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SSE Example')),
      body: StreamBuilder<String>(
        stream: _stream,
        builder: (context, snapshot) {
          print('Snapshot data: ${snapshot.data}');
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

    final uri = Uri.parse('${baseUrl}notifications/subscribe/$userId');
    final response = await http.Client().send(http.Request('GET', uri));

    if (response.statusCode == 200) {
      print("SSE 연결 성공");
    } else {
      print("SSE 연결 실패: ${response.statusCode}");
    }

    await for (final line in response.stream.transform(utf8.decoder).transform(LineSplitter())) {
      print("수신한 데이터: $line");
      yield line; // 각 이벤트를 스트림으로 전달
    }
  }
}


/*
void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
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
          '알림',
          style: TextStyle(color: Colors.black),
        ),
          centerTitle: true,
          iconTheme: IconThemeData(color: safeTgreen),
          elevation: 0,
      ),
      backgroundColor: Colors.white,
      
      body: PenaltyList(),
    );
  }
}

class PenaltyList extends StatefulWidget {
  @override
  _PenaltyListState createState() => _PenaltyListState();
}

class _PenaltyListState extends State<PenaltyList> {
  final List<Map<String, String>> penalties = [
    {
      'title': '헬멧 미착용',
      'date': '2024.07.01',
      'content': '헬멧을 착용하지 않아 누적 벌점 1회가 부여되었습니다.'
    },
    {
      'title': '2인 이상 탑승',
      'date': '2024.06.15',
      'content': '2인 이상 탑승으로 인해 누적 벌점 2회가 부여되었습니다.'
    },
    {
      'title': '불법 주정차',
      'date': '2024.05.20',
      'content': '불법 주정차로 인해 누적 벌점 1회가 부여되었습니다.'
    },
    {
      'title': '안전 수칙 미준수',
      'date': '2024.04.30',
      'content': '안전 수칙을 준수하지 않아 누적 벌점 1회가 부여되었습니다.'
    },
    {
      'title': '과속 운행',
      'date': '2024.03.15',
      'content': '과속 운행으로 인해 누적 벌점 2회가 부여되었습니다.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: penalties.length,
      itemBuilder: (context, index) {
        final penalty = penalties[index];
        return PenaltyTile(
          title: penalty['title']!,
          date: penalty['date']!,
          content: penalty['content']!,
        );
      },
    );
  }
}

class PenaltyTile extends StatelessWidget {
  final String title;
  final String date;
  final String content;

  PenaltyTile({
    required this.title,
    required this.date,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          color: safeTgreen,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(date),
      iconColor: safeTgreen,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content),
        ),
      ],
    );
  }
}
*/