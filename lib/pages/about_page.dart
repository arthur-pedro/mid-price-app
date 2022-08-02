import 'package:flutter/material.dart';
import 'package:midprice/ads/unity_ads_handler.dart';
import 'package:midprice/pages/dialog/dialog_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  String title = "Sobre o Rebalance";

  @override
  void initState() {
    super.initState();
  }

  void openThanksDialog() async {
    final action = await ViewDialogs.yesOrNoDialog(
        context,
        'Aeew!!',
        'Você está contribuindo para melhoria da platadorma. Obrigado pelo apoio! Deseja assistir outro anúncio?',
        'Agora não',
        'Sim! Anúncios são legais!');
    if (action == ViewDialogsAction.yes) {
      UnityAdsHandler.showVideoAd(
          () => {openThanksDialog()}, () => {}, () => {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                  'O Rebalance - Calculadora de preço médio é uma ferramenta oferecida pelo Rebalance, para auxiliar você a organizar seu portfólio. Neste app, é possivel cadastrar sua carteira e salvar seus aportes, obtendo o preço médio  de seus ativos.'),
              const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0)),
              const Text(
                  'Ajudando assim, a ter um histório de seus investimentos, e apoiando e facilitando também na declaração de imposto de renda.'),
              const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0)),
              const Text('Ajude-nos a melhorar assistindo um anúncio.'),
              ElevatedButton(
                  onPressed: () {
                    UnityAdsHandler.showVideoAd(
                        () => {openThanksDialog()}, () => {}, () => {});
                  },
                  child: const Text('Assistir anúncio :D')),
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
                child: const Text(
                    'Conheça nosso balanceador de carteira em rebalance.com.br'),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0)),
              const Text(
                  'Dúvidas e sugestões, entrar em contato pelo e-mail: admin@rebalance.com.br'),
              const Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0)),
              const Text('Versão do aplicativo v1.0.0')
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
                    'Copyright @${DateTime.now().year}, Todos os direitos reservados.',
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
