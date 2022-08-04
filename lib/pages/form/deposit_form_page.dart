import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midprice/components/snackbar.dart';
import 'package:midprice/database/asset/asset_repository.dart';
import 'package:midprice/locale/locale_static_message.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/deposit/deposit.dart';
import 'package:midprice/locale/app_localizations_context.dart';
import 'package:midprice/models/deposit/enum_operation.dart';

// ignore: must_be_immutable
class DepositForm extends StatefulWidget {
  Deposit deposit = Deposit(
      date: DateTime.now(),
      payedValue: 0,
      quantity: 0,
      fee: 0.0,
      operation: Operation.buy);
  DepositForm({Key? key, required this.deposit}) : super(key: key);

  static const routeName = '/deposit/form';

  @override
  State<DepositForm> createState() => _DepositForm();
}

class _DepositForm extends State<DepositForm> {
  String title = '';
  bool isLoading = false;

  List<Operation> operations = [Operation.buy, Operation.sell];

  final _formKey = GlobalKey<FormState>();

  List<Asset> wallet = [];

  bool hasDropdownAssetError = false;

  @override
  void initState() {
    super.initState();
    getWallet();
  }

  Future getWallet() async {
    setState(() {
      isLoading = true;
    });
    wallet = await AssetRepository.instance.list();
    setState(() {
      isLoading = false;
    });
  }

  bool validateDropboxAsset() {
    if (widget.deposit.asset == null) {
      setState(() {
        hasDropdownAssetError = true;
      });
    } else {
      setState(() {
        hasDropdownAssetError = false;
      });
    }
    return !hasDropdownAssetError;
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdate = false;
    if (widget.deposit.id != null) {
      isUpdate = true;
      title = context.loc.attContribution;
    } else {
      title = context.loc.addContribution;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: DropdownButtonFormField<Operation>(
                      value: widget.deposit.operation,
                      selectedItemBuilder: (BuildContext context) {
                        return operations.map<Widget>((Operation item) {
                          return Text(LocaleStaticMessage.translate(
                              context.loc.localeName, item.name));
                        }).toList();
                      },
                      isExpanded: true,
                      hint: Text(context.loc.selectOneOperation),
                      onChanged: (Operation? newValue) {
                        setState(() {
                          widget.deposit.operation = newValue!;
                        });
                      },
                      items: operations
                          .map<DropdownMenuItem<Operation>>((Operation value) {
                        return DropdownMenuItem<Operation>(
                          value: value,
                          child: Text(LocaleStaticMessage.translate(
                              context.loc.localeName, value.name)),
                        );
                      }).toList(),
                    ),
                  ),
                  DropdownButtonFormField<Asset>(
                    value: widget.deposit.asset,
                    selectedItemBuilder: (BuildContext context) {
                      return wallet.map<Widget>((Asset item) {
                        return Text(item.name);
                      }).toList();
                    },
                    isExpanded: true,
                    hint: Text(context.loc.selectOneTicker),
                    onChanged: (Asset? newValue) {
                      setState(() {
                        widget.deposit.payedValue = newValue!.price;
                        widget.deposit.asset = newValue;
                        validateDropboxAsset();
                      });
                    },
                    items: wallet.map<DropdownMenuItem<Asset>>((Asset value) {
                      return DropdownMenuItem<Asset>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    initialValue: widget.deposit.quantity.toString(),
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
                    decoration: InputDecoration(
                      labelText: context.loc.quantity,
                      hintText: context.loc.contributionQuantity,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.parse(value) < 0) {
                        return context.loc.requiredField;
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      if (value.isNotEmpty) {
                        widget.deposit.quantity = double.parse(value);
                      } else {
                        widget.deposit.quantity = 0;
                      }
                    }),
                    onSaved: (newValue) => setState(() {
                      widget.deposit.quantity = double.parse(newValue ?? '0.0');
                    }),
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
                  TextFormField(
                    initialValue: widget.deposit.fee.toString(),
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
                    decoration: InputDecoration(
                        labelText: context.loc.fees,
                        hintText: context.loc.feeDescription,
                        prefix: Text('${context.loc.currency} ')),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.parse(value) < 0) {
                        return context.loc.requiredField;
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() {
                      if (value.isNotEmpty) {
                        widget.deposit.fee = double.parse(value);
                      } else {
                        widget.deposit.fee = 0.0;
                      }
                    }),
                    onSaved: (newValue) => setState(() {
                      widget.deposit.fee = double.parse(newValue ?? '0.0');
                    }),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text(context.loc.tickerValue(
                          (widget.deposit.asset?.price.toString() ?? '0.00')))),
                  SizedBox(
                      child: Text(
                          '${context.loc.fees} ${context.loc.currency} ${(widget.deposit.fee)}')),
                  SizedBox(
                      child: Text(
                          '${context.loc.totalCostToContribution} ${context.loc.currency} ${(widget.deposit.fee + (widget.deposit.payedValue * widget.deposit.quantity)).toStringAsFixed(2)}')),
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (form!.validate() && validateDropboxAsset()) {
                            form.save();
                            String msg = '';
                            if (isUpdate) {
                              msg = context.loc.updatedContribution;
                            } else {
                              msg = context.loc.addedContributionToWallet;
                            }
                            Navigator.pop(context, widget.deposit);
                            ViewSnackbar.show(
                                context, msg, ViewSnackbarStatus.success);
                          }
                        },
                        child:
                            Text(isUpdate ? context.loc.save : context.loc.add),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
