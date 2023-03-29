import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:grocery_app/cubit/index_provider.dart';
import 'package:grocery_app/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> girisKontrol2(IndexProvider value, String ka, String pss) async {
    if (ka == "boratzn94@gmail.com" && pss == '123') {
      var sp = await SharedPreferences.getInstance();

      sp.setString("kullaniciAdi", ka);
      sp.setString("sifre", pss);

      value.singIn(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kullanıcı adı veya şifre hatalı!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Consumer<IndexProvider>(
        builder: (context, value, child) {
          return loginPageBody2(value);
        },
      ),
    );
  }

  loginPageBody2(IndexProvider value) {
    return FlutterLogin(
      title: 'HOŞGELDİNİZ',
      onLogin: (p0) {
        girisKontrol2(value, p0.name, p0.password);
        return null;
      },
      onRecoverPassword: (p0) {},
    );
  }
}
