import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wm = WindowManager.instance;
    wm.setSize(Size(720, 450));

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

  String encodedString() {
    var sb = StringBuffer('');
    for (int i = 0; i < 8; i++) {
      int line = encoded[i];
      sb.write('0x');
      sb.write(line.toRadixString(16));
      if (i < 7) {
        sb.write(', ');
      }
    }

    return sb.toString();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(child: Container()),
        Center(child: LetterPage()),
      ],
    );
  }
}

class LetterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Material(
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Column(children: [
          Row(children: [
            SizedBox(
              width: 400,
              height: 400,
              child: GridView.builder(
                  itemCount: 64,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          appState.toggleBit(index);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: appState.colors[index],
                                border: Border.all(color: Colors.black)),
                            child: Container()));
                  }),
            ),
            SizedBox(
              height: 10,
              width: 20,
            ),
            SizedBox(
                width: 20,
                height: 20,
                child: GridView.builder(
                    itemCount: 64,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: appState.colors[index],
                        ),
                      );
                    }))
          ]),
          SelectableText(
            appState.encodedString(),
            style: TextStyle(fontSize: 32),
          )
        ]),
      ]),
    );
  }
}
