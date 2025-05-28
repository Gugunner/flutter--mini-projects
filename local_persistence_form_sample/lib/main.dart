import 'package:flutter/material.dart';
import 'package:local_persistence_form_sample/Core/background_tasks.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack.dart';
import 'package:local_persistence_form_sample/Data/user_repository.dart';
import 'package:local_persistence_form_sample/Widgets/form_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqfliteStack.instance.init();
  BackgroundTasks.instance.cleanDB(UserRepository());
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  initState() {
    _lifecycleListener = AppLifecycleListener(
      onShow: () => debugPrint("Showing onShow"),
      onResume: () => debugPrint("Resuming onResume"),
      onRestart: () => debugPrint("Restarting onRestart"),
      onPause: () => debugPrint("Pausing onPause"),
      onHide: () => debugPrint("Hiding onHide"),
      onInactive: () async {
        debugPrint("Deactivating onInactive");
        BackgroundTasks.instance.scheduleCleanTask();
      },
      onDetach: () => debugPrint("Detaching onDetach"),
      onStateChange: (state) => setState(() {}),
    );
    super.initState();
  }

  @override
  dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FormPage(repository: UserRepository()));
  }
}
