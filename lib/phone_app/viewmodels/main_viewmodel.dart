import 'package:flutter/material.dart';
import '../models/enums.dart';

class MainViewModel extends ChangeNotifier {
  HmiPage _currentPage = HmiPage.home;

  HmiPage get currentPage => _currentPage;

  void changePage(HmiPage page) {
    _currentPage = page;
    notifyListeners();
  }
}

