import 'package:flutter/material.dart';
import 'package:taskez/Data/data_model.dart';
import 'package:taskez/Values/values.dart';
import 'package:taskez/l10n/app_localizations.dart';
import 'package:taskez/widgets/Buttons/primary_buttons.dart';
import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:taskez/widgets/Forms/search_box.dart';
import 'package:taskez/widgets/Navigation/app_header.dart';
import 'package:taskez/widgets/employee_card.dart';

class SelectMembersScreen extends StatelessWidget {
  SelectMembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final _searchController = new TextEditingController();
    final dynamic data = AppData.employeeData;
    List<Widget> cards = List.generate(
        AppData.employeeData.length,
        (index) => EmployeeCard(
              activated: data[index]['activated'],
              employeeImage: data[index]['employeeImage'],
              employeeName: data[index]['employeeName'],
              backgroundColor: data[index]["color"],
              employeePosition: data[index]["employeePosition"],
            ));
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: context.palette.surface,
        position: "topLeft",
      ),
      Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: TaskezAppHeader(
                title: l.setAssigneesTitle,
                widget: AppPrimaryButton(
                  buttonHeight: 40,
                  buttonWidth: 70,
                  buttonText: l.commonNext,
                ),
              ),
            ),
            AppSpaces.verticalSpace40,
            Expanded(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecorationStyles.fadingGlory(context),
                    child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DecoratedBox(
                            decoration: BoxDecorationStyles.fadingInnerDecor(context),
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SearchBox(
                                        placeholder: l.commonSearch,
                                        controller: _searchController,
                                      ),
                                      AppSpaces.verticalSpace20,
                                      Expanded(
                                          child: MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        child: ListView(children: [...cards]),
                                      ))
                                    ])))))),
            //AppSpaces.verticalSpace20,
            AppPrimaryButton(
                buttonHeight: 50,
                buttonWidth: 150,
                buttonText: l.setMembersAddMember,
                callback: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                }),
            AppSpaces.verticalSpace20,
          ]))
    ]));
  }
}
