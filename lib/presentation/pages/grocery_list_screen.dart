import 'package:flutter/material.dart';
import 'package:list_shopping/data/models/grocery_item.dart';
import 'package:list_shopping/presentation/pages/new_item_screen.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<GroceryItem> itemList = [];

  void showItemAddScreen() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItemScreen(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      itemList.add(newItem);
    });
  }

  void removeItem(value) {
    itemList.remove(value);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('List is empty'),
    );
    if (itemList.isNotEmpty) {
      content = ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(itemList[index].id),
          onDismissed: (direction) {
            removeItem(itemList[index]);
          },
          child: ListTile(
            leading: Container(
              height: 16,
              width: 16,
              color: itemList[index].category.color,
            ),
            title: Text(itemList[index].name),
            trailing: Text(itemList[index].quantity.toString()),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('You Groceries'),
        actions: [
          IconButton(
            onPressed: showItemAddScreen,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
