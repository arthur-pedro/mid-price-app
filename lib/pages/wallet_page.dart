import 'package:flutter/material.dart';
import 'package:midpriceapp/database/asset/asset_repository.dart';
import 'package:midpriceapp/models/asset/asset.dart';
import 'package:midpriceapp/models/category/asset_brl_stock_category.dart';
import 'package:midpriceapp/pages/form/wallet_page_form.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  static const routeName = '/wallet';

  @override
  State<WalletPage> createState() => _WalletPage();
}

class _WalletPage extends State<WalletPage> {
  String title = "Minha Carteira - Rebalance";

  late List<Asset> wallet = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  // @override
  // void dispose() {
  //   AssetRepository.instance.close();
  //   super.dispose();
  // }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    wallet = await AssetRepository.instance.list();
    setState(() {
      isLoading = false;
    });
  }

  Future create(Asset asset) async {
    setState(() {
      isLoading = true;
    });
    await AssetRepository.instance.create(asset);
    await refresh();
    setState(() {
      isLoading = false;
    });
  }

  Future update(Asset asset) async {
    setState(() {
      isLoading = true;
    });
    await AssetRepository.instance.update(asset);
    await refresh();
    setState(() {
      isLoading = false;
    });
  }

  Future delete(Asset asset) async {
    setState(() {
      isLoading = true;
    });
    await AssetRepository.instance.delete(asset);
    await refresh();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final assetRepo = context.watch<AssetRepository>();
    // final loc = context.read();
    return wallet.isEmpty
        ? buildEmptyScreen(context)
        : buildList(context, wallet);
  }

  buildEmptyScreen(BuildContext context) {
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
                        {
                          setState(() {
                            create(value);
                          })
                        },
                    });
              },
              child: const Text('Adicionar'),
            )
          ],
        ),
      ),
    );
  }

  buildList(BuildContext context, List<Asset> assets) {
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
                  ).then((asset) => setState(() {
                        update(asset);
                      }))
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
                  if (asset != null)
                    {
                      setState(() {
                        create(asset);
                      })
                    }
                })
          },
          tooltip: 'Novo Investimento',
          child: const Icon(Icons.add),
        ));
  }
}
