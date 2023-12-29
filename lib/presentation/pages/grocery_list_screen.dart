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
  var isLoading = true;
  String? _error = '';

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void loadItems() async {
    final url = Uri.https(
        'shoppinglist-72dfe-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');

try {
      final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Download failed. Please try again later.';
      });
    }

    if(response.body == 'null'){
      setState(() {
        isLoading = false;
      });
      return;
    }

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
      isLoading = false;
    });
} catch (error){
setState(() {
  _error = 'Something went wrong! Please try agin later';
});
}
  }

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

    //loadItems();
    // if (newItem == null) {
    //   return;
    // }
    // setState(() {
    //   itemList.add(newItem);
    // });
  }

  void removeItem(GroceryItem value) async {
    final index = itemList.indexOf(value);

    setState(() {
      itemList.remove(value);
    });

    final url = Uri.https(
        'shoppinglist-72dfe-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list/${value.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        itemList.insert(index, value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('List is empty'));

    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

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

    if (_error == null) {
      content = Center(
        child: Text(_error!),
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
