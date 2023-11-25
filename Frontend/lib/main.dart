import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ignite/design/colors.dart';
import 'package:theme_provider/theme_provider.dart';
import 'factories/servicesfactories/firestoreservicesfactory.dart';
import 'providers/auth_provider.dart';
import 'providers/services_provider.dart';
import 'views/login_screen.dart';

const String kIp = "192.168.1.92";
void main() {
  runApp(Ignite());
}

class Ignite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider().setFactory(FirestoreServicesFactory());
    ServicesProvider().setFactory(FirestoreServicesFactory());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return App();
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
          id: "main",
          description: "Tema principale",
          data: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: primaryColor,
            fontFamily: 'Nunito',
          ),
          options: CustomOptions(
            filename: 'map_style_main',
            brightness: Brightness.dark,
          ),
        ),
        AppTheme(
          id: "dark",
          description: "Tema scuro",
          data: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: darkColor,
            fontFamily: 'Nunito',
          ),
          options: CustomOptions(
            filename: 'map_style_dark',
            brightness: Brightness.light,
          ),
        ),
      ],
      child: ThemeConsumer(
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Nunito',
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('it'),
          ],
          home: LoginScreen(),
        ),
      ),
    );
  }
}

class CustomOptions implements AppThemeOptions {
  final String filename;
  final Brightness brightness;
  CustomOptions({
    required this.filename,
    required this.brightness,
  });
}
