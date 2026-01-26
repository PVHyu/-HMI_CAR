import 'package:flutter/material.dart';
import '../viewmodels/phone_viewmodel.dart';
import 'widgets/dial_pad.dart';
import 'widgets/contact_list.dart';
import 'widgets/call_history.dart';
import 'widgets/in_call_ui.dart';
import 'widgets/bottom_bar.dart';
import '../models/enums.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final PhoneViewModel _viewModel = PhoneViewModel();
  static const double _radius = 18;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              color: const Color(0xFF121212),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: Column(
                children: [
                  Expanded(
                    child: _viewModel.isCalling
                        ? InCallUI(viewModel: _viewModel)
                        : Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: DialPad(viewModel: _viewModel),
                              ),
                              Expanded(
                                flex: 5,
                                child: _rightPanel(),
                              ),
                            ],
                          ),
                  ),
                  BottomBar(viewModel: _viewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _rightPanel() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.white24, width: 1),
        ),
      ),
      child: _viewModel.rightView == PhoneRightView.contacts
          ? ContactList(viewModel: _viewModel)
          : CallHistory(viewModel: _viewModel),
    );
  }
}
