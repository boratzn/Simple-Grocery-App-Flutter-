import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/consts/constants.dart';
import 'package:grocery_app/cubit/homepageSepet.dart';
import 'package:grocery_app/cubit/homepage_cubit.dart';
import 'package:grocery_app/cubit/index_provider.dart';
import 'package:grocery_app/entity/sepet_yemekler.dart';
import 'package:grocery_app/pages/home_page.dart';
import 'package:grocery_app/pages/login_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:grocery_app/pages/payment_page.dart';
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
  String kullanici_adi = '';

  final pages = [HomePage(), MyCart(), PaymentPage()];

  @override
  Widget build(BuildContext context) {
    Constants.initSp();
    kullanici_adi = Constants.kullaniciAdi;
    debugPrint(" Kullanıcı Adı : $kullanici_adi");
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
        home: Consumer<IndexProvider>(
          builder: (context, currentIndexNesne, child) {
            return Scaffold(
                bottomNavigationBar: currentIndexNesne.isSignIn
                    ? _bottomNavBar(currentIndexNesne)
                    : null,
                body: currentIndexNesne.isSignIn
                    ? pages[currentIndexNesne.getIndex()]
                    : LoginPage());
          },
        ),
      ),
    );
  }

  BottomNavigationBar _bottomNavBar(IndexProvider currentIndexNesne) {
    return BottomNavigationBar(
      currentIndex: currentIndexNesne.getIndex(),
      backgroundColor: Colors.deepPurple.shade100,
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.home), label: 'Anasayfa'),
        BottomNavigationBarItem(
            icon: BlocBuilder<HomePageSepetCubit, List<SepetYemekler>>(
              builder: (context, sepettekiYemekler) {
                context
                    .read<HomePageSepetCubit>()
                    .sepettekiYemekleriGetir(kullanici_adi);
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
            icon: Icon(Icons.payment), label: 'Ödeme Yap'),
      ],
      onTap: (index) {
        currentIndexNesne.changeIndex(index);
      },
    );
  }
}
