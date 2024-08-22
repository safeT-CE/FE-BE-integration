import 'package:flutter/material.dart';
import 'package:safet/main.dart';

import 'one_on_one_inquiry_page.dart';
import 'violation_data.dart';
import '../models/penalty_detail.dart';
import '../utils/penalty_data.dart';
import 'package:intl/intl.dart';  // 날짜

// backend 연동 중 추가
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/penalty_data.dart';
import '../models/penalty_detail.dart';

class PenaltyDetailPage extends StatelessWidget {
  final int penaltyId;

  const PenaltyDetailPage({super.key, required this.penaltyId});
  
  Future<PenaltyDetailResponse> fetchPenaltyDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final response = await http.get(Uri.parse('http://192.168.219.103:8080/penalty/check/detail?userId=$userId&penaltyId=$penaltyId'));
    print(penaltyId);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if(response.statusCode == 200){
      // server response ok -> json data decoding
      return PenaltyDetailResponse.fromJson(json.decode(response.body));
      } else {
        // server response error
        throw Exception('Failed to load penalty details');
      }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PenaltyDetailResponse>(
      future: fetchPenaltyDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('벌점 상세'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: const Center(child: CircularProgressIndicator()),  // 로딩 스피너
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('벌점 상세'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final PenaltyDetailResponse response = snapshot.data!;
          final Penalty_detail penalty = response.penalty.first; // Assuming you only want the first item
          
          String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(penalty.date);

          return Theme(
            data: Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.white,
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('벌점 상세'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 4,
                    color: safeTlightgreen,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                penalty.content,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '위반 날짜: ${formattedDate}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '위반 위치: ${penalty.location}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '누적 횟수: ${penalty.totalCount}회',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              penalty.photo,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '본 기록은 7일 후 자동으로 삭제됩니다.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OneOnOneInquiryPage(
                                    initialCategory: '벌점',
                                    initialTitle: penalty.content,
                                    fromPenaltyDate: formattedDate,
                                    imagePath: penalty.photo,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: safeTgreen,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 0,
                            ),
                            child: const Center(
                              child: Text(
                                '문의하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('벌점 상세'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: const Center(child: Text('No data available')),
          );
        }
      },
    );
  }
}