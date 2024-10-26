import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:safet/main.dart';
import 'package:safet/pages/auth_done_page.dart';
import 'package:safet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';


class IdentificationPage extends StatefulWidget {
  final CameraDescription frontCamera;

  IdentificationPage({required this.frontCamera});

  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  late CameraController _controller;
  late Future<void> _initializeCameraFuture;// = _initializeCamera();

  @override
  void initState() {
    super.initState();

    _requestCameraPermission().then((granted) {
      if (granted) {
        print("성공 success");
        _initializeCamera();

      } else {
        _showPermissionDeniedDialog();
      }
    });
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isPermanentlyDenied) {
      print("Permission is permanently denied.");
      // 설정 화면으로 안내하는 다이얼로그를 표시하거나 권한 설정 페이지로 이동하도록 안내
      return false;
    } else if (status.isDenied) {
      print("Permission is denied.");
      return false;
    } else if (status.isRestricted) {
      print("Permission is restricted and cannot be granted.");
      return false;
    } else if (status.isLimited) {
      print("Permission is limited.");
      return false;
    }

    print("Camera permission granted.");
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.frontCamera,
      ResolutionPreset.low,
    );
    print("성공 success2");
    _initializeCameraFuture = _controller.initialize();
    await _initializeCameraFuture;
    setState(() {}); // 초기화 후 UI 업데이트
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('카메라 권한 필요'),
          content: Text('앱 사용을 위해 카메라 권한이 필요합니다. 설정에서 권한을 허용해 주세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeCameraFuture;
      final image = await _controller.takePicture();
      final faceImage = File(image.path);
      String response = await _compareFaces(faceImage);

      _showResponseDialog(response);
    } catch (e) {
      print('Error taking picture: $e');
      _showResponseDialog('사진 촬영 중 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<String> _compareFaces(File faceImage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}face/compare'),
      );

      request.fields['userId'] = userId ?? '';
      var faceImageStream = http.ByteStream(faceImage.openRead());
      var faceImageLength = await faceImage.length();
      request.files.add(
        http.MultipartFile(
          'faceImage',
          faceImageStream,
          faceImageLength,
          filename: p.basename(faceImage.path),
        ),
      );

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      if (responseBody.statusCode != 200) {
        return '서버와의 통신에 실패했습니다. 다시 시도해주세요.';
      }

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(responseBody.body);
      } catch (e) {
        print('JSON parsing error: $e');
        return '응답 형식이 잘못되었습니다. 다시 시도해주세요.';
      }

      String same = jsonResponse['samePerson'];

      if (same == "success") {
        return '등록된 얼굴 사진과 동일인입니다.';
      } else if (same == "not same") {
        return '동일인이 아닙니다. 본인의 얼굴로만 대여가 가능합니다.';
      } else {
        return "얼굴을 인식할 수 없습니다. 다시 시도해주세요.";
      }
    } catch (e) {
      print('Error comparing faces: $e');
      return '얼굴 비교 중 오류가 발생했습니다. 다시 시도해주세요.';
    }
  }

  void _showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('동일인 여부'),
          content: Text(response),
          actions: [
            if (response == "등록된 얼굴 사진과 동일인입니다.") ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AuthDonePage()),
                  // );
                },
                child: Text('다음'),
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('다시 촬영'),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            //future: _initializeControllerFuture,
            future: _initializeCameraFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller),
                  ),
                );
              } else if (snapshot.hasError) {
                debugPrint('카메라 로딩 중 오류 발생: ${snapshot.error}');
                return Center(child: Text('카메라 로딩 중 오류 발생: ${snapshot.error}'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '얼굴을 영역 안에 맞추고\n촬영해 주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
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
              child: SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  backgroundColor: safeTgreen,
                  onPressed: _takePicture,
                  child: Icon(Icons.camera_alt, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}