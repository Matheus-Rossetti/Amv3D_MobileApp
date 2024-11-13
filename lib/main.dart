import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'notes_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotesScreen(token: '06f7b155ccd185afb0fa568197dfc591e45e559d0e'),
      // home: LoginRegister(),
      debugShowCheckedModeBanner: false,
      title: 'Amvali 3D Viewer',
    );
  }
}
