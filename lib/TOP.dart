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
      DataCell(Text('トマト')),
      DataCell(Text('25')),
      DataCell(Text('2023/06/25')),
    ]),
    DataRow(cells: [
      DataCell(Text('豚肉')),
      DataCell(Text('3')),
      DataCell(Text('2023/08/22')),
    ]),
    DataRow(cells: [
      DataCell(Text('ヨーグルト')),
      DataCell(Text('2')),
      DataCell(Text('2024/05/31')),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TOP page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text('名前')),
              DataColumn(label: Text('個数')),
              DataColumn(label: Text('消費期限')),
              DataColumn(label: Text('削除')),
            ],
            rows: rows,
          ),
        ),
      ),
    );
  }
}
