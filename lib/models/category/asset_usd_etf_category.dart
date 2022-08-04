import 'package:flutter/material.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_category_id.dart';
import 'package:midprice/models/category/asset_category_name.dart';
import 'package:midprice/models/category/asset_category_short_name.dart';

class AssetUsdEtfCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetUsdEtfCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  AssetCategoryId id = AssetCategoryId.usdEtf;

  @override
  AssetCategoryShortName shortName = AssetCategoryShortName.usdEtfShortName;

  @override
  AssetCategoryName name = AssetCategoryName.usdEtfName;

  @override
  Icon icon = const Icon(
    Icons.bubble_chart_outlined,
    size: 16,
    color: Colors.grey,
  );
}
