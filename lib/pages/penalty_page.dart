import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import '../main.dart';
import '../models/penalty.dart';
import '../utils/penalty_data.dart';
import 'penalty_detail_page.dart';

class PenaltyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('벌점 기록'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: safeTgreen),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Penalty>>(
            future: fetchPenalties(), // 변경된 함수명
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('현재 데이터가 없습니다.'));
              } else {
                final penalties = snapshot.data!; // 변경된 변수명
                
                return ListView.builder(
                  itemCount: penalties.length,
                  itemBuilder: (context, index) {
                    final penalty = penalties[index]; // 변경된 변수명
                    print(penalty.photo);
                    // 날짜를 포맷팅
                    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(penalty.date);

                                        return Card(
                      color: safeTlightgreen,//맞는지 확인 필
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PenaltyDetailPage(penaltyId: penalty.penaltyId),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    penalty.content,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '누적 ${penalty.totalCount}회',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 200,
                                child: KakaoMap(
                                  onMapCreated: (controller) {
                                    controller.addMarker(
                                      /*Marker(
                                        markerId: 'penalty_marker_$index',
                                        latLng: LatLng(
                                          penalty.map['latitude'] ?? 0.0,
                                          penalty.map['longitude'] ?? 0.0,
                                        ),
                                      ),
                                      */
                                    );
                                  },
                                  center: LatLng(
                                    penalty.map['latitude'] ?? 0.0,
                                    penalty.map['longitude'] ?? 0.0,
                                  ),
                                  maxLevel: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PenaltyDetailPage(
                                        penaltyId: penalty.penaltyId,
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
                                child: Center(
                                  child: Text(
                                    '확인하기',
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
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
