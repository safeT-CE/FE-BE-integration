import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import 'package:safet/back/home.dart';
import 'package:safet/models/auth_user_data.dart';
import 'package:safet/models/detailed_usage_data.dart';
import 'package:safet/models/inquiry_check_data.dart';
import 'package:safet/models/user_info.dart';
import 'package:safet/pages/agreement_page.dart';
import 'package:safet/pages/alarm_page.dart';
import 'package:safet/pages/announcement_page.dart';
import 'package:safet/pages/auth_done_page.dart';
import 'package:safet/pages/auth_face_cam_page.dart';
import 'package:safet/pages/auth_face_how_page.dart';
import 'package:safet/pages/auth_idcard_cam_page.dart';
import 'package:safet/pages/auth_idcard_how_page.dart';
import 'package:safet/pages/auth_idinfo_check_page.dart';
import 'package:safet/pages/auth_page.dart';
import 'package:safet/pages/auth_phonenum_page.dart';
import 'package:safet/pages/detailed_usage_map_page.dart';
import 'package:safet/pages/home_page.dart';
import 'package:safet/pages/identification_page.dart';
import 'package:safet/pages/lock_page.dart';
import 'package:safet/pages/login_page.dart';
import 'package:safet/pages/map_page.dart';
import 'package:safet/pages/number_input_page.dart';
import 'package:safet/pages/one_on_one_inquiry_page.dart';
import 'package:safet/pages/payment_selection_page.dart';
import 'package:safet/pages/penalty_page.dart';
import 'package:safet/pages/profile_page.dart';
import 'package:safet/pages/rent_page.dart';
import 'package:safet/pages/return_page.dart';
import 'package:safet/pages/splash_page.dart';

const Color safeTblack = Color(0xFF1A1A1A);
const Color safeTgray = Color(0xFFA1A1A1);
const Color safeTgreen = Color.fromARGB(255, 175, 208, 143);
const Color safeTlightgreen = Color(0xFFE7F1DE);

Future<void> main() async {
  AuthRepository.initialize(appKey: '0fb225459d4b8c516f20ff340eceb313');
  WidgetsFlutterBinding.ensureInitialized();
  
  // 카메라 초기화
  final cameras = await availableCameras();
  final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
  final backCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);

  runApp(MyApp(frontCamera: frontCamera, backCamera: backCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription frontCamera;
  final CameraDescription backCamera;

  const MyApp({required this.frontCamera, required this.backCamera});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthUserData()),
        ChangeNotifierProvider(create: (context) => AnnouncementProvider()),
      ],
      child: MaterialApp(
        title: 'SafeT',
        theme: ThemeData(
          fontFamily: 'Pretendard',
          primaryColor: safeTgreen,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: safeTgreen,
            secondary: safeTlightgreen,
          ),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: safeTgreen),
            ),
          ),
        ),
        home: SplashPage(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/agreement':
              return MaterialPageRoute(builder: (context) => AgreementPage());
            case '/alarm':
              return MaterialPageRoute(builder: (context) => AlarmPage());
            case '/announcement':
              return MaterialPageRoute(builder: (context) => AnnouncementPage());
            case '/auth_done':
              if (settings.arguments is UserInfo) {
                final userInfo = settings.arguments as UserInfo;
                return MaterialPageRoute(
                  builder: (context) => AuthDonePage(userInfo: userInfo),
                );
              } else {
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: Center(child: Text('Invalid user information.')),
                  ),
                );
              }
            case '/auth_face_cam':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => FaceCamPage(
                  frontCamera: frontCamera, 
                  userInfo: args['userInfo'],
                  licenseImage: args['licenseImage'],
                ),
              );
            case '/auth_face_how':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => FaceHowPage(
                  userInfo: args['userInfo'],
                  licenseImage: args['licenseImage'],
                ),
              );
            case '/auth_id_cam':
              return MaterialPageRoute(
                builder: (context) => IdCamPage(camera: backCamera),
              );
            case '/auth_id_how':
              return MaterialPageRoute(builder: (context) => IdHowPage());
            case '/auth_idinfo':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => IdInfoCheckPage(
                  recognizedLines: args['recognizedLines'] ?? [],
                  licenseImage: args['licenseImage'],
                ),
              );
            case '/detailed_usage_map':
              if (settings.arguments is DetailedUsage) {
                final usage = settings.arguments as DetailedUsage;
                return MaterialPageRoute(
                  builder: (context) => DetailedUsageMapPage(usage: usage),
                );
              } else {
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: Center(child: Text('Invalid map data.')),
                  ),
                );
              }
            case '/auth':
              return MaterialPageRoute(builder: (context) => AuthPage());
            case '/auth_phonenumber':
              return MaterialPageRoute(builder: (context) => PhoneNumberInputPage());
            case '/home':
              return MaterialPageRoute(builder: (context) => HomePage());
            case '/lock':
              return MaterialPageRoute(builder: (context) => LockedPage());
            case '/login':
              return MaterialPageRoute(builder: (context) => LoginPage());
            case '/map':
              return MaterialPageRoute(builder: (context) => MapPage());
            case '/profile':
              return MaterialPageRoute(builder: (context) => ProfilePage());
            case '/rent':
              return MaterialPageRoute(
                builder: (context) => RentPage(frontCamera: frontCamera), // frontCamera 전달
              );
            case '/return':
              return MaterialPageRoute(builder: (context) => ReturnPage());
            case '/payment':
              return MaterialPageRoute(builder: (context) => PaymentSelectionPage());
            case '/number':
              return MaterialPageRoute(builder: (context) => NumberInputPage(onNumberEntered: () {}));
                                
            case '/identification':
              // frontCamera를 arguments로 전달하도록 수정
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => IdentificationPage(frontCamera: args['frontCamera']),
              );


            case '/penalty':
              return MaterialPageRoute(builder: (context) => PenaltyPage());
            case '/one_on_one_inquiry':
              return MaterialPageRoute(
                builder: (context) => OneOnOneInquiryPage(
                  initialCategory: Category.penalty,
                  initialTitle: '벌점 기록에 대한 문의',
                ),
              );
            default:
              return MaterialPageRoute(builder: (context) => SplashPage());
          }
        },
      ),
    );
  }
} 