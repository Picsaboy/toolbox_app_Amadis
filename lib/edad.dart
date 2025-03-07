import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class AgePredictorScreen extends StatefulWidget {
  @override
  _AgePredictorScreenState createState() => _AgePredictorScreenState();
}

class _AgePredictorScreenState extends State<AgePredictorScreen> {
  TextEditingController _nameController = TextEditingController();
  String _message = "Introduce un nombre y presiona el boton";
  int _age = 0;
  String _imagePath = "assets/young.png";

  Future<void> predictAge(String name) async {
    final url = Uri.parse("https://api.agify.io/?name=$name");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        int age = data['age'] ?? 0;

        setState(() {
          _age = age;
          _message = "Edad estimada: $_age años";

          if (_age <= 18) {
            _imagePath = "assets/young.png";
            _message += "\nClasificacion: Joven";
          } else if (_age > 18 && _age <= 60) {
            _imagePath = "assets/adult.png";
            _message += "\nClasificacion: Adulto";
          } else {
            _imagePath = "assets/old.png";
            _message += "\nClasificacion: Anciano";
          }
        });
      } else {
        setState(() {
          _message = "Error al obtener la edad";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error de conexion";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prediccion de Edad"),
      backgroundColor: Colors.cyan,),
      drawer: AppDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "Introduce un nombre",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    if (name.isNotEmpty) {
                      predictAge(name);
                    } else {
                      setState(() {
                        _message = "Por favor, introduce un nombre valido";
                      });
                    }
                  },
                  child: Text("Predecir Edad"),
                ),
                SizedBox(height: 20),
                Text(
                  _message,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Image.asset(_imagePath, height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
