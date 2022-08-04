import 'package:flutter/material.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/locale/app_localizations_context.dart';

class MidPriceCard extends StatelessWidget {
  String assetName;
  String assetPrice;
  String midPice;
  Icon midPriceIndicator;
  AssetCategory assetCategory;
  MidPriceCard(
      {Key? key,
      required this.midPice,
      required this.midPriceIndicator,
      required this.assetPrice,
      required this.assetName,
      required this.assetCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        minLeadingWidth: 20,
        leading: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[midPriceIndicator]),
        title: Text(
          assetName,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(context.loc.currentAssetPrice(assetPrice)),
        trailing: Text('${context.loc.pm} $midPice'),
        onTap: () => {},
      ),
    );
  }
}
