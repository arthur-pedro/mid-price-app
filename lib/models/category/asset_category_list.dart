import 'package:midprice/models/category/asset_brl_etf_category.dart';
import 'package:midprice/models/category/asset_brl_fii_category.dart';
import 'package:midprice/models/category/asset_brl_stock_category.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_cdb_category.dart';
import 'package:midprice/models/category/asset_others_category.dart';
import 'package:midprice/models/category/asset_treasure_category.dart';
import 'package:midprice/models/category/asset_usd_etf_category.dart';
import 'package:midprice/models/category/asset_usd_fii_category.dart';
import 'package:midprice/models/category/asset_usd_stock_category.dart';

abstract class AssetCategoryList {
  static List<AssetCategory> all() {
    return [
      AssetBrlStockCategory(),
      AssetUsdStockCategory(),
      AssetBrlFiiCategory(),
      AssetUsdFiiCategory(),
      AssetTreasureCategory(),
      AssetBrlEtfCategory(),
      AssetUsdEtfCategory(),
      AssetCdbCategory(),
      AssetOtherCategory(),
    ];
  }
}
