import 'dart:async';
import 'package:flutter/material.dart';
import 'phone_app/models/enums.dart';
import 'phone_app/viewmodels/main_viewmodel.dart';
import 'home_app/home_page.dart';
import 'phone_app/phone_page.dart';
import 'media_app/media_page.dart';
import 'home_app/widgets/volume_hud.dart';
import 'home_app/viewmodels/home_view_model.dart';
import 'home_app/widgets/home_header.dart'; 
import 'map_app/screens/map_screen.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainViewModel _mainViewModel = MainViewModel();
  late final HomeViewModel _homeVm = HomeViewModel();

  bool _showVolumeHud = false;
  double _currentVolume = 0.5; 
  Timer? _volumeTimer;

  void _updateVolume(double newVolume) {
    setState(() {
      _currentVolume = newVolume.clamp(0.0, 1.0);
      _showVolumeHud = true; 
    });

    _volumeTimer?.cancel();
    _volumeTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showVolumeHud = false);
      }
    });
  }

  @override
  void dispose() {
    _volumeTimer?.cancel(); 
    _mainViewModel.dispose();
    _homeVm.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/starry_sky.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: ListenableBuilder(
            listenable: Listenable.merge([_mainViewModel, _homeVm]), 
            builder: (context, _) {
              final homeState = _homeVm.state;

              return Row(
                children: [
                  _sideMenu(), 
                  
                  Expanded(
                    child: Column(
                      children: [
                        // A. HEADER
                        HomeHeader(
                          timeText: homeState.timeText,
                          dateText: homeState.dateText,
                          isBluetoothOn: homeState.isBluetoothOn,
                          onToggleBluetooth: _homeVm.toggleBluetooth,
                    
                          onVolumeTap: () {
                             _updateVolume(_currentVolume ); 
                        
                          },
                        ),

                        Expanded(
                          child: Container(
                            color: const Color(0xFF0B0F19).withOpacity(0),
                            child: _buildPage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        VolumeHeadUpDisplay(
          isVisible: _showVolumeHud,
          volumeLevel: _currentVolume,
          onVolumeChanged: (newVal) {
             _updateVolume(newVal);
          },
        ),
      ],
    );
  }

  Widget _sideMenu() {
    return Container(
      width: 90,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const SizedBox(height: 100),
          _menuButton(Icons.phone, HmiPage.phone),
          const SizedBox(height: 100),
          _menuButton(Icons.home, HmiPage.home),
          const SizedBox(height: 100),
          _menuButton(Icons.movie, HmiPage.media),
          const SizedBox(height: 100),

          _menuButton(Icons.map, HmiPage.map),
        
        ],
      ),
    );
  }

  Widget _menuButton(IconData icon, HmiPage page) {
    final active = _mainViewModel.currentPage == page;
    return IconButton(
      iconSize: 32,
      color: active ? Colors.white : Colors.grey[700],
      onPressed: () => _mainViewModel.changePage(page),
      icon: Icon(icon),
    );
  }

  // ===== PAGE SWITCH =====
  Widget _buildPage() {
    switch (_mainViewModel.currentPage) {
      case HmiPage.home:
        return HomePage(
          vm: _homeVm, 
          onGoPhone: () => _mainViewModel.changePage(HmiPage.phone),
          onGoMedia: () => _mainViewModel.changePage(HmiPage.media),
          onGoMap: () => _mainViewModel.changePage(HmiPage.map),
        );
      case HmiPage.phone:
        return const PhonePage();
      case HmiPage.media:
        return const MediaPage();
      case HmiPage.map:
        return const MapScreen(); 
      
      default:
        return HomePage(vm: _homeVm);
    }
  }
}