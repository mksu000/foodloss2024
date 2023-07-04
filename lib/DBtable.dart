import 'package:flutter/material.dart';
import 'package:foodloss2024/main.dart';
import 'package:foodloss2024/memo.dart';

class FoodListScreen2 extends StatefulWidget {

  final FoodModel foodModel;

  FoodListScreen2({required this.foodModel});

  @override
  _FoodListScreen2State createState() => _FoodListScreen2State();
}

class _FoodListScreen2State extends State<FoodListScreen2> {

  @override
  void initState() {
    super.initState();
    widget.foodModel.init().then((_) {
      // Force a rebuild after initialization
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foods'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.foodModel.getFoods(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // The future is still running
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Something went wrong
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Success case
          final memos = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('カテゴリ')),
                DataColumn(label: Text('Content')),
                
              ],
              rows: memos.map((food) {
                return DataRow(cells: [
                  DataCell(Text(food[FoodModel.columnId])),
                  DataCell(Text("aaaa")),
                  DataCell(Text(food[FoodModel.columnContent])),
                ]);
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final content = await _showAddFoodDialog();
          if (content != null) {
            // Use the current time as a unique ID
            final id = DateTime.now().millisecondsSinceEpoch.toString();
            await widget.foodModel.addFood(id, content);
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<String?> _showAddFoodDialog() async {
    String? newContent;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new food'),
          content: TextField(
            onChanged: (value) {
              newContent = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(newContent),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}