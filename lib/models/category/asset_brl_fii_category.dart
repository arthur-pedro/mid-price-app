import 'package:flutter/material.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_category_id.dart';
import 'package:midprice/models/category/asset_category_name.dart';
import 'package:midprice/models/category/asset_category_short_name.dart';

class AssetBrlFiiCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetBrlFiiCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  AssetCategoryId id = AssetCategoryId.brlFii;

  @override
  AssetCategoryShortName shortName = AssetCategoryShortName.brlFiiShortName;

  @override
  AssetCategoryName name = AssetCategoryName.brlFiiName;

  @override
  Icon icon = const Icon(
    Icons.business,
    size: 16,
    color: Colors.deepOrange,
  );
}
