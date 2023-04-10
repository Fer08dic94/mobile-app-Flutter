import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/routes.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/theme.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> login(String correo, String pass) async {
  var url = Uri.https("grupojj.com.mx", 'WSLogin/Login.php');
  var map = <String, dynamic>{};
  map['apikey'] = 'UTEQ';
  map['usu'] = correo;
  map['pass'] = pass;

  http.Response response = await http.post(url, body: map);

  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    String Message = data["Message"];
    if (Message == "OK") {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final storage = const FlutterSecureStorage();

  //GUARDA EL ID DEL USUARIO
  Future<void> guardaid(String idUsu) async {
    await storage.write(key: 'idusuario', value: idUsu);
  }

//LEE EL ID DEL USUARIO
  @override
  Future<String> readIdcliente() async {
    return await storage.read(key: 'idusuario') ?? '';
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
