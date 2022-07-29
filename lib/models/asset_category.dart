import 'package:flutter/material.dart';

abstract class AssetCategory {
  String id;

  String shortName;

  String name;

  Icon icon;

  AssetCategory(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.icon});
}
