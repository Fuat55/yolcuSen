import 'package:shared_preferences/shared_preferences.dart';

class Shared{
  void ekle(String key,String val) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, val);
  }
  Future<String> oku(String key) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString(key)!=null)
      return pref.getString(key).toString();
    else
      return "false";
  }

  void sil(String key) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString(key)!=null)
      pref.remove(key);
  }
}