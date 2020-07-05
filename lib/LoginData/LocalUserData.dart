import 'package:shared_preferences/shared_preferences.dart';

class UserName {
  static String name;
  static bool isLoggedin;
  static String randVal;
  static setter(String temp) {
    name = temp;
    isLoggedin = true;
  }

  static Future<void> writeIn(String encr) async {
    randVal = encr;
    final file = await SharedPreferences.getInstance();
    file.setString("uid", name);
    file.setBool("status", isLoggedin);
    file.setString("randVal", encr);
  }

  static Future<int> checker() async {
    final file = await SharedPreferences.getInstance();
    if (file.containsKey("uid") == true) {
      randVal = file.getString("randVal");
      print("randVal offline : $randVal");
      name = file.getString("uid");
      if (file.getBool("status") == true) {
        print(
          file.getString("uid"),
        );
        isLoggedin = true;
        return 1;
      } else {
        isLoggedin = false;
        return 0;
      }
    } else {
      return 0;
    }
  }
}
