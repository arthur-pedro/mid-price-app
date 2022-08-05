import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:midprice/ads/unity_ads_handler.dart';
import 'package:midprice/database/asset/asset_repository.dart';
import 'package:midprice/database/config/config_repository.dart';
import 'package:midprice/database/deposit/deposit_repository.dart';
import 'package:midprice/locale/locale_static_message.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/category/asset_brl_etf_category.dart';
import 'package:midprice/models/category/asset_brl_fii_category.dart';
import 'package:midprice/models/category/asset_brl_stock_category.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_category_list.dart';
import 'package:midprice/models/category/asset_cdb_category.dart';
import 'package:midprice/models/category/asset_treasure_category.dart';
import 'package:midprice/models/config/config.dart';
import 'package:midprice/models/deposit/deposit.dart';
import 'package:midprice/models/deposit/enum_operation.dart';
import 'package:midprice/theme/pallete.dart';
import 'package:midprice/util/lvl_messages.dart';
import 'package:midprice/widgets/card/mid_price_card.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:midprice/locale/app_localizations_context.dart';

class CategoryFilter {
  bool selected;
  AssetCategory category;
  int id;
  CategoryFilter(
      {required this.selected, required this.category, required this.id});
}

class PeriodFilter {
  bool selected;
  int year;
  int? id;
  PeriodFilter({required this.selected, required this.year, required this.id});
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
  String tip = '';
  List<int> yearList = [];
  List<MidPriceCard> cards = [];

  List<CategoryFilter> categoryFilters = [];

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

    config = await ConfigRepository.instance.get(1);

    totalAported = getDetails();

    calculateLvl();

    tip = LvlUtil.randomTip(context.loc.localeName);

    for (var index = 0; index < wallet.length; index++) {
      cards.add(MidPriceCard(
          midPice: getMidprice(wallet[index], true),
          midPriceIndicator: getMidpriceIndicator(wallet[index]),
          assetPrice: wallet[index].price.toString(),
          assetCategory: wallet[index].category,
          assetName: wallet[index].name));
    }

    for (var index = 0; index < AssetCategoryList.all().length; index++) {
      categoryFilters.add(CategoryFilter(
          selected: false,
          category: AssetCategoryList.all()[index],
          id: index));
    }

    for (var index = 0; index < deposits.length; index++) {
      yearList.add(deposits[index].date.year);
    }

