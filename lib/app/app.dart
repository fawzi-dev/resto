import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '../core/localization/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/menu/presentation/screens/menu_screen.dart';
import 'dependencies.dart';

class RestoApp extends StatelessWidget {
  const RestoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildAppProviders(),
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // Copy is Kurdish (Sorani); the Arabic locale gives us RTL + sane
        // number/locale fallbacks out of the box.
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const MenuScreen(),
      ),
    );
  }
}
