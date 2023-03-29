import 'package:flutter/material.dart';
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
  var tfKullaniciAdi = TextEditingController();
  var tfSifre = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> girisKontrol(IndexProvider value) async {
    var ka = tfKullaniciAdi.text;
    var pss = tfSifre.text;

    if (ka == "boratzn" && pss == '123') {
      var sp = await SharedPreferences.getInstance();

      sp.setString("kullaniciAdi", ka);
      sp.setString("sifre", pss);

      value.singIn(true);
    } else {
      tfKullaniciAdi.text = '';
      tfSifre.text = '';
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kullanıcı adı veya şifre hatalı!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Giriş Sayfası'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: tfKullaniciAdi,
                decoration: InputDecoration(hintText: 'Kullanıcı Adı'),
              ),
              TextField(
                obscureText: true,
                controller: tfSifre,
                decoration: InputDecoration(hintText: 'Şifre'),
              ),
              Consumer<IndexProvider>(
                builder: (context, value, child) {
                  return MaterialButton(
                      color: Colors.deepPurple,
                      onPressed: () {
                        girisKontrol(value);
                      },
                      child: Text(
                        'Giriş Yap',
                        style: TextStyle(color: Colors.white),
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
