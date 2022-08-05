import 'dart:developer';
import 'dart:math';

abstract class LvlUtil {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      "keepBuyng": "Keep contributing...",
      "veryGood": "Very good!",
      "registerMoreTickers": "Register more assets",
      "onFire": "On Fire!",
      "registerTickerToLevelUp":
          "Registering assets and making contributions increase your level!",
      "playAddHelpUs": "Watching ads helps us improve our app :D",
      "meetRebalance": "Meet our Portfolio Palancer: rebalance.com.br",
      "enjoingRate": "Are you enjoying it? rate our app",
      "notEnjoing": "Not liking it? rate our app too",
      "contributionsContributinos": "Contribution! Contribution! Contribution!",
      "helpUsFeedback":
          "Help us with new ideas! Send your feedback to: admin@rebalance.com.br",
      "ballancePorfolio": "Balance your wallet constantly!",
      "soon":
          "You will soon be able to integrate your assets with your Rebalance account: Wallet Balancer"
    },
    'es': {
      "keepBuyng": "Keep contributing...",
      "veryGood": "Very good!",
      "registerMoreTickers": "Register more assets",
      "onFire": "On Fire!",
      "registerTickerToLevelUp":
          "Registering assets and making contributions increase your level!",
      "playAddHelpUs": "Watching ads helps us improve our app :D",
      "meetRebalance": "Meet our Portfolio Palancer: rebalance.com.br",
      "enjoingRate": "Are you enjoying it? rate our app",
      "notEnjoing": "Not liking it? rate our app too",
      "contributionsContributinos": "Contribution! Contribution! Contribution!",
      "helpUsFeedback":
          "Help us with new ideas! Send your feedback to: admin@rebalance.com.br",
      "ballancePorfolio": "Balance your wallet constantly!",
      "soon":
          "You will soon be able to integrate your assets with your Rebalance account: Wallet Balancer"
    },
    'pt': {
      "keepBuyng": "Continue Aportando...",
      "veryGood": "Muito Bom!",
      "registerMoreTickers": "Cadastre mais ativos",
      "onFire": "On Fire!",
      "registerTickerToLevelUp":
          "Cadastrar ativos e realizar aportes aumentam o seu nível!",
      "playAddHelpUs": "Assistir anúncios nos ajuda a aprimorar nosso app :D",
      "meetRebalance":
          "Conheça o nosso balanceador de carteira: rebalance.com.br",
      "enjoingRate": "Está gostando? avalie nosso app",
      "notEnjoing": "Não está gostando? avalie nosso app também",
      "contributionsContributinos": "Aporte! Aporte! Aporte!",
      "helpUsFeedback":
          "Nos ajude com novas ideias! Envie seu feedback para: admin@rebalance.com.br",
      "ballancePorfolio": "Balanceie sua carteira constantemente!",
      "soon":
          "Em breve, você poderá integrar seus ativos com sua conta Rebalance: Balanceador de carteira"
    },
  };
  static List<String> tips = [
    'keepBuyng',
    'veryGood',
    'registerMoreTickers',
    'onFire',
    'registerTickerToLevelUp',
    'playAddHelpUs',
    'meetRebalance',
    'enjoingRate',
    'notEnjoing',
    'contributionsContributinos',
    'helpUsFeedback',
    'ballancePorfolio',
    'soon'
  ];

  static String randomTip(String localeName) {
    Random rnd;
    int min = 0;
    int max = tips.length - 1;
    rnd = Random();
    var tipKey = tips[rnd.nextInt(max - min)];
    return _localizedValues[localeName]![tipKey]!;
  }
}
