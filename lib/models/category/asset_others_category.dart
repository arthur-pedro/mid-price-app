import 'package:flutter/material.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_category_id.dart';
import 'package:midprice/models/category/asset_category_name.dart';
import 'package:midprice/models/category/asset_category_short_name.dart';

class AssetOtherCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetOtherCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  AssetCategoryId id = AssetCategoryId.others;

  @override
  AssetCategoryShortName shortName = AssetCategoryShortName.cdbShortName;

  @override
  AssetCategoryName name = AssetCategoryName.othersName;

  @override
  Icon icon = const Icon(
    Icons.home_outlined,
    size: 16,
    color: Color.fromARGB(255, 207, 215, 132),
  );
}
