import 'package:flutter/material.dart';
import 'package:pokedex/pokecard.dart';
import 'package:pokedex/pokemon.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "P@kedex",
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const String url =
      'https://pokeapi.co/api/v2/pokemon?limit=151&offset=0';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Pokemons pokemons;

  Color bgColor = Color(0xFF393636);
  // ignore: missing_return
  Future<List<Pokemons>> _fetchData() async {
    final response = await http.get(MyHomePage.url);
    final decode = json.decode(response.body);
    final data = Pokemons.fromJson(decode['results']);
    print(data.pokemons);

    setState(() {
      pokemons = data;
    });
  }

  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("P@kedex"),
        centerTitle: true,
      ),
      body: Container(
        child: pokemons == null
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            : GridView.count(
                crossAxisCount: 3,
                children: List.generate(
                    pokemons.pokemons.length,
                    (index) => PokeCard(
                          pokeURL: pokemons.pokemons[index].url,
                        )),
              ),
      ),
    );
  }
}
