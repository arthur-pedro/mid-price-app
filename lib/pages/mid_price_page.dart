import 'package:flutter/material.dart';
import 'package:midprice/ads/unity_ads_handler.dart';
import 'package:midprice/database/asset/asset_repository.dart';
import 'package:midprice/database/config/config_repository.dart';
import 'package:midprice/database/deposit/deposit_repository.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/config/config.dart';
import 'package:midprice/models/deposit/deposit.dart';
import 'package:midprice/widgets/card/mid_price_card.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class Filter {
  bool selected;
  String text;
  int id;
  Filter({required this.selected, required this.text, required this.id});
}

class MidPricePage extends StatefulWidget {
  const MidPricePage({Key? key}) : super(key: key);

  @override
  State<MidPricePage> createState() => _MidPricePage();
}

class _MidPricePage extends State<MidPricePage> {
  String title = "Minha Carteira - Rebalance";

  List<Deposit> deposits = [];
  List<Asset> wallet = [];
  bool isLoading = false;
  late Config config;
  bool showTips = true;
  bool showDetails = false;
  String totalAported = '0.0';
  int totalBuyed = 0;
  int totalSelled = 0;

  List<MidPriceCard> cards = [];

  List<Filter> categoryFilters = [
    Filter(selected: false, text: 'Açoes', id: 1),
    Filter(selected: false, text: 'Fii', id: 2),
    Filter(selected: false, text: 'CDB', id: 3),
    Filter(selected: false, text: 'Tesouro', id: 4),
  ];
  List<Filter> yearFilters = [
    Filter(selected: false, text: 'Este ano', id: 1),
    Filter(selected: false, text: 'Último seis meses', id: 2),
    Filter(selected: false, text: 'Este mês', id: 1),
    Filter(selected: false, text: 'Todos', id: 4),
  ];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    wallet = await AssetRepository.instance.list();
    deposits = await DepositRepository.instance.list();
    // yearList = deposits.map((deposit) => deposit.date.year).toSet().toList();
    config = await ConfigRepository.instance.get(1);
    totalAported = getDetails();
    calculateLvl();
    for (var index = 0; index < wallet.length; index++) {
      cards.add(MidPriceCard(
          midPice: getMidprice(wallet[index], true),
          midPriceIndicator: getMidpriceIndicator(wallet[index]),
          assetPrice: wallet[index].price.toString(),
          assetName: wallet[index].name));
    }
    setState(() {
      isLoading = false;
    });
  }

  String getDetails() {
    var total = 0.0;
    for (var i = 0; i < deposits.length; i++) {
      final deposit = deposits[i];
      if (deposit.operation == 'Compra') {
        totalBuyed++;
        total += (deposit.payedValue * deposit.quantity) + deposit.fee;
      }
      if (deposit.operation == 'Venda') {
        totalSelled++;
        total -= (deposit.payedValue * deposit.quantity) + deposit.fee;
      }
    }
    return total.toStringAsFixed(2);
  }

  void calculateLvl() async {
    var totalAssets = wallet.length;
    var totalDeposits = deposits.length;
    const assetWeight = 0.8;
    const depositWeight = 0.2;
    var currentLvl =
        (((totalAssets * assetWeight) + (totalDeposits * depositWeight)) /
                (assetWeight + depositWeight))
            .floor()
            .abs();
    if (currentLvl < 1) {
      currentLvl = 1;
    }
    config.lvl = currentLvl;
    await ConfigRepository.instance.update(config);
  }

  @override
  Widget build(BuildContext context) {
    return wallet.isEmpty ? buildEmptyScreen() : buildList();
  }

  buildEmptyScreen() {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search_off_outlined, color: Colors.blueGrey),
            Text('Sua carteira esta vazia.'),
            Text('Adicione seu primeiro ativo na aba "CARTEIRA"!'),
          ],
        ),
      ),
    );
  }

  buildList() {
    return Scaffold(
        body: SingleChildScrollView(
      controller: ScrollController(keepScrollOffset: false),
      scrollDirection: Axis.vertical,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        !showTips
            ? const SizedBox.shrink()
            : Card(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Colors.teal,
                            ),
                            Text(
                              'Lvl: ${config.lvl}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ]),
                      title: const Text('Aporte! Aporte! Aporte!'),
                      subtitle: const Text(
                          'Assistir anúncios aumentará seus limites de aportes e quantidade de ativos na carteira.'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('FECHAR'),
                          onPressed: () {
                            setState(() {
                              showTips = false;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('DETALHAR'),
                          onPressed: () {
                            setState(() {
                              showDetails = true;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
        !showDetails
            ? const SizedBox.shrink()
            : Card(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.trending_up_outlined,
                        color: Colors.teal,
                      ),
                      title: Text('Total Investido R\$ $totalAported'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          Text(
                              '${deposits.length} aportes realizado(s), ${wallet.length} ativo(s) cadastrado(s).'),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          Text(
                              'Seu limite de ativos é ${config.assetQuantityLimit} podendo realizar até ${config.depositQuantityLimit} aportes'),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          Text(
                              'Você já realizou $totalBuyed ${totalBuyed == 1 ? 'operação' : 'operações'} de compra e $totalSelled ${totalSelled == 1 ? 'operação' : 'operações'} de venda'),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('FECHAR'),
                          onPressed: () {
                            setState(() {
                              showDetails = false;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
        ...cards
      ]),
    ));
  }

  String getMidprice(Asset asset, bool mask) {
    final filtredDeposits =
        deposits.where((deposit) => deposit.asset?.name == asset.name).toList();
    var totalCoust = 0.0;
    var totalQuantity = 0.0;
    var midprice = 0.0;

    for (var index = 0; index < filtredDeposits.length; index++) {
      final deposit = filtredDeposits[index];
      totalCoust += deposit.payedValue * deposit.quantity;
      totalQuantity += deposit.quantity;
    }

    midprice = totalCoust / totalQuantity;
    var res = '';
    if (mask) {
      res = !midprice.isNaN ? 'R\$ ${midprice.toStringAsFixed(2)}' : ' - ';
    } else {
      res = !midprice.isNaN ? midprice.toStringAsFixed(2) : '0';
    }
    return res;
  }

  Icon getMidpriceIndicator(Asset asset) {
    final midPrice = double.parse(getMidprice(asset, false));
    var res = const Icon(
      Icons.arrow_circle_up_outlined,
      size: 16,
      color: Colors.teal,
    );
    if (midPrice > asset.price) {
      res = const Icon(
        Icons.arrow_circle_down_outlined,
        size: 16,
        color: Colors.deepOrange,
      );
    }
    return res;
  }
}
