import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static var url = "http://kasimadalan.pe.hu/yemekler/resimler/";
  static double toplamTutar = 0;

  static String kullaniciAdi = "";

  static Future<void> initSp() async {
    var sp = await SharedPreferences.getInstance();

    kullaniciAdi = sp.getString("kullaniciAdi").toString();
  }
}
