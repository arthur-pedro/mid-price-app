import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midprice/adMob/google_ad_mob_handler.dart';
import 'package:midprice/database/asset/asset_repository.dart';
import 'package:midprice/database/deposit/deposit_repository.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/category/asset_brl_stock_category.dart';
import 'package:midprice/models/deposit/deposit.dart';
import 'package:midprice/pages/form/deposit_form_page.dart';
import 'package:midprice/pages/form/wallet_form_page.dart';
import 'package:midprice/util/timeago_custom_message.dart';
import 'package:timeago/timeago.dart' as timeago;

class DepositPage extends StatefulWidget {
  const DepositPage({Key? key}) : super(key: key);

  @override
  State<DepositPage> createState() => _DepositPage();
}

class _DepositPage extends State<DepositPage> {
  String title = "Minha Carteira - Rebalance";

  late List<Asset> wallet = [];
  late List<Deposit> deposits = [];
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
    deposits = await DepositRepository.instance.list();
    setState(() {
      isLoading = false;
    });
  }

  Future create(Deposit entity) async {
    setState(() {
      isLoading = true;
    });
    await DepositRepository.instance.create(entity);
    await refresh();
    setState(() {
      isLoading = false;
    });
  }

  Future createAsset(Asset entity) async {
    setState(() {
      isLoading = true;
    });
    await AssetRepository.instance.create(entity);
    await refresh();
    setState(() {
      isLoading = false;
    });
  }

  Future update(Deposit entity) async {
    setState(() {
      isLoading = true;
    });
    await DepositRepository.instance.update(entity);
    await refresh();
    setState(() {
      isLoading = false;
    });
  }

  Future delete(Deposit entity) async {
    setState(() {
      isLoading = true;
    });
    await DepositRepository.instance.delete(entity);
    await refresh();
    setState(() {
      isLoading = false;
    });
  }

  Route _createRoute(DepositForm page) {
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

  Route _createRouteWallet(WalletForm page) {
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
    timeago.setLocaleMessages('pt_br', TimeagoCustomMessage());
    return wallet.isEmpty
        ? buildAssetEmptyScreen()
        : deposits.isEmpty
            ? buildDepositEmptyScreen()
            : buildList();
  }

  buildDepositEmptyScreen() {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_outlined, color: Colors.blueGrey),
            const Text('Nenhum aporte encontrado. Faça seu primeiro aporte!'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(_createRoute(DepositForm(
                        deposit: Deposit(
                            date: DateTime.now(),
                            quantity: 0.0,
                            payedValue: 0.0,
                            operation: 'Compra',
                            fee: 0.0))))
                    .then((value) => {
                          if (value != null)
                            {
                              setState(() {
                                create(value);
                              })
                            },
                        });
              },
              child: const Text('Primeiro aporte'),
            ),
            Container(
                child:
                    GoogleAdmobHandler.getBanner(AdmobBannerSize.FULL_BANNER)),
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
                      leading: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                deposits[index].operation == 'Compra'
                                    ? Icons.add_box
                                    : Icons.indeterminate_check_box,
                                size: 16,
                                color: deposits[index].operation == 'Compra'
                                    ? Colors.teal
                                    : Colors.deepOrange,
                              ),
                              Text(DateFormat('d/MMM', "pt_BR")
                                  .format(deposits[index].date)),
                              Text(timeago.format(deposits[index].date,
                                  locale: 'pt_br')),
                            ]),
                      ),
                      title: Text(deposits[index].asset!.name),
                      subtitle: Text(
                          '${deposits[index].quantity} unidades a R\$ ${deposits[index].payedValue}'),
                      trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            const Text('Total'),
                            Text(
                                'R\$ ${((deposits[index].quantity * deposits[index].payedValue) + deposits[index].fee).toStringAsFixed(2)}'),
                          ]),
                      onTap: () => {
                        Navigator.of(context)
                            .push(_createRoute(
                                DepositForm(deposit: deposits[index])))
                            .then((value) => {
                                  if (value != null)
                                    {
                                      setState(() {
                                        update(value);
                                      })
                                    },
                                })
                      },
                    );
                  },
                  separatorBuilder: (_, ___) => const Divider(
                        height: 0,
                      ),
                  itemCount: deposits.length),
            )),
            Container(
                child:
                    GoogleAdmobHandler.getBanner(AdmobBannerSize.FULL_BANNER)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.of(context)
                .push(_createRoute(DepositForm(
                    deposit: Deposit(
                        payedValue: 0,
                        date: DateTime.now(),
                        quantity: 0,
                        operation: 'Compra',
                        fee: 0.0))))
                .then((value) => {
                      if (value != null)
                        {
                          setState(() {
                            if (deposits.isNotEmpty &&
                                (deposits.length % 5) == 0) {
                              GoogleAdmobHandler.showInterstitial();
                            }
                            create(value);
                          })
                        },
                    })
          },
          tooltip: 'Novo Investimento',
          child: const Icon(Icons.add),
        ));
  }

  buildAssetEmptyScreen() {
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
                    .push(_createRouteWallet(WalletForm(
                        asset: Asset(
                            name: '',
                            price: 0.0,
                            category: AssetBrlStockCategory()))))
                    .then((value) => {
                          if (value != null)
                            {
                              setState(() {
                                createAsset(value);
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
}
