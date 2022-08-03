import 'dart:math';

abstract class LvlUtil {
  static List<String> tips = [
    'Continue Aportando...',
    'Muito Bom!',
    'Cadastre mais ativos',
    'On Fire!',
    'Cadastrar ativos e realizar aportes aumentam o seu nível!',
    'Assistir anúncios nos ajuda a aprimorar nosso app :D',
    'Assistir anúncios nos ajuda a aprimorar nosso app :D',
    'Conheça o nosso balanceador de carteira: rebalance.com.br',
    'Em breve, você poderá integrar seus ativos com sua conta Rebalance: Balanceador de carteira',
    'Mago dos investimento',
    'Está gostando? avalie nosso app',
    'Não está gostando? avalie nosso app também',
    'Aporte! Aporte! Aporte!',
    'Nos ajude com novas ideias! Envie seu feedback para: admin@rebalance.com.br',
    'Balanceie sua carteira constantemente!',
  ];

  static String randomTip() {
    Random rnd;
    int min = 0;
    int max = tips.length - 1;
    rnd = Random();
    return tips[rnd.nextInt(max - min)];
  }
}
