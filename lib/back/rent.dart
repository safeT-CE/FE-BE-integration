import 'package:http/http.dart' as http;
import 'package:safet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> requestRentalCompletion() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final url = Uri.parse('${baseUrl}kickboard/rent');
    
    final response = await http.post(
      url,
      body: {
        'kickboardId' : 1,  // 수정 필요
        'userId': userId
      },
    );

    if (response.statusCode == 200) {
      print('Rental completed successfully.');
    } else {
      print('Failed to complete rental.');
    }
  } catch (e) {
    print('Error completing rental: $e');
  }
}