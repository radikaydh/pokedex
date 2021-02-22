import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pokedex/pokemon.dart';

class PokeCard extends StatefulWidget {
  const PokeCard({Key key, this.pokeURL}) : super(key: key);
  final String pokeURL;

  @override
  _PokeCardState createState() => _PokeCardState();
}

class _PokeCardState extends State<PokeCard> {
  Pokemon pokemon;

  _fetchData() async {
    final response = await http.get(widget.pokeURL);
    final decode = json.decode(response.body);
    final data = Pokemon.fromJson(decode);

    setState(() {
      pokemon = data;
    });
  }

  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          color: Colors.yellow,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => DetailPage(pokemon)));
            },
            child: pokemon == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        pokemon.sprites.frontDefault,
                        width: 130,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        pokemon.name,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )
                    ],
                  ),
          )),
    );
  }
}

///THIS CONTAIN DETAIL OF EVERY POKEMON
// ignore: must_be_immutable
class DetailPage extends StatelessWidget {
  Pokemon pokemon;

  Color bgColor = Color(0xFF393636);
  DetailPage(this.pokemon);

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 30,
        color: Colors.yellow,
        letterSpacing: 2);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Pokedex"),
        backgroundColor: Colors.yellow,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: "Return to list",
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: pokemon == null
                ? Center(
                    child: Text('NaN'),
                  )
                : Center(
                    child: Text(
                    '#0${pokemon.id.toString()}',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.black),
                  )),
          )
        ],
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.zero, bottom: Radius.circular(50))),
                // child:   Image.asset('assets/tes4.png',
                //   height:250//MediaQuery.of(context).size.height/3,
                //   ,fit:BoxFit.cover,
                //
                // ),
              ),
              Positioned(
                child: CircleAvatar(
                  radius: 125,
                  backgroundColor: Colors.yellow,
                  backgroundImage: NetworkImage(pokemon.sprites.frontDefault),
                ),
              )
            ],
          ),
          SizedBox(height: 12),
          Text(
            pokemon.name,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 40,
                color: Colors.yellow,
                letterSpacing: 3),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: -1,
            child: Container(
              height: 120,
              child: ListView.builder(
                  itemCount: pokemon.types.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      margin:
                          EdgeInsets.symmetric(horizontal: 120, vertical: 8),
                      child: Text(
                        pokemon.types[index].type.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            letterSpacing: 2),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(30)),
                    );
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('${pokemon.weight / 10} KG',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                        color: Colors.yellow,
                      )),
                  Text('Weight',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: Colors.white70)),
                ],
              ),
              Column(
                children: [
                  Text('${pokemon.height / 10} M',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                        color: Colors.yellow,
                      )),
                  Text('Height',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Colors.white70,
                      )),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "Base Status",
            style: textStyle,
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: pokemon.stats.length,
                itemBuilder: (context, index) {
                  final poke = pokemon.stats[index];

                  return Column(
                    children: [
                      Text(
                        '${poke.stat.name} = ${poke.baseStat}',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.yellow,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        height: 3,
                      )
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
