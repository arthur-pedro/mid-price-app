import 'package:midprice/database/config/config_bo.dart';
import 'package:midprice/util/parser.dart';

class Config {
  @override
  bool operator ==(Object other) => other is Config && other.id == id;

  @override
  int get hashCode => id.hashCode;

  int id;

  int assetQuantityLimit;

  int depositQuantityLimit;

  int lvl;

  int depositLimitStep;

  int assetLimitStep;

  String theme;

  bool noAds;

  Config(
      {required this.id,
      required this.depositQuantityLimit,
      required this.assetQuantityLimit,
      required this.noAds,
      required this.lvl,
      required this.assetLimitStep,
      required this.depositLimitStep,
      required this.theme});

  static Config fromJson(Map<String, Object?> json) => Config(
      id: json[ConfigBO.id] as int,
      assetQuantityLimit: json[ConfigBO.assetQuantityLimit] as int,
      theme: json[ConfigBO.theme] as String,
      noAds: Parser.intToBool(json[ConfigBO.noAds] as int),
      assetLimitStep: json[ConfigBO.assetLimitStep] as int,
      depositQuantityLimit: json[ConfigBO.depositQuantityLimit] as int,
      depositLimitStep: json[ConfigBO.depositLimitStep] as int,
      lvl: json[ConfigBO.lvl] as int);

  static Map<String, Object?> toJson(Config config) => {
        ConfigBO.id: config.id,
        ConfigBO.depositQuantityLimit: config.depositQuantityLimit,
        ConfigBO.assetQuantityLimit: config.assetQuantityLimit,
        ConfigBO.noAds: Parser.boolToInt(config.noAds),
        ConfigBO.lvl: config.lvl,
        ConfigBO.assetLimitStep: config.assetLimitStep,
        ConfigBO.depositLimitStep: config.depositLimitStep,
        ConfigBO.theme: config.theme,
      };
}
