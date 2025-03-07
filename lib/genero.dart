import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class GenderPredictorScreen extends StatefulWidget {
  @override
  _GenderPredictorScreenState createState() => _GenderPredictorScreenState();
}

class _GenderPredictorScreenState extends State<GenderPredictorScreen> {
  TextEditingController _nameController = TextEditingController();
  Color _backgroundColor = Colors.white;
  String _message = "Introduce un nombre y presiona el botón";
  String _imageAsset = "";

  Future<void> predictGender(String name) async {
    final url = Uri.parse("https://api.genderize.io/?name=$name");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String gender = data['gender'] ?? 'unknown';

        setState(() {
          if (gender == 'male') {
            _backgroundColor = Colors.blue.shade300;
            _message = "Género: Masculino";
            _imageAsset = "assets/male.png";
          } else if (gender == 'female') {
            _backgroundColor = Colors.pink.shade300;
            _message = "Género: Femenino";
            _imageAsset = "assets/female.png";
          } else {
            _backgroundColor = Colors.grey.shade300;
            _message = "Género no identificado";
            _imageAsset = "";
          }
        });
      } else {
        setState(() {
          _message = "Error al obtener los datos";
          _backgroundColor = Colors.red.shade300;
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error de conexión";
        _backgroundColor = Colors.red.shade300;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.pink], 
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text("Predicción de Género"),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    if (name.isNotEmpty) {
                      predictGender(name);
                    } else {
                      setState(() {
                        _message = "Por favor, introduce un nombre válido";
                        _backgroundColor = Colors.white;
                        _imageAsset = "";
                      });
                    }
                  },
                  child: Text("Predecir Género"),
                ),
                SizedBox(height: 20),
                if (_imageAsset.isNotEmpty)
                  Image.asset(
                    _imageAsset,
                    height: 100,
                  ),
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      _message,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
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
