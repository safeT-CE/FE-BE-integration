import 'package:flutter/material.dart';
import 'package:safet/models/user_info.dart';
import 'package:safet/main.dart';

class AuthDonePage extends StatelessWidget {
  final UserInfo userInfo;

  AuthDonePage({
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    //final UserInfo? userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo?;

    if (userInfo == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('인증 실패'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Text('사용자 정보를 가져오지 못했습니다.\n회원가입을 다시 시도해주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            Text(
              '회원 가입이\n완료 되었습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/image/level1.png',
              height: 100, // 이미지 크기
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9, // 가로 크기 조절
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: safeTlightgreen,
                borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 설정
              ),
              child: Table(
                columnWidths: {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                children: [
                  TableRow(
                    children: [
                      Text(
                        '이름:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${userInfo.name}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(height: 8), // 각 행 간격 조절
                      SizedBox(height: 8),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        '면허 종류:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${userInfo.licenseType}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        '생년월일:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${userInfo.dateOfBirth}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        '면허 번호:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${userInfo.licenseNumber}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        '면허 발급일:    ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '${userInfo.dateOfIssue}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: safeTgreen,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // Next button action
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  '확인',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
