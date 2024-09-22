import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import 'package:safet/pages/detailed_usage_map_page.dart';

import '../main.dart';
import '../models/detailed_usage_data.dart';

class DetailedUsagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detailedUsageData = Provider.of<DetailedUsageData>(context);
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: detailedUsageData.usages.length,
                  itemBuilder: (context, index) {
                    final usage = detailedUsageData.usages[index];
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
                                Text(
                                  '${usage.driveTime} - ${usage.driveDistance} km',
                                  style: TextStyle(
                                    fontSize: 16,
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
                                  markers: [
                                    Marker(
                                      markerId: UniqueKey().toString(),
                                      latLng: LatLng(usage.latitude, usage.longitude),
                                    ),
                                  ],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
