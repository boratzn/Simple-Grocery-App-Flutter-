import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/cubit/homepage_cubit.dart';
import 'package:grocery_app/cubit/index_provider.dart';
import 'package:grocery_app/entity/yemekler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/homepageSepet.dart';
import 'my_cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  var url = "http://kasimadalan.pe.hu/yemekler/resimler/";

  late String kullaniciAdi;
  late String sifre;

  Future<void> signOut() async {
    var sp = await SharedPreferences.getInstance();

    sp.remove('kullaniciAdi');
    sp.remove('sifre');
  }

  @override
  void initState() {
    super.initState();
    context.read<HomePageCubit>().yemekleriGetir();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearch = context.read<IndexProvider>().isSearch;
    return Consumer<IndexProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              isSearch
                  ? IconButton(
                      onPressed: () {
                        value.changeState(false);
                        isSearch = value.getState();
                        context.read<HomePageCubit>().yemekleriGetir();
                      },
                      icon: const Icon(Icons.cancel_sharp))
                  : IconButton(
                      onPressed: () {
                        value.changeState(true);
                        isSearch = value.getState();
                      },
                      icon: const Icon(Icons.search)),
              Consumer<IndexProvider>(
                builder: (context, value, child) {
                  return IconButton(
                      onPressed: () {
                        value.singIn(false);
                        signOut();
                      },
                      icon: Icon(Icons.exit_to_app));
                },
              )
            ],
            title: isSearch
                ? TextField(
                    decoration: const InputDecoration(hintText: "Ara"),
                    onChanged: (aramaSonucu) {
                      context.read<HomePageCubit>().yemekAra(aramaSonucu);
                    },
                  )
                : const Text('Anasayfa'),
            backgroundColor: Colors.deepPurple,
          ),
          body: BlocBuilder<HomePageCubit, List<Yemekler>>(
            builder: (context, yemeklerListesi) {
              if (yemeklerListesi.isNotEmpty) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: yemeklerListesi.length,
                  itemBuilder: (context, index) {
                    var yemek = yemeklerListesi[index];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 3,
                        //color: Colors.deepPurple.shade100,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Expanded(
                                    child: Image.network(
                                        "$url${yemek.yemek_resim_adi}")),
                                Column(
                                  children: [
                                    Text(
                                      yemek.yemek_adi,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${yemek.yemek_fiyat}₺",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .read<HomePageSepetCubit>()
                                                .sepeteEkle(
                                                    yemek.yemek_adi,
                                                    yemek.yemek_resim_adi,
                                                    yemek.yemek_fiyat,
                                                    "1",
                                                    "boratzn");
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.deepPurple.shade300,
                                            ),
                                            width: 100,
                                            height: 35,
                                            child: Center(
                                              child: Text(
                                                'Sepete Ekle',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ),
                    );
                    ;
                  },
                );
              } else {
                return const Center();
              }
            },
          ),
        );
      },
    );
  }
}
