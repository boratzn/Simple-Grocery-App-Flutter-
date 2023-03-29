import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/cubit/homepage_cubit.dart';
import 'package:grocery_app/entity/sepet_yemekler.dart';

import '../consts/constants.dart';
import '../cubit/homepageSepet.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<SepetYemekler> sepetYemekler = <SepetYemekler>[];

  @override
  void initState() {
    super.initState();
    context.read<HomePageSepetCubit>().sepettekiYemekleriGetir("boratzn");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Sepetim',
        ),
      ),
      body: BlocBuilder<HomePageSepetCubit, List<SepetYemekler>>(
        builder: (context, sepettekiYemekler) {
          if (sepettekiYemekler.isNotEmpty) {
            Constants.toplamTutar = _tutarHesapla(sepettekiYemekler);
            return Stack(
              children: [
                Container(
                  height: 510,
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: sepettekiYemekler.length,
                    itemBuilder: (context, index) {
                      var yemek = sepettekiYemekler[index];
                      return SizedBox(
                        height: 125,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                      '${Constants.url}${yemek.yemek_resim_adi}'),
                                  Text(
                                    yemek.yemek_adi,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${yemek.yemek_fiyat}₺",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          IconButton(
                                              iconSize: 18,
                                              onPressed: () {
                                                int adet = int.parse(
                                                    yemek.yemek_siparis_adet);
                                                if (adet > 1) {
                                                  context
                                                      .read<
                                                          HomePageSepetCubit>()
                                                      .sepetAdetAzalt(
                                                        yemek.sepet_yemek_id,
                                                        yemek.kullanici_adi,
                                                      );
                                                } else {
                                                  context
                                                      .read<
                                                          HomePageSepetCubit>()
                                                      .sepettenYemekSil(
                                                          yemek.sepet_yemek_id,
                                                          yemek.kullanici_adi);
                                                }
                                              },
                                              icon: const Icon(Icons.remove)),
                                          Text(
                                            '${yemek.yemek_siparis_adet}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          IconButton(
                                              iconSize: 18,
                                              onPressed: () {
                                                context
                                                    .read<HomePageSepetCubit>()
                                                    .sepetAdetArttir(
                                                      yemek.sepet_yemek_id,
                                                      yemek.kullanici_adi,
                                                    );
                                              },
                                              icon: const Icon(Icons.add)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          color: Colors.white30,
                          elevation: 5,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8)),
                      width: 250,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Toplam Tutar',
                                style: TextStyle(
                                    color: Colors.green.shade100, fontSize: 12),
                              ),
                              Text(
                                '${Constants.toplamTutar}₺',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Şimdi Öde',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: Text(
                'Sepetinizde Ürün Bulunmamaktadır.',
                style: TextStyle(fontSize: 20),
              ),
            );
          }
        },
      ),
    );
  }

  double _tutarHesapla(List<SepetYemekler> sepettekiYemekler) {
    double toplam = 0;
    for (var yemek in sepettekiYemekler) {
      toplam +=
          (int.parse(yemek.yemek_fiyat) * int.parse(yemek.yemek_siparis_adet));
    }

    return toplam;
  }
}
