import 'package:shared_preferences/shared_preferences.dart';

import '../entity/sepet_yemekler.dart';

class Constants {
  static var url = "http://kasimadalan.pe.hu/yemekler/resimler/";
  static double toplamTutar = 0;

  static String kullaniciAdi = "";

  static Future<void> initSp() async {
    var sp = await SharedPreferences.getInstance();

    kullaniciAdi = sp.getString("kullaniciAdi").toString();
  }

  static double tutarHesapla(List<SepetYemekler> sepettekiYemekler) {
    double toplam = 0;
    for (var yemek in sepettekiYemekler) {
      toplam +=
          (int.parse(yemek.yemek_fiyat) * int.parse(yemek.yemek_siparis_adet));
    }

    return toplam;
  }
}
