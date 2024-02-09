import 'package:flutter/material.dart';
import 'package:task_manager_flutter/sccreen/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'service/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const taskmanager());
}

class taskmanager extends StatelessWidget {
  const taskmanager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
