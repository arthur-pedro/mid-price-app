import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:midpriceapp/adMob/google_ad_mob_handler.dart';
import 'package:midpriceapp/database/db_provider.dart';
import 'package:midpriceapp/pages/about_page.dart';
import 'package:midpriceapp/pages/deposit_page.dart';
import 'package:midpriceapp/pages/mid_price_page.dart';
import 'package:midpriceapp/pages/wallet_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:midpriceapp/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(testDeviceIds: [getAppId()]);
  runApp(
      //   MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider(create: (context) => AssetRepository()),
      //   ],
      //   child: const MyApp(),
      // )
      const MyApp());
}

String getAppId() => Platform.isIOS
    ? GoogleAdmobHandler.iosAppId
    : GoogleAdmobHandler.androidApId;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CustomTheme customTheme = CustomTheme(context: context);

    DBProvider();

    GoogleAdmobHandler.initAdmobInterstitial();

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
            elevation: 5,
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
