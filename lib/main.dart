import 'package:flutter/material.dart';
import 'package:list_shopping/presentation/pages/grocery_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(const MainApp());

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GroceryListScreen(),
    );
  }
}
