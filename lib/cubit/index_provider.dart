import 'package:flutter/cupertino.dart';

class IndexProvider extends ChangeNotifier {
  int currentIndex = 0;
  bool isSearch = false;
  bool isSignIn = false;

  int getIndex() {
    return currentIndex;
  }

  bool getState() {
    return isSearch;
  }

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void changeState(bool state) {
    isSearch = state;
    notifyListeners();
  }

  void singIn(bool state) {
    isSignIn = state;
    notifyListeners();
  }
}
