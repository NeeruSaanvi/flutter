import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tricorder_zero/pages/medications/medications_screen.dart';

import '../pages/home/home_screen.dart';
import '../pages/my_records/my_records_screen.dart';
import '../pages/telemedicine/telemedicine_screen.dart';
import '../utils/assets_constants.dart';
import '../utils/constants.dart';

class BottomMenu {
  final int id;
  final Widget widget;
  late String iconAsset;
  late String title;

  BottomMenu({
    required this.id,
    required this.widget,
    required this.iconAsset,
    required this.title,
  });
}

List<String> stacks = [];

UnmodifiableListView<BottomMenu> get bottomMenus =>
    UnmodifiableListView(_bottomMenus);

/* void updateBottomMenus(int index) {
  if (index == 0) {
    _bottomMenus[0].iconAsset = AssetsConstants.doctorsBag;
    _bottomMenus[0].title = Constants.fullScan;
  } else {
    _bottomMenus[0].iconAsset = AssetsConstants.home;
    _bottomMenus[0].title = Constants.home;
  }
} */

void updateBottomMenus({required bool showFullScan}) {
  if (showFullScan) {
    _bottomMenus[0].iconAsset = AssetsConstants.doctorsBag;
    _bottomMenus[0].title = Constants.fullScan;
  } else {
    _bottomMenus[0].iconAsset = AssetsConstants.home;
    _bottomMenus[0].title = Constants.home;
  }
}

List<BottomMenu> _bottomMenus = [
  BottomMenu(
    id: 1,
    widget: const HomeScreen(),
    iconAsset: AssetsConstants.doctorsBag,
    title: Constants.fullScan,
  ),
  BottomMenu(
    id: 2,
    widget: const TelemedicineScreen(),
    iconAsset: AssetsConstants.nurse,
    title: Constants.teleHealth,
  ),
  BottomMenu(
    id: 3,
    widget: const MedicationsScreen(),
    iconAsset: AssetsConstants.handWithAPill,
    title: Constants.medications,
  ),
  BottomMenu(
    id: 4,
    widget: const MyRecrodsScreen(),
    iconAsset: AssetsConstants.treatment,
    title: Constants.myRecords,
  )
];
