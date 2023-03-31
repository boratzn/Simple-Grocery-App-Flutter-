import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:grocery_app/consts/constants.dart';
import 'package:grocery_app/cubit/homepageSepet.dart';
import 'package:grocery_app/cubit/index_provider.dart';
import 'package:grocery_app/entity/sepet_yemekler.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_options.dart';
import 'package:quickalert/quickalert.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;

  final FocusNode _focusNode = FocusNode();
  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              CreditCard(
                cardNumber: cardNumber,
                cardExpiry: expiryDate,
                cardHolderName: cardHolderName,
                cvv: cvv,
                bankName: 'Axis Bank',
                showBackSide: showBack,
                frontBackground: CardBackgrounds.custom(0xFF9E9E9E),
                backBackground: CardBackgrounds.white,
                showShadow: true,
                // mask: getCardTypeMask(cardType: CardType.americanExpress),
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      controller: cardNumberCtrl,
                      decoration: InputDecoration(hintText: 'Card Number'),
                      maxLength: 16,
                      onChanged: (value) {
                        final newCardNumber = value.trim();
                        var newStr = '';
                        final step = 4;

                        for (var i = 0; i < newCardNumber.length; i += step) {
                          newStr += newCardNumber.substring(
                              i, math.min(i + step, newCardNumber.length));
                          if (i + step < newCardNumber.length) newStr += ' ';
                        }

                        setState(() {
                          cardNumber = newStr;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      controller: expiryFieldCtrl,
                      decoration: InputDecoration(hintText: 'Card Expiry'),
                      maxLength: 5,
                      onChanged: (value) {
                        var newDateValue = value.trim();
                        final isPressingBackspace =
                            expiryDate.length > newDateValue.length;
                        final containsSlash = newDateValue.contains('/');

                        if (newDateValue.length >= 2 &&
                            !containsSlash &&
                            !isPressingBackspace) {
                          newDateValue = newDateValue.substring(0, 2) +
                              '/' +
                              newDateValue.substring(2);
                        }
                        setState(() {
                          expiryFieldCtrl.text = newDateValue;
                          expiryFieldCtrl.selection =
                              TextSelection.fromPosition(
                                  TextPosition(offset: newDateValue.length));
                          expiryDate = newDateValue;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Card Holder Name'),
                      onChanged: (value) {
                        setState(() {
                          cardHolderName = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: 'CVV'),
                      maxLength: 3,
                      onChanged: (value) {
                        setState(() {
                          cvv = value;
                        });
                      },
                      focusNode: _focusNode,
                    ),
                  ),
                  BlocBuilder<HomePageSepetCubit, List<SepetYemekler>>(
                    builder: (context, sepettekiYemekler) {
                      Constants.toplamTutar =
                          Constants.tutarHesapla(sepettekiYemekler);
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Toplam Tutar : ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "${Constants.toplamTutar.toString()}₺",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Consumer<IndexProvider>(
                              builder: (context, value, child) {
                                return ElevatedButton(
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 8),
                                    child: Text(
                                      "Ödeme Yap",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (sepettekiYemekler.length > 0) {
                                      QuickAlert.show(
                                        confirmBtnColor: Colors.deepPurple,
                                        confirmBtnText: "Anasayfaya Dön",
                                        title: "Ödeme Başarılı",
                                        context: context,
                                        type: QuickAlertType.success,
                                        text: "Siparişiniz Alındı.",
                                      ).then((_) {
                                        for (var yemek in sepettekiYemekler) {
                                          context
                                              .read<HomePageSepetCubit>()
                                              .sepettenYemekSil(
                                                  yemek.sepet_yemek_id,
                                                  yemek.kullanici_adi);
                                        }
                                        value.changeIndex(0);
                                      });
                                    } else {
                                      QuickAlert.show(
                                        confirmBtnColor: Colors.deepPurple,
                                        confirmBtnText: "Anasayfaya Dön",
                                        title: "Sepetiniz Boş!",
                                        context: context,
                                        type: QuickAlertType.warning,
                                      ).then((_) {
                                        value.changeIndex(0);
                                      });
                                    }
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