    setState(() {
      isLoading = false;
    });
  }

  String getDetails() {
    var total = 0.0;
    for (var i = 0; i < deposits.length; i++) {
      final deposit = deposits[i];
      if (deposit.operation == Operation.buy) {
        totalBuyed++;
        total += (deposit.payedValue * deposit.quantity) + deposit.fee;
      }
      if (deposit.operation == Operation.sell) {
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
          children: [
            const Icon(Icons.search_off_outlined, color: Colors.blueGrey),
            Text(context.loc.emptyShortWalletAlert),
            Text(context.loc.emptyShortWalletAlertComplement),
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
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                      title: Text(tip),
                      subtitle: Text(context.loc.playAddTipGeneral),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(width: 8),
                        TextButton(
                          child: Text(context.loc.detail.toUpperCase()),
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
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.trending_up_outlined,
                        color: Colors.teal,
                      ),
                      title: Text(context.loc.totalInvested(totalAported)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          Text(context.loc.walletDetailMessage(
                              deposits.length, wallet.length)),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          Text(context.loc.walletDetailFirstComplementMessage(
                              config.assetQuantityLimit,
                              config.depositQuantityLimit)),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          Text(context.loc.walletDetailSecondComplementMessage(
                              totalBuyed, totalSelled)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: Text(context.loc.close.toUpperCase()),
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
        SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: getFilters(),
            )),
        ...getCards()
      ]),
    ));
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (builder) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: Colors.transparent,
            child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Center(child: getMoreFilters())),
          );
        });
  }

  GridView getMoreFilters() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Container(
            width: 70,
            height: 70,
            child: Icon(
              Icons.access_time_rounded,
              color: Palette.blue.shade500,
            ),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 216, 224, 242)),
          ),
        ),
      ],
    );
  }

  List<Widget> getFilters() {
    // return [getMoreFiltersChoiceChip(), getCategoryFiltersChoiceChip()]
    //     .expand((element) => element)
    //     .toList();
    return [getCategoryFiltersChoiceChip()]
        .expand((element) => element)
        .toList();
  }

  List<Widget> getMoreFiltersChoiceChip() {
    return List<Widget>.generate(
      1,
      growable: true,
      (int idx) {
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: ChoiceChip(
              selectedColor: Palette.blue.shade100,
              backgroundColor: Colors.white,
              selectedShadowColor: Colors.grey,
              elevation: 1,
              label: const Text(
                'Mais',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              avatar: const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              selected: false,
              onSelected: (bool selected) {
                _modalBottomSheetMenu();
              }),
        );
      },
    ).toList();
  }

  List<Widget> getCategoryFiltersChoiceChip() {
    return List<Widget>.generate(
      categoryFilters.length,
      growable: true,
      (int idx) {
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: ChoiceChip(
              selectedColor: Palette.blue.shade100,
              backgroundColor: Colors.white,
              selectedShadowColor: Colors.grey,
              elevation: 1,
              label: Text(
                LocaleStaticMessage.translate(context.loc.localeName,
                    categoryFilters[idx].category.name.name),
                style: TextStyle(
                    fontSize: 11,
                    color: categoryFilters[idx].selected
                        ? Palette.blue.shade700
                        : Colors.grey),
              ),
              selected: categoryFilters[idx].selected == true,
              onSelected: (bool selected) {
                setState(() {
                  categoryFilters[idx].selected =
                      !categoryFilters[idx].selected;
                });
              }),
        );
      },
    ).toList();
  }

  List<MidPriceCard> getCards() {
    List<String> selectedCategoryFilters = categoryFilters
        .where((category) => category.selected)
        .map((category) => category.category.name.name)
        .toList();
    List<MidPriceCard> filtredCards = cards
        .where((card) =>
            selectedCategoryFilters.contains(card.assetCategory.name.name))
        .toList();
    // List<PeriodFilterEnum> selectedPeriodFilters = periodFilter
    //     .where((period) => period.selected)
    //     .map((period) => period.id)
    //     .toList();

    List<MidPriceCard> result =
        selectedCategoryFilters.isNotEmpty ? filtredCards : cards;

    DateTime today = DateTime(2022, 8, 2, 8, 0, 0);
    // for (var i = 0; i < selectedPeriodFilters.length; i++) {
    //   switch (selectedPeriodFilters[i]) {
    //     case PeriodFilterEnum.today:
    //       List<String> filtredDeposits = deposits
    //           .where((deposit) =>
    //               deposit.date.year == today.year &&
    //               deposit.date.month == today.month &&
    //               deposit.date.day == today.day)
    //           .map((e) => e.asset!.name)
    //           .toList();
    //       result = result
    //           .where((card) => filtredDeposits.contains(card.assetName))
    //           .toList();
    //       break;
    //     case PeriodFilterEnum.monthly:
    //       List<String> filtredDeposits = deposits
    //           .where((deposit) =>
    //               deposit.date.year == today.year &&
    //               deposit.date.month == today.month)
    //           .map((e) => e.asset!.name)
    //           .toList();
    //       result = result
    //           .where((card) => filtredDeposits.contains(card.assetName))
    //           .toList();
    //       break;
    //     case PeriodFilterEnum.yearly:
    //       List<String> filtredDeposits = deposits
    //           .where((deposit) => deposit.date.year == today.year)
    //           .map((e) => e.asset!.name)
    //           .toList();
    //       result = result
    //           .where((card) => filtredDeposits.contains(card.assetName))
    //           .toList();
    //       break;
    //     default:
    //   }
    // }

    return result;
  }

  String getMidprice(Asset asset, bool mask) {
    final filtredDeposits = deposits
        .where((deposit) =>
            deposit.asset?.name == asset.name &&
            deposit.operation == Operation.buy)
        .toList();
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
      res = !midprice.isNaN
          ? '${context.loc.currency} ${midprice.toStringAsFixed(2)}'
          : ' - ';
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
