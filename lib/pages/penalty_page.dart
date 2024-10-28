import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:safet/back/penalty_data.dart';
import 'package:safet/models/penalty.dart';
import 'package:flutter/material.dart';
import 'penalty_detail_page.dart';
import 'package:safet/main.dart';
import 'package:intl/intl.dart';

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
            future: fetchPenalties(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('현재 데이터가 없습니다.'));
              } else {
                final penalties = snapshot.data!;

                return ListView.builder(
                  itemCount: penalties.length,
                  itemBuilder: (context, index) {
                    final penalty = penalties[index];

                    // 날짜를 포맷팅
                    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(penalty.date);
                    penalties.sort((a, b) => b.date.compareTo(a.date)); // 내림차순 정렬

                    return Card(
                      color: safeTlightgreen,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PenaltyDetailPage(penaltyId: penalty.penaltyId),
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
                                ],
                              ),
                              SizedBox(height: 4),
                              // 날짜와 누적 횟수
                              Row(
                                children: [
                                  // 날짜
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // Spacer로 날짜와 누적 횟수 사이 간격 추가
                                  Spacer(),
                                  // 누적 횟수
                                  Text(
                                    '누적 ${penalty.totalCount}회',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 200,
                                child: KakaoMap(
                                  onMapCreated: (controller) {
                                    controller.addMarker(
                                      // marker 추가 생략
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
                                      builder: (context) => PenaltyDetailPage(
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
