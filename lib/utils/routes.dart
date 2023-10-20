import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tricorder_zero/utils/observatory.dart';

import '../models/bottom_menu.dart';
import '../pages/home/home_screen.dart';
import '../pages/home_option_details/option_details.dart';
import '../pages/medications/medications_screen.dart';
import '../pages/my_records/my_records_screen.dart';
import '../pages/splash.dart';
import '../pages/telemedicine/telemedicine_screen.dart';

class Routes {
  static const home = "home";
  static const homeOption = "home-option";
  static const homeMedications = "home-medications";
  static const medications = "medications";
  static const homeMyRecords = "home-my-records";
  static const myRecords = "my-records";
  static const splash = "splash";
  static const homeTelehealth = "home-telehealth";
  static const telehealth = "telehealth";

  List<Widget> routesHistory = [];

  final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    observers: [Observatory()],
    routes: <GoRoute>[
      GoRoute(
        name: splash,
        path: '/',
        builder: (_, state) => const SplashScreen(),
      ),
      GoRoute(
        name: home,
        path: '/$home',
        pageBuilder: (context, state) {
          debugPrint('home location: ${state.location}');
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(
            name: homeTelehealth,
            path: telehealth,
            pageBuilder: (context, state) {
              debugPrint('telehealth location: ${state.location}');
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: const TelemedicineScreen(),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder: (_, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            name: homeMedications,
            path: medications,
            pageBuilder: (context, state) {
              debugPrint('Medications location: ${state.location}');
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: const MedicationsScreen(),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder: (_, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            name: homeMyRecords,
            path: myRecords,
            pageBuilder: (context, state) {
              debugPrint('record location: ${state.location}');
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: const MyRecrodsScreen(),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder: (_, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            name: homeOption,
            path: homeOption,
            pageBuilder: (context, state) {
              final String params = state.queryParams['title']!;
              final String type = state.queryParams['type']!;
              return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 300),
                child: HomeOptionDetails(
                  title: params,
                  optionType: type,
                ),
                transitionsBuilder: (_, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: telehealth,
        path: '/$telehealth',
        redirect: (state) => state.namedLocation(homeTelehealth),
      ),
      GoRoute(
        name: medications,
        path: '/$medications',
        redirect: (state) => state.namedLocation(homeMedications),
      ),
      GoRoute(
        name: myRecords,
        path: '/$myRecords',
        redirect: (state) => state.namedLocation(homeMyRecords),
      ),
    ],
  );
}
