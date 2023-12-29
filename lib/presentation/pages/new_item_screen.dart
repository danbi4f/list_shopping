import 'package:flutter/material.dart';
import 'package:list_shopping/data/datasources/categories.dart';
import 'package:list_shopping/data/models/category.dart';
import 'package:list_shopping/data/models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final formKey = GlobalKey<FormState>();
  var enteredName = '';
  var enteredQuantity = 1;
  var selectedCategory = categories[Categories.vegetables]!;
  var isSending = false;

  void saveItem() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isSending = true;
      });

      final url = Uri.https(
          'shoppinglist-72dfe-default-rtdb.europe-west1.firebasedatabase.app',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/jason',
        },
        body: json.encode(
          {
            'name': enteredName,
            'quantity': enteredQuantity,
            'category': selectedCategory.title,
          },
        ),
      );

      final Map<String, dynamic> localData = json.decode(response.body);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop(
        GroceryItem(
          id: localData['name'],
          name: enteredName,
          quantity: enteredQuantity,
          category: selectedCategory,
        ),
        // GroceryItem(
        //   id: DateTime.now().toString(),
        //   name: enteredName,
        //   quantity: enteredQuantity,
        //   category: selectedCategory,
        // ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  enteredName = newValue!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('quantity'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                initialValue: enteredQuantity.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.tryParse(value)! <= 0) {
                    return 'Must be a valid, positive number';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  enteredQuantity = int.parse(newValue!);
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: selectedCategory,
                items: [
                  for (final category in categories.entries)
                    DropdownMenuItem(
                      value: category.value,
                      child: Row(
                        children: [
                          Container(
                            height: 16,
                            width: 16,
                            color: category.value.color,
                          ),
                          const SizedBox(width: 10),
                          Text(category.value.title),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () {
                            formKey.currentState!.reset();
                          },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: isSending ? null : saveItem,
                    child: isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('add item'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
