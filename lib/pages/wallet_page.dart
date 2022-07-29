import 'package:flutter/material.dart';
import 'package:midpriceapp/models/asset.dart';
import 'package:midpriceapp/models/asset_brl_stock_category.dart';
import 'package:midpriceapp/pages/form/wallet_page_form.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  static const routeName = '/wallet';

  @override
  State<WalletPage> createState() => _WalletPage();
}

class _WalletPage extends State<WalletPage> {
  String title = "Minha Carteira - Rebalance";
  List<Asset> assets = [];

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
                minLeadingWidth: 10,
                leading: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      assets[index].category.icon,
                    ]),
                title: Text(
                  assets[index].name,
                ),
                subtitle: Text(assets[index].category.name),
                trailing: Text('R\$ ${assets[index].price.toString()}'),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WalletForm(asset: assets[index]),
                    ),
                  ).whenComplete(() => setState(() {}))
                },
              );
            },
            separatorBuilder: (_, ___) => const Divider(
                  height: 0,
                ),
            itemCount: assets.length),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WalletForm(
                    asset: Asset(
                        category: AssetBrlStockCategory(), name: '', price: 0)),
              ),
            ).then((asset) => {
                  setState(() => {assets.add(asset)})
                })
          },
          tooltip: 'Novo Investimento',
          child: const Icon(Icons.add),
        ));
  }
}
