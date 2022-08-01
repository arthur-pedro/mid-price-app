import 'package:flutter/material.dart';
import 'package:midpriceapp/models/category/asset_category.dart';

class AssetBrlEtfCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetBrlEtfCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String id = 'BRL_ETF';

  @override
  String shortName = 'ETF Brasileiro';

  @override
  String name = 'ETF Brasileiro';

  @override
  Icon icon = const Icon(
    Icons.bubble_chart_outlined,
    size: 16,
    color: Colors.grey,
  );
}
