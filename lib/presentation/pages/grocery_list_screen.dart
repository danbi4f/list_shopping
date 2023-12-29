import 'package:flutter/material.dart';
import 'package:list_shopping/data/datasources/categories.dart';
import 'package:list_shopping/data/models/grocery_item.dart';
import 'package:list_shopping/presentation/pages/new_item_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryItem> itemList = [];
  @override
  void initState() {
    super.initState();
  }

  void loadItems() async {
    final url = Uri.https(
        'shoppinglist-72dfe-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');
    final response = await http.get(url);

    final Map<String, dynamic> listData = json.decode(response.body);

    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;

      loadedItems.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category),
      );
    }
    setState(() {
      itemList = loadedItems;
    });
  }

  void showItemAddScreen() async {
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItemScreen(),
      ),
    );

    loadItems();
    // if (newItem == null) {
    //   return;
    // }
    // setState(() {
    //   itemList.add(newItem);
    // });
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
