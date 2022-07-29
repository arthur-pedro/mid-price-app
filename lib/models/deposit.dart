import 'package:midpriceapp/models/asset.dart';

class Deposit {
  int? id;

  DateTime date;

  double quantity;

  Asset? asset;

  double payedValue;

  Deposit({
    this.id,
    this.asset,
    required this.date,
    required this.quantity,
    required this.payedValue,
  });
}
