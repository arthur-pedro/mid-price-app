import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rebalance',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const TabPage(title: 'Minha Carteira - Rebalance'),
    );
  }
}

class TabPage extends StatefulWidget {
  const TabPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TabPage> createState() => _TabPagePageState();
}

class _TabPagePageState extends State<TabPage> {
  double _portfolioValue = 0.0;

  void _incrementCounter() {
    setState(() {
      _portfolioValue++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var listItem = ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Card(
            elevation: 5.0,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text("ListItem $index"),
            ),
          ),
          onTap: () {
            // showDialog(
            //     barrierDismissible: false,
            //     context: context,
            //     child: new CupertinoAlertDialog(
            //       title: Column(
            //         children: <Widget>[
            //           Text("ListView"),
            //           Icon(
            //             Icons.favorite,
            //             color: Colors.red,
            //           ),
            //         ],
            //       ),
            //       content: Text("Selected Item $index"),
            //       actions: <Widget>[
            //         FlatButton(
            //             onPressed: () {
            //               Navigator.of(context).pop();
            //             },
            //             child: new Text("OK"))
            //       ],
            //     ));
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.view_list_rounded)),
                Tab(icon: Icon(Icons.account_balance_wallet_outlined)),
                Tab(icon: Icon(Icons.monetization_on_outlined)),
              ],
            ),
            title: Text('R\$ $_portfolioValue'),
          ),
          body: TabBarView(
            children: [
              listItem,
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing
        ),
      ),
    );
  }
}
