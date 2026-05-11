import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:taskez/BottomSheets/bottom_sheets.dart';
import 'package:taskez/Constants/constants.dart';
import 'package:taskez/Screens/Dashboard/dashboard.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Dashboard/bottomNavigationItem.dart';
import 'package:taskez/widgets/Dashboard/dashboard_add_icon.dart';
import 'package:taskez/widgets/Dashboard/dashboard_add_sheet.dart';

class Timeline extends StatefulWidget {
  Timeline({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  ValueNotifier<int> bottomNavigatorTrigger = ValueNotifier(0);
  final PageStorageBucket bucket = PageStorageBucket();

  static const double _pillHeight = 68;
  static const double _pillBottom = -16;
  static const double _pillSide = 24;

  @override
  Widget build(BuildContext context) {
    final systemBottom = MediaQuery.of(context).padding.bottom;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final pillColor =
        isLight ? const Color(0xFF5B5BF0) : const Color(0xFF2E3240);

    return Scaffold(
        backgroundColor: context.palette.surface,
        body: Stack(children: [
          DarkRadialBackground(
            color: context.palette.surface,
            position: "topLeft",
          ),
          // Conteúdo ocupa a tela inteira; passa por trás do pill.
          // O scroll do Dashboard tem padding interno para rolar
          // o último item acima do pill.
          ValueListenableBuilder(
              valueListenable: bottomNavigatorTrigger,
              builder: (BuildContext context, _, __) {
                return PageStorage(
                    child: dashBoardScreens[bottomNavigatorTrigger.value],
                    bucket: bucket);
              }),
          // Pill flutuante — fora do bottomNavigationBar para área transparente ao redor
          Positioned(
            left: _pillSide,
            right: _pillSide,
            bottom: _pillBottom + systemBottom,
            child: Container(
                height: _pillHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: pillColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      )
                    ]),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomNavigationItem(
                          itemIndex: 0,
                          notifier: bottomNavigatorTrigger,
                          icon: Icons.widgets),
                      BottomNavigationItem(
                          itemIndex: 1,
                          notifier: bottomNavigatorTrigger,
                          icon: FeatherIcons.clipboard),
                      DashboardAddButton(
                        iconTapped: (() {
                          showAppBottomSheet(Container(
                              height: Utils.screenHeight * 0.8,
                              child: DashboardAddBottomSheet()));
                        }),
                      ),
                      BottomNavigationItem(
                          itemIndex: 2,
                          notifier: bottomNavigatorTrigger,
                          icon: FeatherIcons.bell),
                      BottomNavigationItem(
                          itemIndex: 3,
                          notifier: bottomNavigatorTrigger,
                          icon: FeatherIcons.search)
                    ])),
          ),
        ]));
  }
}
