/*import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:safet/back/rent.dart';
import 'package:safet/models/user_face_info.dart'; // 변경된 부분
import 'package:safet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 추가된 부분
import 'package:http/http.dart' as http; // 추가된 부분
import '../main.dart';
import 'identification_page.dart'; // Ensure the import is correct
import 'number_input_page.dart';

class RentPage extends StatefulWidget {
  @override
  _RentPageState createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  CameraDescription? frontCamera; // Store front camera information
  File? registeredFaceImage; // Variable to hold the registered face image

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadRegisteredFaceImage(); // Load the registered face image
  }

  void _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _loadRegisteredFaceImage() async {
    // 얼굴 이미지 로드하는 로직을 구현
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('대여하기'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: safeTgreen),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: safeTgreen,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NumberInputPage(
                            onNumberEntered: () {
                              _navigateToIdentification(context);
                            },
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.dialpad),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: safeTgreen,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (controller != null) {
                        controller?.toggleFlash();
                      }
                    },
                    child: Icon(Icons.flashlight_on),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        _navigateToIdentification(context);
      }
    });
  }

  void _navigateToIdentification(BuildContext context) {
    if (frontCamera != null && registeredFaceImage != null) {
      UserFaceInfo userFaceInfo = UserFaceInfo(
        registeredFaceImagePath: registeredFaceImage!.path,
        currentFaceImagePath: '현재_이미지_경로', // 현재 얼굴 이미지를 어떻게 가져올 것인지 구현 필요
        userId: '사용자_ID', // 사용자 ID를 어떻게 가져올 것인지 구현 필요
      );

      _uploadImages(userFaceInfo).then((result) {
        // 결과 처리
        print(result);
        // 결과에 따라 UI 업데이트 또는 다른 로직 구현 가능
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IdentificationPage(
            frontCamera: frontCamera!,
            userFaceInfo: userFaceInfo, // UserFaceInfo 전달
            registeredFaceImage: registeredFaceImage!,
          ),
        ),
      ).then((isIdentified) {
        if (isIdentified != null && isIdentified) {
          _showBatteryPopup(context);
        } else {
          _showErrorDialog(context, "얼굴 인식에 실패했습니다. 다시 시도해주세요.");
        }
      });
    } else {
      _showErrorDialog(context, "카메라를 초기화하는 데 실패했습니다. 다시 시도해주세요.");
    }
  }

  Future<String> _uploadImages(UserFaceInfo userFaceInfo) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId'); // 저장된 사용자 ID 가져오기
      print('저장된 사용자 ID: $userId');

      // 이미지 업로드를 위한 multipart request 생성
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}face/request'),
      );

      // 사용자 아이디 추가
      request.fields['userId'] = userId ?? ''; 

      // 등록된 얼굴 이미지와 현재 얼굴 이미지 추가
      request.files.add(await http.MultipartFile.fromPath(
        'registeredFaceImage',
        userFaceInfo.registeredFaceImagePath,
      ));

      request.files.add(await http.MultipartFile.fromPath(
        'currentFaceImage',
        userFaceInfo.currentFaceImagePath,
      ));

      // 요청 전송
      var response = await request.send();

      // 응답 처리
      if (response.statusCode == 200) {
        return '성공적으로 업로드되었습니다.';
      } else {
        return '업로드 실패: ${response.statusCode}';
      }
    } catch (e) {
      print('업로드 중 오류 발생: $e');
      return '업로드 중 오류 발생: $e';
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('동일인 판별 오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showBatteryPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('배터리 정보'),
          content: Text('배터리가 85% 남은 기기입니다.\n대여하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showRentalConfirmationPopup(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: Text('대여하기'),
            ),
          ],
        );
      },
    );
  }

  void _showRentalConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('대여 완료'),
          content: Text('대여가 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await requestRentalCompletion(); // Request for rental completion
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
*/
