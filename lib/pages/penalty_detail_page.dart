import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';  // 날짜
import 'package:kakao_map_plugin/kakao_map_plugin.dart'; // Kakao Map 패키지 추가
import 'package:safet/main.dart';
import 'package:safet/models/inquiry_check_data.dart';
import 'package:safet/utils/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:safet/models/penalty_detail.dart';
import 'one_on_one_inquiry_page.dart';

class PenaltyDetailPage extends StatelessWidget {
  final int penaltyId;

  const PenaltyDetailPage({super.key, required this.penaltyId});
  
  Future<PenaltyDetailResponse> fetchPenaltyDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final response = await http.get(
      Uri.parse('${baseUrl}penalty/check/detail?userId=$userId&penaltyId=$penaltyId'));
    
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    
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
              centerTitle: true,
              elevation: 0,
              iconTheme: IconThemeData(color: safeTgreen),
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
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: safeTgreen),
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
                          // 위반 제목과 닫기 버튼
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                penalty.content,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(), // 구분선 추가
                          const SizedBox(height: 16),
                          
                          // 날짜 정보
                          Text(
                            '위반 날짜: ${formattedDate}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          // 시간 정보
                          Row(
                            children: [
                              Icon(Icons.add_circle, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '누적 횟수: ${penalty.totalCount}회',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // 위치 정보
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${penalty.location}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(), // 구분선 추가
                          const SizedBox(height: 16),

                          // 지도 표시
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              height: 200, // 지도 높이 설정
                              child: KakaoMap(
                                onMapCreated: (controller) {
                                  // 필요시 mapController 저장
                                },
                                center: LatLng(
                                  penalty.map['latitude'] ?? 0.0,
                                  penalty.map['longitude'] ?? 0.0,
                                ), // 쉼표 누락 수정
                                markers: [
                                  Marker(
                                    markerId: UniqueKey().toString(),
                                    latLng: LatLng(
                                      penalty.map['latitude'] ?? 0.0, // null-safe 확인
                                      penalty.map['longitude'] ?? 0.0, // null-safe 확인
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          Divider(), // 구분선 추가
                          const SizedBox(height: 16),

                          // 이미지 표시
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

                          Divider(), // 구분선 추가
                          const SizedBox(height: 16),

                          // 삭제 안내 문구
                          Text(
                            '본 기록은 30일 후 자동으로 삭제됩니다.\n기록 삭제와 동시에 알림도 전송됩니다.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),

                          // 문의하기 버튼
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OneOnOneInquiryPage(
                                    initialCategory: Category.penalty,
                                    initialTitle: penalty.content,
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
