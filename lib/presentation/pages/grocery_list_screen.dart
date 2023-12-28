import 'package:flutter/material.dart';
import 'package:list_shopping/data/datasources/dummy_list.dart';
import 'package:list_shopping/data/models/grocery_item.dart';
import 'package:list_shopping/presentation/pages/new_item_screen.dart';


class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  void showItemAddScreen() {
     Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItemScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) => ListTile(
          leading: Container(
            height: 16,
            width: 16,
            color: groceryItems[index].category.color,
          ),
          title: Text(groceryItems[index].name),
          trailing: Text(groceryItems[index].quantity.toString()),
        ),
      ),
    );
  }
}
