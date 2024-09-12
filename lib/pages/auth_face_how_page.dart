import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:safet/models/user_info.dart';
import 'package:safet/main.dart'; // 다른 필요한 패키지들도 import
import 'package:safet/pages/auth_face_cam_page.dart';

class FaceHowPage extends StatefulWidget {
  final UserInfo userInfo;
  final File licenseImage;

  FaceHowPage({required this.userInfo, required this.licenseImage});

  @override
  _FaceHowPageState createState() => _FaceHowPageState();
}

class _FaceHowPageState extends State<FaceHowPage> {
  CameraDescription? firstCamera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    setState(() {
      // 첫 번째 카메라를 'firstCamera'로 설정
      firstCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //final UserInfo userInfo = ModalRoute.of(context)!.settings.arguments as UserInfo;

    // 디버깅 메시지 출력
    print('FaceHowPage - UserInfo received: ${widget.userInfo.toString()}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: safeTgray),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '신분증 사진과 비교하여 \n본인 여부를 확인합니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            Image.asset(
              'assets/image/auth_selfie.png',
              width: 200,
            ),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF0B0B0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.yellow),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '마스크, 선글라스 등 신분증 사진 촬영 당시\n착용하지 않았던 악세서리를 착용할 경우,\n식별이 어려울 수 있습니다.\n반드시 벗은 후 진행해 주세요.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: safeTgreen,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                if (firstCamera != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FaceCamPage(
                        frontCamera: firstCamera!, // 'frontCamera'에 'firstCamera' 전달
                        userInfo: widget.userInfo,
                        licenseImage: widget.licenseImage,
                      ),
                    ),
                  );
                } else {
                  // 카메라가 초기화되지 않은 경우 처리
                  print('카메라를 사용할 수 없습니다.');
                }
              },
              child: Text(
                '다음',
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
