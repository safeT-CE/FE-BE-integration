import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safet/main.dart';

import 'detailed_usage_data.dart';
import 'detailed_usage_map_page.dart';

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
          title: Text('상세 이용 정보'),
          backgroundColor: safeTgreen,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '이용 내역',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: detailedUsageData.usages.length,
                  itemBuilder: (context, index) {
                    final usage = detailedUsageData.usages[index];
                    return Card(
                      color: safeTlightgreen,  // 카드의 배경색
                      child: ListTile(
                        leading: Image.asset(
                          usage.imagePath,  // 이미지 경로
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text('${usage.date} - ${usage.driveTime}'),
                        subtitle: Text('주행 거리: ${usage.driveDistance} km'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedUsageMapPage(usage: usage),
                            ),
                          );
                        },
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