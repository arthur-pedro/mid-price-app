import 'package:flutter/material.dart';
import 'package:midpriceapp/models/asset_category.dart';

class AssetBrlStockCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetBrlStockCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String id = 'ACAO';

  @override
  String name = 'Ação';

  @override
  String shortName = 'Ação';

  @override
  Icon icon = const Icon(
    Icons.monetization_on,
    size: 16,
    color: Colors.teal,
  );
}
