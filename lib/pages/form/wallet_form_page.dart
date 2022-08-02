import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midprice/components/snackbar.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/category/asset_brl_etf_category.dart';
import 'package:midprice/models/category/asset_brl_fii_category.dart';
import 'package:midprice/models/category/asset_brl_stock_category.dart';
import 'package:midprice/models/category/asset_category.dart';
import 'package:midprice/models/category/asset_cdb_category.dart';
import 'package:midprice/models/category/asset_others_category.dart';
import 'package:midprice/models/category/asset_treasure_category%20copy.dart';

class WalletForm extends StatefulWidget {
  Asset asset = Asset(name: '', price: 0, category: AssetBrlStockCategory());
  WalletForm({Key? key, required this.asset}) : super(key: key);

  static const routeName = '/wallet/form';

  @override
  State<WalletForm> createState() => _WalletForm();
}

class _WalletForm extends State<WalletForm> {
  String title = 'Novo Ativo';

  final _formKey = GlobalKey<FormState>();

  final List<AssetCategory> _categories = [
    AssetBrlStockCategory(),
    AssetBrlFiiCategory(),
    AssetTreasureCategory(),
    AssetCdbCategory(),
    AssetBrlEtfCategory(),
    AssetOtherCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isUpdate = false;
    if (widget.asset.id != null) {
      isUpdate = true;
      title = 'Atualização de ativo';
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: widget.asset.name,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      decoration: const InputDecoration(
                          labelText: 'Ticker', hintText: 'Ex: ITSA4'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      onSaved: (newValue) => setState(() {
                        widget.asset.name = newValue?.toUpperCase() ?? '';
                      }),
                    ),
                    DropdownButton<AssetCategory>(
                      value: widget.asset.category,
                      selectedItemBuilder: (BuildContext context) {
                        return _categories.map<Widget>((AssetCategory item) {
                          return Text(item.name);
                        }).toList();
                      },
                      isExpanded: true,
                      underline: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        height: 1,
                        color: Colors.blueGrey,
                      ),
                      onChanged: (AssetCategory? newValue) {
                        setState(() {
                          widget.asset.category = newValue!;
                        });
                      },
                      items: _categories.map<DropdownMenuItem<AssetCategory>>(
                          (AssetCategory value) {
                        return DropdownMenuItem<AssetCategory>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      initialValue: widget.asset.price.toString(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                        TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll(',', '.'),
                          ),
                        ),
                      ],
                      decoration: const InputDecoration(
                          labelText: 'Preço',
                          hintText: 'Ex: R\$ 10',
                          prefixText: 'R\$ '),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.parse(value) < 0) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      onSaved: (newValue) => setState(() {
                        widget.asset.price = double.parse(newValue ?? '0.0');
                      }),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            final form = _formKey.currentState;
                            if (form!.validate()) {
                              form.save();
                              String msg = '';
                              if (isUpdate) {
                                msg = 'Ativo atualizado.';
                              } else {
                                msg = 'Ativo adicionado à carteira.';
                              }
                              Navigator.pop(context, widget.asset);
                              ViewSnackbar.show(
                                  context, msg, ViewSnackbarStatus.success);
                            }
                          },
                          child: Text(isUpdate ? 'Salvar' : 'Adicionar'),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
