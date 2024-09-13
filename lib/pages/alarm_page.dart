import 'package:flutter/material.dart';
import 'package:safet/main.dart';

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
          '벌점 알림',
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
