import 'package:grocery_app/entity/sepet_yemekler.dart';

class SepetYemeklerCevap {
  int success;
  List<SepetYemekler> sepetYemekler;

  SepetYemeklerCevap({
    required this.success,
    required this.sepetYemekler,
  });

  factory SepetYemeklerCevap.fromJson(Map<String, dynamic> json) {
    var gelenYemekler = json['sepet_yemekler'] as List;
    List<SepetYemekler> sepetYemekler =
        gelenYemekler.map((e) => SepetYemekler.fromJson(e)).toList();

    return SepetYemeklerCevap(
        sepetYemekler: sepetYemekler, success: json['success']);
  }
}
