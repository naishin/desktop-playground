import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var encoded = [0, 0, 0, 0, 0, 0, 0, 0];
  var colors = List<Color>.filled(64, Colors.white);

  void toggleBit(int bit) {
    int line = bit ~/ 8;
    int row = bit % 8;
    int value = encoded[line];
    value = value ^ (1 << row);
    encoded[line] = value;

    if (colors[bit] == Colors.white) {
      colors[bit] = Colors.black;
    } else {
      colors[bit] = Colors.white;
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: LetterPage())
      );
  }
}

class LetterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: 
        GridView.builder(
          itemCount: 64,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                appState.toggleBit(index);
              },
              child: Container(
                decoration: BoxDecoration(color: appState.colors[index], border: Border.all(color: Colors.black)),
                child: Container()
              )
            );
          }
        ),
    );
   }
}
