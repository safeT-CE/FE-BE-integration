import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:safet/pages/detailed_usage_map_page.dart';
import 'package:safet/models/detailed_usage_data.dart';
import 'package:safet/back/detail.dart';
import 'package:safet/main.dart';

class DetailedUsagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('상세 이용 내역'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          iconTheme: IconThemeData(color: safeTgreen),
          elevation: 0,
        ),
        body: FutureBuilder<List<DetailedUsage>?>(
          future: getDetailedUsagePage(), // 서버 데이터 요청
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // 로딩 중일 때
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}'); // 에러 로그 출력
              return Center(child: Text('데이터를 불러오지 못했습니다.')); // 에러 발생 시
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('조회할 데이터가 없습니다.')); // 데이터가 없을 때
            }

            final detailedUsageList = snapshot.data!; // 데이터 목록 가져오기

            return ListView.builder(
              itemCount: detailedUsageList.length,
              itemBuilder: (context, index) {
                final usage = detailedUsageList[index];
                return Card(
                  color: safeTlightgreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 날짜 정보와 주행 거리 정보
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              usage.date,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // 지도 표시
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            height: 150,
                            child: KakaoMap(
                              onMapCreated: (controller) {
                                // 필요시 mapController 저장
                              },
                              center: LatLng(usage.latitude, usage.longitude),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 확인하기 버튼
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailedUsageMapPage(usage: usage),
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
                          child: const Text(
                            '확인하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}