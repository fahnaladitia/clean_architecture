import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Number Trivia",
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.green.shade800,
        secondary: Colors.green.shade600,
        background: Colors.white,
      )),
      home: const NumberTriviaPage(),
    );
  }
}
