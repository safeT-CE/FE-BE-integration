import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:safet/main.dart';

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:safet/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IdentificationPage extends StatefulWidget {
  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  late CameraController _controller;
  bool isCameraInitialized = false;
  late XFile faceImage; // 얼굴 이미지를 저장할 변수

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // 카메라 초기화 메서드
  void _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
      _controller = CameraController(frontCamera, ResolutionPreset.medium);
      await _controller.initialize();
      if (!mounted) return;
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  // 사진 촬영 및 서버로 전송 메서드
  Future<void> _captureAndSendImage() async {
    try {
      // 얼굴 사진 촬영
      final faceImage = await _controller.takePicture();

      // 서버로 이미지 전송
      await _sendImageToServer(faceImage);
    } catch (e) {
      print('Error capturing image: $e');
      _showErrorDialog(context);
    }
  }

  // 서버로 이미지 전송 메서드
  Future<void> _sendImageToServer(XFile image) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      print('저장된 사용자 ID: $userId');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}kickboard/rent/identify'),
      );

      // 사용자 아이디 추가
      request.fields['userId'] = userId ?? '';

      var faceImageStream = http.ByteStream(image.openRead());
      var faceImageLength = await image.length();

      request.files.add(
        http.MultipartFile(
          'faceImage',
          faceImageStream,
          faceImageLength,
          filename: p.basename(image.path),
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        Navigator.pop(context, true); // 동일인 판별이 성공하면 true 반환
      } else {
        print('Failed to upload image');
        _showErrorDialog(context);
      }
    } catch (e) {
      print('Error sending image to server: $e');
      _showErrorDialog(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,  // 배경색을 투명하게 설정
      body: isCameraInitialized
          ? Stack(
              children: <Widget>[
                SizedBox.expand(  // 카메라 프리뷰를 전체 화면으로 확장
                  child: CameraPreview(_controller), // 카메라 프리뷰
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 100,
                  child: Column(
                    children: [
                      Text(
                        '얼굴을 영역 안에 맞추고\n촬영해 주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // 텍스트 색상
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _captureAndSendImage(); // 사진 촬영 및 서버로 전송
                      },
                      child: Text('다음'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // 텍스트 색상
                        backgroundColor: safeTgreen, // 버튼 배경 색상
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()), // 카메라 초기화 중 로딩 표시
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('얼굴 인식 실패'),
          content: Text('얼굴이 인식되지 않았습니다. 다시 시도해 주세요.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


// class IdentificationPage extends StatefulWidget {
//   @override
//   _IdentificationPageState createState() => _IdentificationPageState();
// }

// class _IdentificationPageState extends State<IdentificationPage> {
//   late CameraController _controller;
//   bool isCameraInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   // 카메라 초기화 메서드
//   void _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final frontCamera = cameras.firstWhere(
//           (camera) => camera.lensDirection == CameraLensDirection.front);
//       _controller = CameraController(frontCamera, ResolutionPreset.medium);
//       await _controller.initialize();
//       if (!mounted) return;
//       setState(() {
//         isCameraInitialized = true;
//       });
//     } catch (e) {
//       print('Error initializing camera: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,  // 배경색을 투명하게 설정
//       body: isCameraInitialized
//           ? Stack(
//               children: <Widget>[
//                  SizedBox.expand(  // 카메라 프리뷰를 전체 화면으로 확장
//                 child: CameraPreview(_controller), // 카메라 프리뷰
//               ), // 카메라 프리뷰
//                 Positioned(
//                   left: 0,
//                   right: 0,
//                   top: 100,
//                   child: Column(
//                     children: [
//                       Text(
//                         '얼굴을 영역 안에 맞추고\n촬영해 주세요.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white, // 텍스트 색상
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       Container(
//                         width: 250,
//                         height: 250,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.red, width: 2),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 16,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         // 동일인 판별 로직을 추가
//                         Navigator.pop(context,false); // 동일인 판별이 성공하면 true 반환
//                       },
//                       child: Text('다음'),
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white, // 텍스트 색상
//                         backgroundColor: safeTgreen, // 버튼 배경 색상
//                         padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : Center(child: CircularProgressIndicator()), // 카메라 초기화 중 로딩 표시
//     );
//   }

//   void _showErrorDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('얼굴 인식 실패'),
//           content: Text('얼굴이 인식되지 않았습니다. 다시 시도해 주세요.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('확인'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
