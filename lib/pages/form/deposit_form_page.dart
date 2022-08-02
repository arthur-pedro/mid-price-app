import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midprice/components/snackbar.dart';
import 'package:midprice/database/asset/asset_repository.dart';
import 'package:midprice/models/asset/asset.dart';
import 'package:midprice/models/deposit/deposit.dart';

// ignore: must_be_immutable
class DepositForm extends StatefulWidget {
  Deposit deposit = Deposit(
      date: DateTime.now(),
      payedValue: 0,
      quantity: 0,
      fee: 0.0,
      operation: 'Compra');
  DepositForm({Key? key, required this.deposit}) : super(key: key);

  static const routeName = '/deposit/form';

  @override
  State<DepositForm> createState() => _DepositForm();
}

class _DepositForm extends State<DepositForm> {
  String title = 'Novo Aporte';
  bool isLoading = false;

  List<String> operations = ['Compra', 'Venda'];

  final _formKey = GlobalKey<FormState>();

  List<Asset> wallet = [];

  bool hasDropdownAssetError = false;
  bool hasDropdownOperationError = false;

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

  bool validateDropboxOperation() {
    if (widget.deposit.operation.isNotEmpty) {
      setState(() {
        hasDropdownOperationError = false;
      });
    } else {
      setState(() {
        hasDropdownOperationError = true;
      });
    }
    return !hasDropdownOperationError;
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdate = false;
    if (widget.deposit.id != null) {
      isUpdate = true;
      title = 'Atualização de aporte';
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: DropdownButton<String>(
                      value: widget.deposit.operation,
                      selectedItemBuilder: (BuildContext context) {
                        return operations.map<Widget>((String item) {
                          return Text(item);
                        }).toList();
                      },
                      isExpanded: true,
                      underline: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                        height: 1,
                        color: hasDropdownOperationError
                            ? const Color.fromARGB(255, 217, 49, 37)
                            : Colors.blueGrey,
                      ),
                      hint: const Text('Selecione uma operação'),
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.deposit.operation = newValue!;
                          validateDropboxOperation();
                        });
                      },
                      items: operations
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  DropdownButton<Asset>(
                    value: widget.deposit.asset,
                    selectedItemBuilder: (BuildContext context) {
                      return wallet.map<Widget>((Asset item) {
                        return Text(item.name);
                      }).toList();
                    },
                    isExpanded: true,
                    underline: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                      height: 1,
                      color: hasDropdownAssetError
                          ? const Color.fromARGB(255, 217, 49, 37)
                          : Colors.blueGrey,
                    ),
                    hint: const Text('Selecione um ativo'),
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
                  hasDropdownAssetError
                      ? const Text('Campo obrigatório',
                          style: TextStyle(
                              color: Color.fromARGB(255, 217, 49, 37),
                              fontSize: 12))
                      : const SizedBox.shrink(),
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
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      hintText: 'Quantidade do aporte',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.parse(value) < 0) {
                        return 'Campo obrigatório';
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
                    decoration: const InputDecoration(
                        labelText: 'Taxas',
                        hintText: 'Emolumentos, Corretagem, etc...',
                        prefix: Text('R\$ ')),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.parse(value) < 0) {
                        return 'Campo obrigatório';
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
                      child: Text(
                          'Valor do ativo  R\$ ${(widget.deposit.asset?.price ?? '0.00')}')),
                  SizedBox(child: Text('Taxas  R\$ ${(widget.deposit.fee)}')),
                  SizedBox(
                      child: Text(
                          'Custo total to aporte  R\$ ${(widget.deposit.fee + (widget.deposit.payedValue * widget.deposit.quantity)).toStringAsFixed(2)}')),
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (form!.validate() &&
                              validateDropboxAsset() &&
                              validateDropboxOperation()) {
                            form.save();
                            String msg = '';
                            if (isUpdate) {
                              msg = 'Aporte atualizado.';
                            } else {
                              msg = 'Aporte adicionado à carteira.';
                            }
                            Navigator.pop(context, widget.deposit);
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
      ),
    );
  }
}
