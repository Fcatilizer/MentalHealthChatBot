import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:healthbot/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _lightscheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  static final _darkscheme =
  ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
          return MaterialApp(
            title: 'Mental Health ChatBot',
            theme: ThemeData(
              colorScheme: lightColorScheme ?? _lightscheme,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme ?? _darkscheme,
              useMaterial3: true,
            ),
            initialRoute: "/",
            routes: {
              '/': (context) => const HomePage(),
            },
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}