import 'package:midpriceapp/models/asset.dart';
import 'package:midpriceapp/models/asset_brl_stock_category.dart';

class AssetRepository {
  static List<Asset> tabela = [
    Asset(id: 1, name: "ITSA4", price: 8.54, category: AssetBrlStockCategory()),
    Asset(
        id: 2, name: "BBDC4", price: 28.54, category: AssetBrlStockCategory()),
    Asset(id: 3, name: "MGLU3", price: 2.54, category: AssetBrlStockCategory()),
    Asset(
        id: 4, name: "TAE11", price: 48.54, category: AssetBrlStockCategory()),
  ];
}
