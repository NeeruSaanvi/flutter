import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/providers.dart';
import 'themes/theme_constants.dart';

class TricorderApp extends ConsumerStatefulWidget {
  const TricorderApp({Key? key}) : super(key: key);

  @override
  _TricorderAppState createState() => _TricorderAppState();
}

class _TricorderAppState extends ConsumerState<TricorderApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Tricorder.Zero',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ref.watch(providerThemeManager).themeMode,
      routeInformationParser:
          ref.read(provideRoutes).router.routeInformationParser,
      routerDelegate: ref.read(provideRoutes).router.routerDelegate,
    );
  }
}
