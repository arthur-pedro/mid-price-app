import 'package:flutter/material.dart';

class MidPriceCard extends StatelessWidget {
  String assetName;
  String assetPrice;
  String midPice;
  Icon midPriceIndicator;
  MidPriceCard(
      {Key? key,
      required this.midPice,
      required this.midPriceIndicator,
      required this.assetPrice,
      required this.assetName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        minLeadingWidth: 20,
        leading: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[midPriceIndicator]),
        title: Text(assetName),
        subtitle: Text('Preço atual R\$ $assetPrice'),
        trailing: Text(midPice),
        onTap: () => {},
      ),
    );
  }
}
