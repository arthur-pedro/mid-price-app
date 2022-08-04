import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midprice/ads/unity_ads_handler.dart';
import 'package:midprice/components/snackbar.dart';
import 'package:midprice/database/asset/asset_repository.dart';
import 'package:midprice/database/config/config_repository.dart';
import 'package:midprice/database/deposit/deposit_repository.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/config/config.dart';
import 'package:midprice/models/deposit/deposit.dart';
import 'package:midprice/components/dialog.dart';
import 'package:midprice/models/deposit/enum_operation.dart';
import 'package:midprice/pages/form/deposit_form_page.dart';
import 'package:midprice/pages/form/wallet_form_page.dart';
import 'package:midprice/util/timeago_custom_message.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:midprice/locale/app_localizations_context.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({Key? key}) : super(key: key);

  @override
  State<DepositPage> createState() => _DepositPage();
}

class _DepositPage extends State<DepositPage> {
  String title = "Minha Carteira - Rebalance";

  late List<Asset> wallet = [];
  late List<Deposit> deposits = [];
  late Config config;
  bool isLoading = false;
  bool showTips = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  increaseDepositQuantityLimit() async {
    config.depositQuantityLimit += config.depositLimitStep;
    await ConfigRepository.instance.update(config);
    setState(() {});
  }

  Future refresh() async {
    setState(() {
      isLoading = true;
    });
    wallet = await AssetRepository.instance.list();
    deposits = await DepositRepository.instance.list();
    config = await ConfigRepository.instance.get(1);
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

  Future<ViewDialogsAction> openConfirmationDeleteDialog() async {
    return await ViewDialogs.yesOrNoDialog(
        context,
        context.loc.confirmation,
        context.loc.realyDeleteDeposit,
        context.loc.notNow,
        context.loc.deleteDeposit);
  }

  void _navigateToForm(Deposit? depositToCreateOrEdit) {
    Navigator.of(context)
        .push(_createRoute(DepositForm(
            deposit: depositToCreateOrEdit ??
                Deposit(
                    date: DateTime.now(),
                    quantity: 0.0,
                    payedValue: 0.0,
                    operation: Operation.buy,
                    fee: 0.0))))
        .then((asset) => {
              if (asset != null)
                {
                  setState(() {
                    if (depositToCreateOrEdit == null) {
                      create(asset);
                    } else {
                      update(asset);
                    }
                  })
                }
            });
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

  showSnackBar(String msg, ViewSnackbarStatus status) {
    ViewSnackbar.show(context, msg, status);
  }

  buildDepositEmptyScreen() {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_outlined, color: Colors.blueGrey),
            Text(context.loc.emptyDeposit),
            ElevatedButton(
              onPressed: () {
                _navigateToForm(null);
              },
              child: Text(context.loc.firstDeposit),
            ),
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
            !showTips
                ? const SizedBox.shrink()
                : Card(
                    margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.tips_and_updates_outlined,
                            color: Colors.amber,
                          ),
                          title: Text(context.loc.depositQuantityLimitRegister(
                              config.depositQuantityLimit)),
                          subtitle: Text(context.loc.playAddDepositTip),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: Text(context.loc.notNow.toUpperCase()),
                              onPressed: () {
                                setState(() {
                                  showTips = false;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              child: Text(context.loc.playAdd.toUpperCase()),
                              onPressed: () {
                                UnityAdsHandler.showVideoAd(
                                    () => {
                                          increaseDepositQuantityLimit(),
                                          ViewSnackbar.show(
                                              context,
                                              context.loc.increaseDepositLimit(
                                                  config.depositQuantityLimit),
                                              ViewSnackbarStatus.success)
                                        },
                                    () => {
                                          ViewSnackbar.show(
                                              context,
                                              context.loc.addFailedError,
                                              ViewSnackbarStatus.error)
                                        },
                                    () => {
                                          ViewSnackbar.show(
                                              context,
                                              context.loc.addSkipedError,
                                              ViewSnackbarStatus.warning)
                                        });
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                                deposits[index].operation == Operation.buy
                                    ? Icons.add_box
                                    : Icons.indeterminate_check_box,
                                size: 16,
                                color:
                                    deposits[index].operation == Operation.buy
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
                          '${deposits[index].quantity} ${context.loc.units} ${context.loc.currency} ${deposits[index].payedValue}'),
                      trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(context.loc.total),
                            Text(
                                '${context.loc.currency} ${((deposits[index].quantity * deposits[index].payedValue) + deposits[index].fee).toStringAsFixed(2)}'),
                          ]),
                      onTap: () => {_navigateToForm(deposits[index])},
                      onLongPress: (() async {
                        var action = await openConfirmationDeleteDialog();
                        if (action == ViewDialogsAction.yes) {
                          delete(deposits[index]);
                          showSnackBar(context.loc.deletedAssetFromWallet,
                              ViewSnackbarStatus.success);
                        }
                      }),
                    );
                  },
                  separatorBuilder: (_, ___) => const Divider(
                        height: 0,
                      ),
                  itemCount: deposits.length),
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (deposits.isNotEmpty &&
                deposits.length >= config.depositQuantityLimit) {
              final action = await ViewDialogs.yesOrNoDialog(
                  context,
                  context.loc.soManyContribution,
                  context.loc.limitAddContribution(
                      config.depositQuantityLimit, config.depositLimitStep),
                  context.loc.notNow,
                  context.loc.playAdd);
              if (action == ViewDialogsAction.yes) {
                UnityAdsHandler.showVideoAd(
                    () => {
                          increaseDepositQuantityLimit(),
                          ViewSnackbar.show(
                              context,
                              context.loc.increaseDepositLimit(
                                  config.depositQuantityLimit),
                              ViewSnackbarStatus.success)
                        },
                    () => {
                          ViewSnackbar.show(context, context.loc.addFailedError,
                              ViewSnackbarStatus.error)
                        },
                    () => {
                          ViewSnackbar.show(context, context.loc.addSkipedError,
                              ViewSnackbarStatus.warning)
                        });
              }
            } else {
              _navigateToForm(null);
            }
          },
          tooltip: context.loc.newDeposit,
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
            Text(context.loc.emptyShortWalletAlert),
            Text(context.loc.emptyShortWalletAlertComplement),
          ],
        ),
      ),
    );
  }
}
