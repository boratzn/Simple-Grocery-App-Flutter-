import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/entity/yemekler.dart';
import 'package:grocery_app/repo/yemeklerdao_repo.dart';

class HomePageCubit extends Cubit<List<Yemekler>> {
  HomePageCubit() : super(<Yemekler>[]);

  var yrepo = YemeklerDaoRepository();

  Future<void> yemekleriGetir() async {
    var liste = await yrepo.tumYemekleriAl();
    emit(liste);
  }

  Future<void> yemekAra(String aramaKelimesi) async {
    List<Yemekler> yemekler = await yrepo.tumYemekleriAl();
    List<Yemekler> filtrelenenYemekler = <Yemekler>[];
    for (var yemek in yemekler) {
      if (yemek.yemek_adi.toLowerCase().contains(aramaKelimesi.toLowerCase())) {
        filtrelenenYemekler.add(yemek);
      }
    }
    emit(filtrelenenYemekler);
  }
}
