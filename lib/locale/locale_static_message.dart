import 'package:midprice/models/category/asset_category_name.dart';
import 'package:midprice/models/category/asset_category_short_name.dart';
import 'package:midprice/models/deposit/enum_operation.dart';

class LocaleStaticMessage {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      AssetCategoryName.brlStockName.name: 'BRL Stock',
      AssetCategoryShortName.brlStockShortName.name: 'BRL Stock',
      AssetCategoryName.usdStockName.name: 'USD Stock',
      AssetCategoryShortName.usdStockShortName.name: 'USD Stock',
      AssetCategoryName.brlEtfName.name: 'BRL ETF',
      AssetCategoryShortName.brlEtfShortName.name: 'BRL ETF',
      AssetCategoryName.usdEtfName.name: 'USD ETF',
      AssetCategoryShortName.usdEtfShortName.name: 'USD ETF',
      AssetCategoryName.treasureName.name: 'Treasures',
      AssetCategoryShortName.treasureShortName.name: 'Treasures',
      AssetCategoryName.brlFiiName.name: 'BRL Real Estate Investment Fund',
      AssetCategoryShortName.brlFiiShortName.name: 'BRL REITs',
      AssetCategoryName.usdFiiName.name: 'REITs - Real Estate Investment',
      AssetCategoryShortName.usdFiiShortName.name: 'REITs',
      AssetCategoryName.cdbName.name: 'BRL CDB',
      AssetCategoryShortName.cdbShortName.name: 'BRL CDB',
      AssetCategoryName.othersName.name: 'Others',
      AssetCategoryShortName.othersShortName.name: 'Others',
      Operation.buy.name: 'Buy',
      Operation.sell.name: 'Sell',
    },
    'es': {
      AssetCategoryName.brlStockName.name: 'BRL Stock',
      AssetCategoryShortName.brlStockShortName.name: 'BRL Stock',
      AssetCategoryName.usdStockName.name: 'USD Stock',
      AssetCategoryShortName.usdStockShortName.name: 'USD Stock',
      AssetCategoryName.brlEtfName.name: 'BRL ETF',
      AssetCategoryShortName.brlEtfShortName.name: 'BRL ETF',
      AssetCategoryName.usdEtfName.name: 'USD ETF',
      AssetCategoryShortName.usdEtfShortName.name: 'USD ETF',
      AssetCategoryName.treasureName.name: 'Treasures',
      AssetCategoryShortName.treasureShortName.name: 'Treasures',
      AssetCategoryName.brlFiiName.name: 'BRL Real Estate Investment Fund',
      AssetCategoryShortName.brlFiiShortName.name: 'BRL REITs',
      AssetCategoryName.usdFiiName.name: 'REITs - Real Estate Investment',
      AssetCategoryShortName.usdFiiShortName.name: 'REITs',
      AssetCategoryName.cdbName.name: 'BRL CDB',
      AssetCategoryShortName.cdbShortName.name: 'BRL CDB',
      AssetCategoryName.othersName.name: 'Others',
      AssetCategoryShortName.othersShortName.name: 'Others',
      Operation.buy.name: 'Buy',
      Operation.sell.name: 'Sell',
    },
    'pt': {
      AssetCategoryName.brlStockName.name: 'Ação',
      AssetCategoryShortName.brlStockShortName.name: 'Ação',
      AssetCategoryName.usdStockName.name: 'USD Stock',
      AssetCategoryShortName.usdStockShortName.name: 'USD Stock',
      AssetCategoryName.brlEtfName.name: 'ETF',
      AssetCategoryShortName.brlEtfShortName.name: 'ETF',
      AssetCategoryName.usdEtfName.name: 'USD ETF',
      AssetCategoryShortName.usdEtfShortName.name: 'USD ETF',
      AssetCategoryName.treasureName.name: 'Tesouro Direto',
      AssetCategoryShortName.treasureShortName.name: 'Tesouro',
      AssetCategoryName.brlFiiName.name: 'Fundo de Investimento Imobiliário',
      AssetCategoryShortName.brlFiiShortName.name: 'FII',
      AssetCategoryName.usdFiiName.name: 'REITs',
      AssetCategoryShortName.usdFiiShortName.name: 'REITs',
      AssetCategoryName.cdbName.name: 'CDB',
      AssetCategoryShortName.cdbShortName.name: 'CDB',
      AssetCategoryName.othersName.name: 'Outros',
      AssetCategoryShortName.othersShortName.name: 'Outros',
      Operation.buy.name: 'Compra',
      Operation.sell.name: 'Venda',
    },
  };

  static String translate(String localeName, String key) {
    return _localizedValues[localeName]![key]!;
  }
}
