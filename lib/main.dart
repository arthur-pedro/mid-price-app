import 'dart:io';

import 'package:flutter/material.dart';
import 'package:midprice/ads/unity_ads_handler.dart';
import 'package:midprice/database/db_provider.dart';
import 'package:midprice/pages/about_page.dart';
import 'package:midprice/pages/deposit_page.dart';
import 'package:midprice/pages/mid_price_page.dart';
import 'package:midprice/pages/wallet_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:midprice/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CustomTheme customTheme = CustomTheme(context: context);

    DBProvider();

    UnityAdsHandler.init();

    return MaterialApp(
      theme: ThemeData(
          primarySwatch: customTheme.blue(), //
          textTheme: customTheme.textTheme(),
          tabBarTheme: customTheme.tabBarTheme()),
      home: const TabPage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
    );
  }
}

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPagePageState();
}

class _TabPagePageState extends State<TabPage> {
  final String title = 'Rebalance';

  Route _createRoute(AboutPage page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 10,
            elevation: 0,
            leadingWidth: 45,
            leading: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'NunitoBold'),
            ),
            actions: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).push(_createRoute(const AboutPage()));
                  },
                ),
              ),
            ],
            bottom: const TabBar(
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'PREÇO MÉDIO'),
                Tab(text: 'APORTES'),
                Tab(text: 'CARTEIRA'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MidPricePage(),
              DepositPage(),
              WalletPage(),
            ],
          ),
        ),
      ),
    );
  }
}
