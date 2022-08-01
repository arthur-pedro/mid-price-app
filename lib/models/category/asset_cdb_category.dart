import 'package:flutter/material.dart';
import 'package:midpriceapp/models/category/asset_category.dart';

class AssetCdbCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetCdbCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String id = 'CDB';

  @override
  String shortName = 'CDB';

  @override
  String name = 'CDB';

  @override
  Icon icon = const Icon(
    Icons.account_balance_outlined,
    size: 16,
    color: Colors.amber,
  );
}
