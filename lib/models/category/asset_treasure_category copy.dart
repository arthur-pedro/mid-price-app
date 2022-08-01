import 'package:flutter/material.dart';
import 'package:midpriceapp/models/category/asset_category.dart';

class AssetTreasureCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetTreasureCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String id = 'TESOURO_DIRETO';

  @override
  String shortName = 'Tesouro Direto';

  @override
  String name = 'Tesouro Direto';

  @override
  Icon icon = const Icon(
    Icons.balance_outlined,
    size: 16,
    color: Colors.deepPurple,
  );
}
