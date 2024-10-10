import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:safet/main.dart';
import 'package:safet/models/auth_user_data.dart'; 
import 'package:safet/models/user_info.dart';
import 'package:safet/pages/auth_done_page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:safet/utils/constants.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class FaceCamPage extends StatefulWidget {
  final CameraDescription frontCamera;
  final File licenseImage;
  final UserInfo userInfo;

  
  FaceCamPage({
    required this.frontCamera,
    required this.userInfo,
    required this.licenseImage,
  });

  @override
  _FaceCamPageState createState() => _FaceCamPageState();
}


class _FaceCamPageState extends State<FaceCamPage> {
  
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  bool same = true; // 동일인 여부를 나타내는 변수 (true면 동일인, false면 동일인이 아님)

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.frontCamera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final faceImage = File(image.path);
      String response = await _uploadImages(faceImage); // 응답을 받아옴

      _showResponseDialog(response);
    } catch (e) {
      print(e);
    }
  }

Future<String> _uploadImages(File faceImage) async {
  try {
    //String? userId = Provider.of<AuthUserData>(context, listen: false).userId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print('저장된 사용자 ID: $userId');

    // 이미지 업로드를 위한 multipart request 생성
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse('${baseUrl}face/request'),
    );

    // 사용자 아이디 추가
    request.fields['userId'] = userId ?? '';

    // 면허증 사진 추가
    var licenseImageStream = http.ByteStream(widget.licenseImage.openRead());
    var licenseImageLength = await widget.licenseImage.length();
    request.files.add(
      http.MultipartFile(
        'licenseImage',
        licenseImageStream,
        licenseImageLength,
        filename: p.basename(widget.licenseImage.path),
      ),
    );

    // 얼굴 사진 추가
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

    // 요청 전송 및 응답 처리
    var response = await request.send();

    var responseBody = await http.Response.fromStream(response);    
    if (responseBody.body.isEmpty) {
      throw FormatException('Empty response body');
    }

    print('Response status: ${responseBody.statusCode}');
    print('Response Body:  ${responseBody.body}');

    Map<String, dynamic> jsonResponse;
    try {
      jsonResponse = jsonDecode(responseBody.body);
    } catch (e) {
      print('JSON parsing error: $e');
      return '응답 형식이 잘못되었습니다. 다시 시도해주세요.';
    }

    String same = jsonResponse['samePerson'];  // 서버에서 받은 결과 -> 예외처리 할 예정
    
    if (response.statusCode == 200) {
      if (same == "success") {
        return '면허증 사진과 동일인입니다.';
      } else if (same == "not same") {
        return '동일인이 아닙니다.\n본인의 면허증으로만 가입 가능합니다.';
      } else if (same == "face no face" || same == "license no face"){
        return "얼굴을 인식할 수 없습니다.\n면허증과 얼굴을 다시 인식해요주세요.";
      }
    } else if (response.statusCode == 500) {
        return '서버에서 얼굴 인식 중 오류가 발생했습니다. 다시 시도해주세요.';
    } else if (response.statusCode == 400) {
      return '잘못된 요청입니다. 요청을 확인하고 다시 시도해주세요.';
    } else {
      return '알 수 없는 오류가 발생했습니다. 상태 코드: ${response.statusCode}';
    }
  } catch (e) {
    print('Error uploading images: $e');
    return '이미지 업로드 중 오류가 발생했습니다. 다시 시도해주세요.';
  }
  return '알 수 없는 오류가 발생했습니다.';
}

  void _showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,  // 팝업 배경색 흰색으로 지정
          title: Text('동일인 여부',
          style: TextStyle(fontFamily:"safeTboldPT",),),
          content: Text(response),
          actions: [
            if (response == "면허증 사진과 동일인입니다.") ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthDonePage(userInfo: widget.userInfo),
                    ),
                  );
                },
                child: Text('다음',
                style: TextStyle(fontFamily:"safeTtextPT",
                ),
                ),
              ),
            ] else...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  // 동일인이 아닐 경우 다시 얼굴 촬영 시도
                },
                child: Text('다시 촬영',
                style: TextStyle(fontFamily:"safeTtextPT",
                ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('FaceCamPage - UserInfo received: ${widget.userInfo.toString()}');

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(_controller),
                      ),
                    ),
                  ),
                );
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
                  style: TextStyle(fontSize: 20, 
                  fontFamily:"safeTboldPT", 
                  color: Colors.white),
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
                width: 80,  // 버튼의 크기 조정
                height: 80,  // 버튼의 크기 조정
                child: FloatingActionButton(
                  backgroundColor: safeTgreen,
                  onPressed: _takePicture,
                  child: Icon(Icons.camera_alt, size: 28),
              ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}