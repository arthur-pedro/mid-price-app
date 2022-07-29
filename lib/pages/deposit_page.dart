import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midpriceapp/models/asset.dart';
import 'package:midpriceapp/models/asset_brl_stock_category.dart';
import 'package:midpriceapp/models/deposit.dart';
import 'package:midpriceapp/pages/form/deposit_page_form.dart';
import 'package:midpriceapp/pages/form/wallet_page_form.dart';
import 'package:midpriceapp/util/timeago_custom_message.dart';
import 'package:timeago/timeago.dart' as timeago;

class DepositPage extends StatefulWidget {
  const DepositPage({Key? key}) : super(key: key);

  @override
  State<DepositPage> createState() => _DepositPage();
}

class _DepositPage extends State<DepositPage> {
  String title = "Minha Carteira - Rebalance";

  List<Deposit> deposits = []; // DepositRepository.tabela;
  List<Asset> assets = []; //AssetRepository.tabela;

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('pt_br', TimeagoCustomMessage());
    return assets.isEmpty
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
              child: const Text('Primeiro aporte'),
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
                leading: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Icon(
                          Icons.add_box,
                          size: 16,
                          color: Colors.teal,
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
                trailing: Text(
                    'R\$ ${(deposits[index].quantity * deposits[index].payedValue).toStringAsFixed(2)}'),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DepositForm(deposit: deposits[index]),
                    ),
                  ).whenComplete(() => setState(() {}))
                },
              );
            },
            separatorBuilder: (_, ___) => const Divider(
                  height: 0,
                ),
            itemCount: deposits.length),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DepositForm(
                        deposit: Deposit(
                            payedValue: 0, date: DateTime.now(), quantity: 0),
                      )),
            ).then((deposit) => {
                  setState(() => {deposits.add(deposit)})
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
}
