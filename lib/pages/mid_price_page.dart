import 'dart:developer';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:midprice/adMob/google_ad_mob_handler.dart';
import 'package:midprice/database/asset/asset_repository.dart';
import 'package:midprice/database/deposit/deposit_repository.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/category/asset_brl_stock_category.dart';
import 'package:midprice/models/deposit/deposit.dart';
import 'package:midprice/pages/form/wallet_form_page.dart';

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
  int yearFilter = DateTime.now().year;
  List<int> yearList = [];

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
    yearList = deposits.map((deposit) => deposit.date.year).toList();
    setState(() {
      isLoading = false;
    });
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
          children: [
            const Icon(Icons.search_off_outlined, color: Colors.blueGrey),
            const Text('Sua carteira esta vazia.'),
            const Text('Adicione seu primeiro ativo na aba "CARTEIRA"!'),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => WalletForm(
            //             asset: Asset(
            //                 name: '',
            //                 price: 0.0,
            //                 category: AssetBrlStockCategory())),
            //       ),
            //     ).then((value) => {
            //           if (value != null)
            //             setState(() {
            //               wallet.add(value);
            //             }),
            //         });
            //   },
            //   child: const Text('Adicionar'),
            // )
          ],
        ),
      ),
    );
  }

  buildList() {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
            child: SizedBox(
                height: 200.0,
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        minLeadingWidth: 20,
                        leading: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              getMidpriceIndicator(wallet[index])
                            ]),
                        title: Text(wallet[index].name),
                        subtitle:
                            Text('Preço atual R\$ ${wallet[index].price}'),
                        trailing: Text(getMidprice(wallet[index], true)),
                        onTap: () => {},
                      );
                    },
                    separatorBuilder: (_, ___) => const Divider(
                          height: 0,
                        ),
                    itemCount: wallet.length))),
        Container(
            child: GoogleAdmobHandler.getBanner(AdmobBannerSize.FULL_BANNER)),
      ],
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
