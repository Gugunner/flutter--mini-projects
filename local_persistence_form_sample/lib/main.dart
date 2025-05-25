import 'package:flutter/material.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack.dart';
import 'package:local_persistence_form_sample/Data/user_repository.dart';
import 'package:local_persistence_form_sample/Widgets/form_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqfliteStack.instance.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FormPage(repository: UserRepository()));
  }
}
