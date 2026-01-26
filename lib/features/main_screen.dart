import 'package:flutter/material.dart';
import 'package:hmi/features/phone/models/enums.dart';
import 'package:hmi/features/phone/viewmodels/main_viewmodel.dart';
import 'package:hmi/features/home/home_page.dart';
import 'phone/views/phone_page.dart';

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
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return Row(
            children: [
              _sideMenu(),
              Expanded(child: _buildPage()),
            ],
          );
        },
      ),
    );
  }

  Widget _sideMenu() {
    return Container(
      width: 90,
      color: const Color.fromARGB(221, 142, 139, 139),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _menuButton(Icons.home, HmiPage.home),
          _menuButton(Icons.phone, HmiPage.phone),
        ],
      ),
    );
  }

  Widget _menuButton(IconData icon, HmiPage page) {
    final active = _viewModel.currentPage == page;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: IconButton(
        iconSize: 32,
        color:
            active ? Colors.blueAccent : const Color.fromARGB(40, 42, 37, 37),
        onPressed: () => _viewModel.changePage(page),
        icon: Icon(icon),
      ),
    );
  }

  Widget _buildPage() {
    switch (_viewModel.currentPage) {
      case HmiPage.home:
        return const HomePage();
      case HmiPage.phone:
        return const PhonePage();
    }
  }
}
