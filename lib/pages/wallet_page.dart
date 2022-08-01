import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:midpriceapp/adMob/google_ad_mob_handler.dart';
import 'package:midpriceapp/database/asset/asset_repository.dart';
import 'package:midpriceapp/models/asset/asset.dart';
import 'package:midpriceapp/models/category/asset_brl_stock_category.dart';
import 'package:midpriceapp/pages/form/wallet_form_page.dart';

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

  Route _createRoute(WalletForm page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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
                Navigator.of(context)
                    .push(_createRoute(WalletForm(
                        asset: Asset(
                            name: '',
                            price: 0.0,
                            category: AssetBrlStockCategory()))))
                    .then((value) => {
                          if (value != null)
                            {
                              setState(() {
                                create(value);
                              })
                            },
                        });
              },
              child: const Text('Adicionar'),
            ),
            Container(
                child:
                    GoogleAdmobHandler.getBanner(AdmobBannerSize.FULL_BANNER)),
          ],
        ),
      ),
    );
  }

  buildList(BuildContext context, List<Asset> assets) {
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
                        Navigator.of(context)
                            .push(
                                _createRoute(WalletForm(asset: assets[index])))
                            .then((asset) => setState(() {
                                  if (asset != null) {
                                    update(asset);
                                  }
                                }))
                      },
                    );
                  },
                  separatorBuilder: (_, ___) => const Divider(
                        height: 0,
                      ),
                  itemCount: assets.length),
            )),
            Container(
                child:
                    GoogleAdmobHandler.getBanner(AdmobBannerSize.FULL_BANNER)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.of(context)
                .push(_createRoute(WalletForm(
                    asset: Asset(
                        name: '',
                        price: 0.0,
                        category: AssetBrlStockCategory()))))
                .then((asset) => {
                      if (asset != null)
                        {
                          setState(() {
                            if (wallet.isNotEmpty && (wallet.length % 5) == 0) {
                              GoogleAdmobHandler.showInterstitial();
                            }
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
