import 'package:midpriceapp/models/asset.dart';
import 'package:midpriceapp/models/asset_brl_stock_category.dart';
import 'package:midpriceapp/models/deposit.dart';

class DepositRepository {
  static List<Deposit> tabela = [
    Deposit(
        quantity: 8.54,
        payedValue: 5,
        asset: Asset(
            id: 1, category: AssetBrlStockCategory(), name: 'ITSA4', price: 0),
        date: DateTime(2022, 7, 7),
        id: 1),
  ];
}
