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

  static Future setLog(bool val) async {
    final file = await SharedPreferences.getInstance();
    file.setBool("status", val);
  }

  static Future deleter() async {
    final file = await SharedPreferences.getInstance();
    await file.clear();
  }

  Future getName() async {
    final file = await SharedPreferences.getInstance();

    final String name = file.getString("uid");
    return name;
  }

  Future getRandVal() async {
    final file = await SharedPreferences.getInstance();
    final String rand = file.getString("randVal");

    return rand;
  }

  Future setLang(String lang) async {
    final file = await SharedPreferences.getInstance();
    await file.setString("Language", lang);
  }

  Future getLang() async {
    final file = await SharedPreferences.getInstance();
    final lang = file.getString("Language");
    return lang;
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
