import 'package:flutter/material.dart';
import '../phone_app/viewmodels/phone_viewmodel.dart'; 
import '../home_app/viewmodels/home_view_model.dart';
import '../home_app/widgets/home_dashboard.dart';
import '../home_app/widgets/climate_bar.dart';

// 1. Chuyển sang StatefulWidget
class HomePage extends StatefulWidget {
  final HomeViewModel vm;
  final VoidCallback? onGoPhone;
  final VoidCallback? onGoMedia;
  final PhoneViewModel? phoneViewModel;
  final VoidCallback? onGoMap;


  const HomePage({
    super.key,
    required this.vm, 
    this.onGoPhone,
    this.onGoMedia,
    this.phoneViewModel,
    this.onGoMap,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _brightness = 0.8; 
  double _acTemp = 0.5;     

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.vm, 
      builder: (context, _) {
     

        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 30), 
          child: Column(
            children: [
              Expanded(
                child: HomeDashboard(
                  onGoPhone: widget.onGoPhone, 
                  onGoMedia: widget.onGoMedia,
                  phoneViewModel: widget.phoneViewModel, 
                  onGoMap: widget.onGoMap,
                ),
              ),
              
              const SizedBox(height: 25),
              
              ClimateBar(
                temperature: "28",
                humidity: "65",
                windSpeed: "12",
                rainChance: "10",

                brightness: _brightness,
                acTemp: _acTemp,

                onBrightnessChanged: (val) {
                  setState(() {
                    _brightness = val;
                  });
                },
                onAcTempChanged: (val) {
                  setState(() {
                    _acTemp = val;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}