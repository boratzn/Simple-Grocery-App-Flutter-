import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/cubit/homepageSepet.dart';
import 'package:grocery_app/cubit/homepage_cubit.dart';
import 'package:grocery_app/cubit/index_provider.dart';
import 'package:grocery_app/entity/sepet_yemekler.dart';
import 'package:grocery_app/pages/home_page.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/my_cart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;
  String username = '';
  var sp;

  Future<void> initSp() async {
    sp = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initSp().then((value) {
      username = sp.getString('kullaniciAdi').toString();
    });
  }

  final pages = [
    HomePage(),
    MyCart(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomePageCubit(),
        ),
        BlocProvider(
          create: (context) => HomePageSepetCubit(),
        ),
        ChangeNotifierProvider(
          create: (context) => IndexProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: BlocBuilder<HomePageSepetCubit, List<SepetYemekler>>(
          builder: (contextt, sepettekiYemekler) {
            return Consumer<IndexProvider>(
              builder: (context, currentIndexNesne, child) {
                contextt
                    .read<HomePageSepetCubit>()
                    .sepettekiYemekleriGetir(username);
                return Scaffold(
                    bottomNavigationBar: currentIndexNesne.isSignIn
                        ? _bottomNavBar(currentIndexNesne)
                        : null,
                    body: currentIndexNesne.isSignIn
                        ? pages[currentIndex]
                        : LoginPage());
              },
            );
          },
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavBar(IndexProvider currentIndexNesne) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Colors.deepPurple.shade100,
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home), label: 'Anasayfa'),
        BottomNavigationBarItem(
            icon: BlocBuilder<HomePageSepetCubit, List<SepetYemekler>>(
              builder: (context, sepettekiYemekler) {
                return badges.Badge(
                  badgeContent: Text(
                    '${sepettekiYemekler.length}',
                    style: TextStyle(color: Colors.white),
                  ),
                  showBadge: sepettekiYemekler.length > 0 ? true : false,
                  child: Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Sepet'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: 'Ayarlar'),
      ],
      onTap: (index) {
        currentIndexNesne.changeIndex(index);
        currentIndex = currentIndexNesne.getIndex();
      },
    );
  }
}
