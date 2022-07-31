import 'package:midpriceapp/database/asset/asset_bo.dart';
import 'package:midpriceapp/models/category/asset_brl_fii_category.dart';
import 'package:midpriceapp/models/category/asset_brl_stock_category.dart';
import 'package:midpriceapp/models/category/asset_category.dart';
import 'package:midpriceapp/util/parser.dart';

class Asset {
  @override
  bool operator ==(Object other) => other is Asset && other.name == name;

  @override
  int get hashCode => name.hashCode;

  int? id;

  String name;

  double price;

  AssetCategory category;

  Asset(
      {this.id,
      required this.name,
      required this.price,
      required this.category});

  static Asset fromJson(Map<String, Object?> json) => Asset(
      id: json[AssetBO.id] as int,
      name: json[AssetBO.name] as String,
      price: Parser.stringToDouble(json[AssetBO.price] as String),
      category: getCategory(json[AssetBO.category] as String));

  static Map<String, Object?> toJson(Asset asset) => {
        AssetBO.id: asset.id,
        AssetBO.name: asset.name,
        AssetBO.price: Parser.doubleToString(asset.price),
        AssetBO.category: asset.category.id
      };

  static AssetCategory getCategory(String category) {
    AssetCategory res;
    switch (category) {
      case 'ACAO':
        res = AssetBrlStockCategory();
        break;
      case 'FUNDO_INVESTIMENTO_IMOBILIARIO':
        res = AssetBrlFiiCategory();
        break;
      default:
        res = AssetBrlStockCategory();
        break;
    }
    return res;
  }
}
