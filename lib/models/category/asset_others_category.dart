import 'package:flutter/material.dart';
import 'package:midprice/models/category/asset_category.dart';

class AssetOtherCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetOtherCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String id = 'OTHER';

  @override
  String shortName = 'Outros';

  @override
  String name = 'Outros';

  @override
  Icon icon = const Icon(
    Icons.home_outlined,
    size: 16,
    color: Color.fromARGB(255, 207, 215, 132),
  );
}
