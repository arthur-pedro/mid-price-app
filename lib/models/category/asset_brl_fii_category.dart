import 'package:flutter/material.dart';
import 'package:midpriceapp/models/category/asset_category.dart';

class AssetBrlFiiCategory implements AssetCategory {
  @override
  bool operator ==(Object other) =>
      other is AssetBrlFiiCategory && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String id = 'FUNDO_INVESTIMENTO_IMOBILIARIO';

  @override
  String shortName = 'Fii';

  @override
  String name = 'Fundo de investimento imobiliário';

  @override
  Icon icon = const Icon(
    Icons.business,
    size: 16,
    color: Colors.deepOrange,
  );
}
