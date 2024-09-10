import 'package:flutter/material.dart';
import 'package:safet/main.dart';

import 'package:safet/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AnnouncementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: safeTgreen),
        title: Text(
          '공지사항',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: AnnouncementList(),
    );
  }
}

class AnnouncementList extends StatefulWidget {
  @override
  _AnnouncementListState createState() => _AnnouncementListState();
}

// 
class _AnnouncementListState extends State<AnnouncementList> {
  List<dynamic> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    final url = Uri.parse('${baseUrl}notices');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
            announcements = data..sort((a, b) {
            DateTime dateA = DateTime.parse(a['createdAt']);
            DateTime dateB = DateTime.parse(b['createdAt']);
            return dateB.compareTo(dateA);  // 최신순
          });
          isLoading = false; // 데이터 로딩 완료 후 상태 변경
        });
      } else {
        throw Exception('Failed to load announcements');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시
        : ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];

              // DateTime을 String으로 포맷
              DateTime createdAt = DateTime.parse(announcement['createdAt']);
              String createdDate = DateFormat('yyyy.MM.dd').format(createdAt);

              DateTime updatedAt = DateTime.parse(announcement['updatedAt']);
              String updatedDate = DateFormat('yyyy.MM.dd').format(updatedAt);
              

              return AnnouncementTile(
                id: announcement['id'],
                title: announcement['title'],
                content: announcement['content'],
                createdAt: createdDate,
                updatedAt: updatedDate  // 포맷된 날짜 전달
              );
            },
          );
  }
}

class AnnouncementTile extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  AnnouncementTile({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          color: safeTblack,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        createdAt,
        style: TextStyle(color: safeTgray),
      ),
      iconColor: safeTlightgreen,
      collapsedIconColor: safeTlightgreen,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content),
        ),
      ],
      shape: Border(
        top: BorderSide(color: Colors.white),
        bottom: BorderSide(color: safeTlightgreen),
      ),
      collapsedShape: Border(
        top: BorderSide(color: Colors.white),
        bottom: BorderSide(color: safeTlightgreen),
      ),
    );
  }
}
