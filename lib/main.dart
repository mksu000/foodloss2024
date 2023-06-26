import 'package:flutter/material.dart';
import 'package:foodloss2024/memo.dart';
import 'package:foodloss2024/memo.dart';

import 'DBtable.dart';
//miki
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final foodModel = FoodModel();
  await foodModel.init();

  runApp(FoodApp(foodModel: foodModel));
}

class Food {
  final String id;
  final String content;
  final String cat;
  Food(this.id, this.cat ,this.content);
}

class FoodApp extends StatelessWidget {
  final FoodModel foodModel;

  const FoodApp({required this.foodModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '食品ロス',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: FoodListScreen(foodModel: foodModel),
    );
  }
}

class FoodListScreen extends StatefulWidget {
  final FoodModel foodModel;

  const FoodListScreen({required this.foodModel});

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen>
    with SingleTickerProviderStateMixin {
  List<Food> foods = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    final foods = await widget.foodModel.getFoods();
    setState(() {
      this.foods = foods
          .map((food) => Food(food[FoodModel.columnId], "kkkkk",food[FoodModel.columnContent]))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('foodloss App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(foods[index].id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  _deleteFood(index);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        foods[index].content,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'Created: ${DateTime.now().toString()}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.deepPurple,
                      ),
                      onTap: () {
                        _navigateToFoodDetail(context, index);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const Center(child: Text('ロスの内容')),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFoodDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          color: const Color.fromARGB(255, 136, 106, 188),
          child: TabBar(
            controller: _tabController,
            tabs: [
              const Tab(icon: Icon(Icons.home), text: 'ホーム'),
              const Tab(icon: Icon(Icons.delete), text: 'ロス'),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Settings"),
          actions: [
            TextButton(
              onPressed: () {
                _showAddCategoryDialog(dialogContext);
              },
              child: Text('カテゴリ追加'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodListScreen2(foodModel: widget.foodModel),
                  ),
                );
              },
              child: Text('DB閲覧'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String categoryName = '';
        return AlertDialog(
          title: const Text('追加'),
          content: TextField(
            onChanged: (value) {
              categoryName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform the necessary operations with the category name
                // For example, save it to the database or perform any other logic
                print('Category Name: $categoryName');
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToFoodDetail(BuildContext context, int index) async {
    final editedFood = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailScreen(food: foods[index].content),
      ),
    ) as String?;

    if (editedFood != null) {
      await widget.foodModel.updateFood(foods[index].id, editedFood);
      _loadFoods();
    }
  }

  void _showAddFoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String newFood = '';
        return AlertDialog(
          title: const Text('追加'),
          content: TextField(
            onChanged: (value) {
              newFood = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                await widget.foodModel.addFood(id, newFood);
                _loadFoods();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFood(int index) async {
    await widget.foodModel.deleteFood(foods[index].id);
    _loadFoods();
  }
}

class FoodDetailScreen extends StatefulWidget {
  final String food;

  const FoodDetailScreen({required this.food});

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.food);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _textEditingController,
          onChanged: (value) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveMemo(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void _saveMemo(BuildContext context) {
    final editedFood = _textEditingController.text;
    Navigator.pop(context, editedFood);
  }
}
