import 'package:flutter/material.dart';
import 'package:midpriceapp/pages/deposit_page.dart';
import 'package:midpriceapp/pages/mid_price_page.dart';
import 'package:midpriceapp/pages/wallet_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:midpriceapp/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      //   MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider(create: (context) => AssetRepository()),
      //   ],
      //   child: const MyApp(),
      // )
      const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CustomTheme customTheme = CustomTheme(context: context);

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
                  child: const Icon(Icons.settings),
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
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.066,
            child: Center(
              child: TextButton(
                onPressed: () async {
                  const url = 'https://rebalance.com.br';
                  if (!await launchUrl(
                    Uri(scheme: 'https', host: 'rebalance.com.br'),
                    mode: LaunchMode.platformDefault,
                  )) {
                    throw 'Could not launch $url';
                  }
                },
                child: Column(children: const [
                  Text(
                    'Copyright @2022, Todos os direitos reservados.',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    'Powered by Rebalance',
                    style: TextStyle(fontSize: 10),
                  )
                ]),
              ),
            ),
          ),
        ));
  }
}
