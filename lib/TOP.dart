import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'memo.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Example',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DataRow> rows = [
    DataRow(cells: [
      DataCell(Text('John')),
      DataCell(Text('25')),
      DataCell(Text('エンジニア')),
    ]),
    DataRow(cells: [
      DataCell(Text('Alice')),
      DataCell(Text('30')),
      DataCell(Text('デザイナー')),
    ]),
    DataRow(cells: [
      DataCell(Text('Bob')),
      DataCell(Text('35')),
      DataCell(Text('マネージャー')),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Example'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text('名前')),
              DataColumn(label: Text('年齢')),
              DataColumn(label: Text('職業')),
              DataColumn(label: Text('削除')),
            ],
            rows: rows,
          ),
        ),
      ),
    );
  }
}
