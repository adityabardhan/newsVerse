import 'package:shared_preferences/shared_preferences.dart';

class DarkTheme{
  static const THEME_STATUS = 'THEMESTATUS';

  setDarkTheme(bool value) async{
    SharedPreferences shd = await SharedPreferences.getInstance();
    shd.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async{
    SharedPreferences shd = await SharedPreferences.getInstance();
    return shd.getBool(THEME_STATUS)?? false;
  }

}