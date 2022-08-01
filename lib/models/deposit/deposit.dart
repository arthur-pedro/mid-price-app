import 'package:midpriceapp/database/deposit/deposit_bo.dart';
import 'package:midpriceapp/models/asset/asset.dart';
import 'package:midpriceapp/util/parser.dart';

class Deposit {
  int? id;

  DateTime date;

  double quantity;

  Asset? asset;

  double payedValue;

  String operation;

  double fee;

  Deposit({
    this.id,
    this.asset,
    required this.date,
    required this.quantity,
    required this.payedValue,
    required this.operation,
    required this.fee,
  });

  static Deposit fromJson(Map<String, Object?> json) => Deposit(
      id: json[DepositBO.id] as int,
      date: Parser.millisecondsToDate(json[DepositBO.date] as int),
      quantity: Parser.stringToDouble(json[DepositBO.quantity] as String),
      asset: Asset(
          id: json[DepositBO.aliasPkAssetId] as int,
          name: json[DepositBO.aliasPkAssetName] as String,
          price: Parser.stringToDouble(
              json[DepositBO.aliasPkAssetPrice] as String),
          category: Asset.getCategory(
              json[DepositBO.aliasPkAssetCategory] as String)),
      payedValue: Parser.stringToDouble(json[DepositBO.payedValue] as String),
      operation: json[DepositBO.operation] as String,
      fee: Parser.stringToDouble(json[DepositBO.fee] as String));

  static Map<String, Object?> toJson(Deposit entity) => {
        DepositBO.id: entity.id,
        DepositBO.date: Parser.dateToMilliseconds(entity.date),
        DepositBO.quantity: Parser.doubleToString(entity.quantity),
        DepositBO.asset: entity.asset!.name,
        DepositBO.payedValue: Parser.doubleToString(entity.payedValue),
        DepositBO.operation: entity.operation,
        DepositBO.fee: Parser.doubleToString(entity.fee),
      };
}
