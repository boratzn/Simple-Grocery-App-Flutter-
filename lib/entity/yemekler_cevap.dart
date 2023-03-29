import 'package:grocery_app/entity/yemekler.dart';

class YemeklerCevap {
  List<Yemekler> yemekler;
  int success;

  YemeklerCevap({
    required this.yemekler,
    required this.success,
  });

  factory YemeklerCevap.fromJson(Map<String, dynamic> json) {
    var gelenYemekler = json['yemekler'] as List;
    List<Yemekler> yemekler =
        gelenYemekler.map((e) => Yemekler.fromJson(e)).toList();

    return YemeklerCevap(yemekler: yemekler, success: json['success']);
  }
}
