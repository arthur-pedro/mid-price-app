import 'package:midpriceapp/models/asset_category.dart';

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
}
