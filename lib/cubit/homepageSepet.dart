import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/entity/sepet_yemekler.dart';

import '../repo/yemeklerdao_repo.dart';

class HomePageSepetCubit extends Cubit<List<SepetYemekler>> {
  HomePageSepetCubit() : super(<SepetYemekler>[]);

  var yrepo = YemeklerDaoRepository();
  var liste = <SepetYemekler>[];

  Future<void> sepettekiYemekleriGetir(String kullanici_adi) async {
    try {
      liste = await yrepo.sepettekiYemekleriGetir(kullanici_adi);
      liste = await yrepo.sepettekiYemekleriGetir(kullanici_adi);
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(liste);
  }

  Future<void> sepeteEkle(
      String yemek_adi,
      String yemek_resim_adi,
      String yemek_fiyat,
      String yemek_siparis_adet,
      String kullanici_adi) async {
    try {
      await yrepo.sepeteEkle(yemek_adi, yemek_resim_adi, yemek_fiyat,
          yemek_siparis_adet, kullanici_adi);
    } catch (e) {}
  }

  Future<void> sepettenYemekSil(
      String sepet_yemek_id, String kullanici_adi) async {
    await yrepo.sepetYemekSil(sepet_yemek_id, kullanici_adi);
    sepettekiYemekleriGetir(kullanici_adi);
  }

  void sepetAdetAzalt(String sepet_yemek_id, String kullanici_adi) {
    for (var yemek in liste) {
      if (yemek.kullanici_adi == kullanici_adi) {
        if (yemek.sepet_yemek_id == sepet_yemek_id) {
          int adet = int.parse(yemek.yemek_siparis_adet);
          String kullanici_adii = yemek.kullanici_adi;
          String yemek_adi = yemek.yemek_adi;
          String yemek_resim_adi = yemek.yemek_resim_adi;
          String yemek_fiyat = yemek.yemek_fiyat;
          String sepet_yemek_adet = (adet - 1).toString();
          sepettenYemekSil(sepet_yemek_id, kullanici_adii);
          sepeteEkle(yemek_adi, yemek_resim_adi, yemek_fiyat, sepet_yemek_adet,
              kullanici_adii);
        }
      }
    }
  }

  void sepetAdetArttir(String sepet_yemek_id, String kullanici_adi) {
    for (var yemek in liste) {
      if (yemek.kullanici_adi == kullanici_adi) {
        if (yemek.sepet_yemek_id == sepet_yemek_id) {
          int adet = int.parse(yemek.yemek_siparis_adet);
          String sepet_yemek_idd = yemek.sepet_yemek_id;
          String kullanici_adii = yemek.kullanici_adi;
          String yemek_adi = yemek.yemek_adi;
          String yemek_resim_adi = yemek.yemek_resim_adi;
          String yemek_fiyat = yemek.yemek_fiyat;
          String sepet_yemek_adet = (adet + 1).toString();
          sepettenYemekSil(sepet_yemek_idd, kullanici_adii);
          sepeteEkle(yemek_adi, yemek_resim_adi, yemek_fiyat, sepet_yemek_adet,
              kullanici_adii);
        }
      }
    }
  }
}
