import 'package:flutter/material.dart';
import 'package:hmi/features/phone/models/enums.dart';
import 'package:hmi/features/phone/viewmodels/main_viewmodel.dart';
import 'package:hmi/features/home/home_page.dart';
import 'package:hmi/features/phone/views/phone_page.dart';
import 'package:hmi/features/media/media_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainViewModel _viewModel = MainViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return Row(
            children: [
              _sideMenu(),
              Expanded(
                child: Container(
                  color: const Color(0xFF0B0F19),
                  child: _buildPage(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===== SIDEBAR =====
  Widget _sideMenu() {
    return Container(
      width: 90,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _menuButton(Icons.home, HmiPage.home),
          const SizedBox(height: 40),
          _menuButton(Icons.phone, HmiPage.phone),
          const SizedBox(height: 40),
          _menuButton(Icons.movie, HmiPage.media),
        ],
      ),
    );
  }

  Widget _menuButton(IconData icon, HmiPage page) {
    final active = _viewModel.currentPage == page;
    return IconButton(
      iconSize: 32,
      color: active ? Colors.white : Colors.grey[700],
      onPressed: () => _viewModel.changePage(page),
      icon: Icon(icon),
    );
  }

  // ===== PAGE SWITCH =====
  Widget _buildPage() {
    switch (_viewModel.currentPage) {
      case HmiPage.home:
        return HomePage(onNavigate: (page) => _viewModel.changePage(page));

      case HmiPage.phone:
        return const PhonePage();
      case HmiPage.media:
        return const MediaPage();
    }
  }
}
