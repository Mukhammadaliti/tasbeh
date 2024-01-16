import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Тасбех'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<int> _history = [];

   @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
      _history = prefs.getStringList('history')?.map(int.parse).toList() ?? [];
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', _counter);
    prefs.setStringList('history', _history.map((e) => e.toString()).toList());
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _saveData();
    });
  }

  void _resetCounter() {
    setState(() {
      _history.add(_counter);
      _counter = 0;
      _saveData();
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text(widget.title),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.grey,
              width: 200,
              height: 45,
              child: Text(
                '${_counter}',
                textAlign: TextAlign.end,
                style: TextStyle(fontFamily: "Digital", fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 180, top: 25),
              child: IconButton(
                  onPressed: () {
                    _resetCounter();
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: Colors.black,
                    size: 38,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: FittedBox(
                child: FloatingActionButton.small(
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Меню',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'История',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pop(context); // Закрываем боковое меню
                _showHistoryDialog(); // Отображаем историю в диалоговом окне
              },
            ),
            ListTile(
              title: Text('Очистика истории'),
              onTap: () {
                Navigator.pop(context); // Закрываем боковое меню
                _clearHistory(); // Очищаем историю
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('История'),
          content: Text(
            '$_history',
            style: TextStyle(
              fontFamily: 'Digital',
              fontSize: 22,
            ),
          ),
          actions: <Widget>[  
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}
