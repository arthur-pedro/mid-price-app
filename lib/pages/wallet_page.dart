import 'dart:async';

import 'package:flutter/material.dart';
import 'package:midprice/ads/unity_ads_handler.dart';
import 'package:midprice/components/snackbar.dart';
import 'package:midprice/database/asset/asset_repository.dart';
import 'package:midprice/database/config/config_repository.dart';
import 'package:midprice/database/deposit/deposit_repository.dart';
import 'package:midprice/locale/locale_static_message.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/category/asset_brl_stock_category.dart';
import 'package:midprice/models/config/config.dart';
import 'package:midprice/components/dialog.dart';
import 'package:midprice/pages/form/wallet_form_page.dart';

import 'package:midprice/locale/app_localizations_context.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPage();
}

class _WalletPage extends State<WalletPage> {
  String title = "Minha Carteira - Rebalance";

  late Config config;
  late List<Asset> wallet = [];
  bool isLoading = false;
  bool showTips = true;

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
    config = await ConfigRepository.instance.get(1);
    setState(() {
      isLoading = false;
    });
  }

  increaseAssetQuantityLimit() async {
    config.assetQuantityLimit += config.assetLimitStep;
    await ConfigRepository.instance.update(config);
    setState(() {});
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
    await DepositRepository.instance.deleteByAsset(asset);
    await AssetRepository.instance.delete(asset);
    await refresh();
    setState(() {
      isLoading = false;
    });
  }

  Future<ViewDialogsAction> openConfirmationDeleteDialog(Asset asset) async {
    return await ViewDialogs.yesOrNoDialog(
        context,
        context.loc.confirmation,
        context.loc.realyDeleteFile(asset.name),
        context.loc.notNow,
        context.loc.deleteTicker);
  }

  Future<ViewDialogsAction> openConfirmationDeleteDialogAlreadyExist(
      Asset asset) async {
    return await ViewDialogs.yesOrNoDialog(
        context,
        context.loc.warning,
        context.loc.foreignKeyViolationOnDeleteTicker(asset.name),
        context.loc.notNow,
        context.loc.deleteAnyway);
  }

  Future<bool> hasDepositByAssetId(String assetName) async {
    return await DepositRepository.instance.hasDepositByAssetId(assetName);
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

  void _navigateToForm(Asset? assetToCreateOrEdit) {
    Navigator.of(context)
        .push(_createRoute(WalletForm(
            asset: assetToCreateOrEdit ??
                Asset(
                    name: '', price: 0.0, category: AssetBrlStockCategory()))))
        .then((asset) => {
              if (asset != null)
                {
                  setState(() {
                    if (assetToCreateOrEdit == null) {
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
    return wallet.isEmpty
        ? buildEmptyScreen(context)
        : buildList(context, wallet);
  }

  showSnackBar(String msg, ViewSnackbarStatus status) {
    ViewSnackbar.show(context, msg, status);
  }

  buildEmptyScreen(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_outlined, color: Colors.blueGrey),
            Text(context.loc.emptyWalletAlert),
            ElevatedButton(
              onPressed: () {
                _navigateToForm(null);
              },
              child: Text(context.loc.add),
            ),
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
            !showTips
                ? const SizedBox.shrink()
                : Card(
                    margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.tips_and_updates_outlined,
                              color: Colors.amber),
                          title: Text(context.loc.assetQuantityLimitRegister(
                              config.assetQuantityLimit)),
                          subtitle: Text(context.loc.playAddTip),
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
                                    () => {increaseAssetQuantityLimit()},
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
                      subtitle: Text(LocaleStaticMessage.translate(
                          context.loc.localeName,
                          assets[index].category.name.name)),
                      trailing: Text(
                          '${context.loc.currency} ${assets[index].price.toString()}'),
                      onTap: () => {_navigateToForm(assets[index])},
                      onLongPress: (() async {
                        var action =
                            await openConfirmationDeleteDialog(assets[index]);
                        if (action == ViewDialogsAction.yes) {
                          var hasDeposit =
                              await hasDepositByAssetId(assets[index].name);
                          if (hasDeposit) {
                            action =
                                await openConfirmationDeleteDialogAlreadyExist(
                                    assets[index]);
                            if (action == ViewDialogsAction.yes) {
                              delete(assets[index]);
                              showSnackBar(
                                  context.loc
                                      .snackDeleteMessage(assets[index].name),
                                  ViewSnackbarStatus.success);
                            }
                          } else {
                            delete(assets[index]);
                            showSnackBar(
                                context.loc
                                    .snackDeleteMessage(assets[index].name),
                                ViewSnackbarStatus.success);
                          }
                        }
                      }),
                    );
                  },
                  separatorBuilder: (_, ___) => const Divider(
                        height: 0,
                      ),
                  itemCount: assets.length),
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (wallet.isNotEmpty &&
                wallet.length >= config.assetQuantityLimit) {
              final action = await ViewDialogs.yesOrNoDialog(
                  context,
                  context.loc.fullWallet,
                  context.loc.limitAddAsset(
                      config.assetQuantityLimit, config.assetLimitStep),
                  context.loc.notNow,
                  context.loc.playAdd);
              if (action == ViewDialogsAction.yes) {
                UnityAdsHandler.showVideoAd(
                    () => {increaseAssetQuantityLimit(), _navigateToForm(null)},
                    () => {},
                    () => {});
              }
            } else {
              _navigateToForm(null);
            }
          },
          tooltip: context.loc.newDeposit,
          child: const Icon(Icons.add),
          // child: const Icon(Icons.add),
        ));
  }
}
