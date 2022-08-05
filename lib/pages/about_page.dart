import 'package:flutter/material.dart';
import 'package:midprice/ads/unity_ads_handler.dart';
import 'package:midprice/components/dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:midprice/locale/app_localizations_context.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  void openThanksDialog() async {
    final action = await ViewDialogs.yesOrNoDialog(
        context,
        'Aeew!!',
        context.loc.helpPlataformText,
        context.loc.notNow,
        context.loc.yesNiceAds);
    if (action == ViewDialogsAction.yes) {
      UnityAdsHandler.showVideoAd(
          () => {openThanksDialog()}, () => {}, () => {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.loc.aboutRebalanceTitle),
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(context.loc.aboutRebalanceDesc),
              const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0)),
              Text(context.loc.aboutRebalanceDescComplement),
              const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0)),
              Text(context.loc.helpUsPlayAdd),
              ElevatedButton(
                  onPressed: () {
                    UnityAdsHandler.showVideoAd(
                        () => {openThanksDialog()}, () => {}, () => {});
                  },
                  child: Text(context.loc.playAddSmile)),
              const Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
              TextButton(
                onPressed: () async {
                  const url = 'https://rebalance.com.br';
                  if (!await launchUrl(
                    Uri(scheme: 'https', host: 'rebalance.com.br'),
                    mode: LaunchMode.platformDefault,
                  )) {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(context.loc.meetRebalance),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0)),
              Text(context.loc.questionsAndSugestionContact),
              const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0)),
              Text('${context.loc.appVersion} v2.0.0')
            ])),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
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
                child: Column(children: [
                  Text(
                    'Copyright @${DateTime.now().year}, ${context.loc.copyright}.',
                    style: const TextStyle(fontSize: 10),
                  ),
                  const Text(
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
