import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(
    // nhà phân phối
    ChangeNotifierProvider(
      create: (_) => CounterHome(),
      child: MyApp(),
    ),
  );
}

// nhà cung cấp
class CounterHome extends ChangeNotifier {
  int counter = 100;
  int get _counter => counter;
  void add() {
    counter++;
    notifyListeners();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(), // home là màn hình đầu tiên
    );
  }
}


//screen 1
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.watch<CounterHome>()._counter.toString()),
            SizedBox(width: 20),
            FloatingActionButton(
              backgroundColor: Colors.amber,
              child: Icon(Icons.add, size: 20),
              onPressed: () {
                context.read<CounterHome>().add();
              },
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SecondScreen()),
                );
              },
              child: Text("Chuyển"),
            ),
          ],
        ),
      ),
    );
  }
}
//screen 2
class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Màn hình 2")),
      body: Center(
        child: Text("Counter: ${context.watch<CounterHome>()._counter}"),
      ),
    );
  }
}
