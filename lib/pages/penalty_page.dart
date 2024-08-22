import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/penalty.dart';
import '../utils/penalty_data.dart';
import 'penalty_detail_page.dart';
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
                      color: Colors.lightGreenAccent, // `safeTlightgreen` 색상 값으로 수정
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: penalty.photo.isNotEmpty
                            ? Image.network(
                                penalty.photo, // 서버에서 받아온 이미지 URL을 사용
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image, size: 50), // 이미지가 없는 경우 기본 아이콘 표시
                        title: Text(penalty.content), // 변경된 변수명
                        subtitle: Text(formattedDate), // 변경된 변수명
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PenaltyDetailPage(penaltyId: penalty.penaltyId), // 변경된 변수명
                            ),
                          );
                        },
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


// http://192.168.219.102:8080/penalty/check/summary
//class PenaltyPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final violationData = Provider.of<ViolationData>(context);
//     return Theme(
//       data: Theme.of(context).copyWith(
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('벌점 기록'),
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//         ),
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 '',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: violationData.violations.length,
//                   itemBuilder: (context, index) {
//                     final violation = violationData.violations[index];
//                     return Card(
//                       color: safeTlightgreen, // Card 배경색을 흰색으로 설정
//                       child: ListTile(
//                         leading: Image.asset(
//                           violation.imagePath,
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         ),
//                         title: Text(violation.title),
//                         subtitle: Text(violation.date),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PenaltyDetailPage(violation: violation),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
