import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class PokemonScreen extends StatefulWidget {
  @override
  _PokemonScreenState createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  TextEditingController _pokemonController = TextEditingController();
  String _message = "Introduce un nombre de Pokemon y presiona el boton";
  String _imageUrl = "";
  int _baseExperience = 0;
  List<String> _abilities = [];

  Future<void> fetchPokemonData(String name) async {
    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _imageUrl = data['sprites']['front_default'] ?? "";
          _baseExperience = data['base_experience'] ?? 0;
          _abilities = (data['abilities'] as List)
              .map((item) => item['ability']['name'].toString())
              .toList();
          _message = "Informacion de ${name.toUpperCase()}";
        });
      } else {
        setState(() {
          _message = "Pokemon no encontrado";
          _imageUrl = "";
          _baseExperience = 0;
          _abilities = [];
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error de conexion";
        _imageUrl = "";
        _baseExperience = 0;
        _abilities = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text("Consulta de Pokemon"),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _pokemonController,
                    decoration: InputDecoration(
                      labelText: "Introduce un Pokemon",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String name = _pokemonController.text.trim();
                    if (name.isNotEmpty) {
                      fetchPokemonData(name);
                    } else {
                      setState(() {
                        _message = "Por favor, introduce un nombre valido";
                      });
                    }
                  },
                  child: Text("Buscar Pokemon"),
                ),
                SizedBox(height: 20),
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _message,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          if (_imageUrl.isNotEmpty) ...[
                            SizedBox(height: 20),
                            Image.network(_imageUrl, height: 150),
                          ],
                          if (_baseExperience > 0) ...[
                            SizedBox(height: 10),
                            Text("Experiencia base: $_baseExperience",
                                style: TextStyle(fontSize: 16)),
                          ],
                          if (_abilities.isNotEmpty) ...[
                            SizedBox(height: 10),
                            Text("Habilidades:",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ..._abilities.map((ability) =>
                                Text(ability, style: TextStyle(fontSize: 14))).toList(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
