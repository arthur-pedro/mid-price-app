import 'package:flutter/material.dart';
import 'package:midpriceapp/models/asset/asset.dart';
import 'package:midpriceapp/models/category/asset_brl_stock_category.dart';
import 'package:midpriceapp/models/deposit/deposit.dart';
import 'package:midpriceapp/pages/form/wallet_page_form.dart';

class MidPricePage extends StatefulWidget {
  const MidPricePage({Key? key}) : super(key: key);

  @override
  State<MidPricePage> createState() => _MidPricePage();
}

class _MidPricePage extends State<MidPricePage> {
  String title = "Minha Carteira - Rebalance";

  List<Deposit> deposits = []; //DepositRepository.tabela;
  List<Asset> assets = []; //AssetRepository.tabela;

  @override
  Widget build(BuildContext context) {
    return assets.isEmpty ? buildEmptyScreen() : buildList();
  }

  buildEmptyScreen() {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_outlined, color: Colors.blueGrey),
            const Text('Sua carteira esta vazia. Adicione seu primeiro ativo!'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WalletForm(
                        asset: Asset(
                            name: '',
                            price: 0.0,
                            category: AssetBrlStockCategory())),
                  ),
                ).then((value) => {
                      if (value != null)
                        setState(() {
                          assets.add(value);
                        }),
                    });
              },
              child: const Text('Adicionar'),
            )
          ],
        ),
      ),
    );
  }

  buildList() {
    return Scaffold(
        body: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(10),
                minLeadingWidth: 20,
                leading: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[getMidpriceIndicator(assets[index])]),
                title: Text(assets[index].name),
                subtitle: Text('Preço atual R\$ ${assets[index].price}'),
                trailing: Text(getMidprice(assets[index], true)),
                onTap: () => {},
              );
            },
            separatorBuilder: (_, ___) => const Divider(
                  height: 0,
                ),
            itemCount: assets.length));
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
