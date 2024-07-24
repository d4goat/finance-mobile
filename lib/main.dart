import 'package:flutter/material.dart';
import 'package:frontend/main_layout.dart';
import 'package:frontend/models/auth_model.dart';
import 'package:frontend/screens/auth_page.dart';
import 'package:frontend/screens/invoice_page.dart';
import 'package:frontend/utils/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Kos Mcflyon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
                focusColor: Config.primaryColor,
                border: Config.outlinedBorder,
                focusedBorder: Config.focusBorder,
                errorBorder: Config.errorBorder,
                enabledBorder: Config.outlinedBorder,
                floatingLabelStyle: TextStyle(color: Colors.black),
                prefixIconColor: Colors.black),
            textTheme:
                GoogleFonts.libreFranklinTextTheme(Theme.of(context).textTheme),
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.indigoAccent,
                selectedItemColor: Colors.white,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.grey.shade700,
                elevation: 10,
                type: BottomNavigationBarType.fixed)),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          'main': (context) => const MainLayout(),
          'invoice': (context) => const InvoicePage()
        },
      ),
    );
  }
}
