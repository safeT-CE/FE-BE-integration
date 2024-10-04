import 'package:flutter/material.dart';
import 'package:safet/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safet/back/home.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? phoneNumber;
  String? grade;
  String? useTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();

    // AnnouncementProvider에서 제목을 가져오기 위해 context 사용
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final announcementProvider = Provider.of<AnnouncementProvider>(context, listen: false);
      announcementProvider.fetchLatestTitle();
    });
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      final homeProfile = await fetchPhoneNumber(userId); // API를 통해 전화번호 가져옴
      if (homeProfile != null) {
        setState(() {
          phoneNumber = homeProfile.phone;
          grade = homeProfile.grade;
          useTime = homeProfile.useTime.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final announcementProvider = Provider.of<AnnouncementProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // 뒤로 가기 동작을 막습니다.
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'safeT',
            style: TextStyle(
              color: safeTblack,
              fontFamily: "safeTtitle",
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: SizedBox(), // Empty widget to ensure the title is centered
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: safeTgreen),
              onPressed: () {
                Navigator.pushNamed(context, '/alarm');
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: safeTgreen),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
          iconTheme: IconThemeData(color: safeTgreen),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/announcement');
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: safeTlightgreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          announcementProvider.latestTitle ?? '로딩 중...',
                          style: TextStyle(
                            fontFamily: "safeTtextPT",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: safeTgreen,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: safeTlightgreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/image/level1.png', width: 50, height: 50),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${useTime ?? "0"}째 사용 중\n${phoneNumber ?? "닉네임"}님\n${grade ?? "레벨"}입니다',
                          style: TextStyle(
                            fontFamily: "safeTtextPT",
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/rent');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: safeTlightgreen,
                          foregroundColor: safeTblack,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '대여하기',
                          style: TextStyle(
                            fontFamily: "safeTtextPT",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/return');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: safeTlightgreen,
                          foregroundColor: safeTblack,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '반납하기',
                          style: TextStyle(
                            fontFamily: "safeTtextPT",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/map');
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/image/seoul_map2.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Center(
                        child: Text(
                          '지도',
                          style: TextStyle(
                            color: safeTblack,
                            fontFamily: "safeTtextPT",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
