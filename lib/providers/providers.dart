import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tricorder_zero/controllers/bluetooth_controller.dart';
import 'package:tricorder_zero/controllers/ekg_controller.dart';

import '../controllers/app_state_controller.dart';
import '../themes/theme_manager.dart';
import '../utils/otoscope.dart';
import '../utils/routes.dart';

final providerThemeManager = ChangeNotifierProvider<ThemeManager>((ref) {
  return ThemeManager();
});

final provideStateController = ChangeNotifierProvider((ref) {
  return AppStateController();
});

final provideOtoScopeInstance = ChangeNotifierProvider((ref) {
  return OtoScope();
});

final provideRoutes = Provider((ref) {
  return Routes();
});

final provideBluetoothController = Provider((ref) {
  return BluetoothController();
});

final provideEkgController = Provider((ref) {
  return EkgController();
});
