import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/entity/yemekler.dart';
import 'package:grocery_app/entity/yemekler_cevap.dart';

import '../entity/sepet_yemekler.dart';
import '../entity/sepet_yemekler_cevap.dart';

class YemeklerDaoRepository {
  List<Yemekler> parseYemeklerCevap(String cevap) {
    return YemeklerCevap.fromJson(jsonDecode(cevap)).yemekler;
  }

  List<SepetYemekler> parseSepetYemeklerCevap(String cevap) {
    return SepetYemeklerCevap.fromJson(jsonDecode(cevap)).sepetYemekler;
  }

  Future<List<Yemekler>> tumYemekleriAl() async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var cevap = await Dio().get(url);
    return parseYemeklerCevap(cevap.data.toString());
  }

  Future<List<SepetYemekler>> sepettekiYemekleriGetir(
      String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
    var veri = {"kullanici_adi": kullanici_adi};
    var cevap;
    try {
      cevap = await Dio().post(url, data: FormData.fromMap(veri));
      return parseSepetYemeklerCevap(cevap.data.toString());
    } catch (e) {
      return <SepetYemekler>[];
    } finally {}
  }

  Future<void> sepeteEkle(
      String yemek_adi,
      String yemek_resim_adi,
      String yemek_fiyat,
      String yemek_siparis_adet,
      String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
    var veri = {
      "yemek_adi": yemek_adi,
      "yemek_resim_adi": yemek_resim_adi,
      "yemek_fiyat": yemek_fiyat,
      "yemek_siparis_adet": yemek_siparis_adet,
      "kullanici_adi": kullanici_adi
    };
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    debugPrint(cevap.toString());
  }

  Future<void> sepetYemekSil(
      String sepet_yemek_id, String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
    var veri = {
      "sepet_yemek_id": sepet_yemek_id,
      "kullanici_adi": kullanici_adi
    };
    await Dio().post(url, data: FormData.fromMap(veri));
  }
}
