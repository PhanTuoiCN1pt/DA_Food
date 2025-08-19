import 'package:flutter/widgets.dart';

class TabProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  Future<void> setTab(int index) async {
    _currentIndex = index;
    notifyListeners();
  }
}
