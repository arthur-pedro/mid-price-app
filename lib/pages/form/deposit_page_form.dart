import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midpriceapp/models/asset/asset.dart';
import 'package:midpriceapp/models/deposit/deposit.dart';

// ignore: must_be_immutable
class DepositForm extends StatefulWidget {
  Deposit deposit = Deposit(
    date: DateTime.now(),
    payedValue: 0,
    quantity: 0,
  );
  DepositForm({Key? key, required this.deposit}) : super(key: key);

  static const routeName = '/deposit/form';

  @override
  State<DepositForm> createState() => _DepositForm();
}

class _DepositForm extends State<DepositForm> {
  String title = 'Novo Aporte';

  final _formKey = GlobalKey<FormState>();

  List<Asset> wallet = [];

  @override
  Widget build(BuildContext context) {
    bool isUpdate = false;
    if (widget.deposit.id != null) {
      isUpdate = true;
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                      color: Colors.blueGrey,
                    ),
                    onChanged: (Asset? newValue) {
                      setState(() {
                        widget.deposit.payedValue = newValue!.price;
                        widget.deposit.asset = newValue;
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
                    decoration: const InputDecoration(
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
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                          'Valor do ativo  R\$ ${(widget.deposit.asset?.price ?? '0.00')}')),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                          'Custo total to aporte  R\$ ${(widget.deposit.payedValue * widget.deposit.quantity).toStringAsFixed(2)}')),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          form.save();
                          String msg = '';
                          if (isUpdate) {
                            msg = 'Aporte atualizado.';
                            Navigator.pop(context);
                          } else {
                            msg = 'Aporte adicionado à carteira.';
                            Navigator.pop(context, widget.deposit);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(msg)),
                          );
                        }
                      },
                      child: Text(isUpdate ? 'Salvar' : 'Adicionar'),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
