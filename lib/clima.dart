import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class ClimaScreen extends StatefulWidget {
  @override
  _ClimaScreenState createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  String _mensaje = "Presiona el botón para ver el clima";
  String _ciudad = "Santo Domingo";
  double? _temperatura;
  String? _descripcion;
  String? _icono;
  double? _humedad;
  double? _viento;
  double? _sensacionTermica;

  Future<void> obtenerClima() async {
    const String apiKey = "685e8698daa94306a6e40739250303";
    final String url =
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$_ciudad&lang=es";

    try {
      final response = await http.get(Uri.parse(url));

      print("Estado de la respuesta: ${response.statusCode}");
      print("Respuesta completa: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _temperatura = data["current"]["temp_c"];
          _descripcion = data["current"]["condition"]["text"];
          _icono = data["current"]["condition"]["icon"];
          _humedad = data["current"]["humidity"].toDouble();
          _viento = data["current"]["wind_kph"].toDouble();
          _sensacionTermica = data["current"]["feelslike_c"].toDouble();
          _mensaje = "Clima en $_ciudad";
        });
      } else {
        setState(() {
          _mensaje = "Error en la API: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _mensaje = "Error de conexión: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 247, 211),
        title: Text("Clima en RD")),
      drawer: AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _mensaje,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              if (_icono != null)
                Image.network("https:$_icono"),
              SizedBox(height: 10),
              if (_temperatura != null)
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("$_descripcion".toUpperCase(),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("🌡 Temperatura: $_temperatura°C",
                            style: TextStyle(fontSize: 16)),
                        Text("🔥 Sensación térmica: $_sensacionTermica°C",
                            style: TextStyle(fontSize: 16)),
                        Text("💧 Humedad: $_humedad%",
                            style: TextStyle(fontSize: 16)),
                        Text("💨 Viento: $_viento km/h",
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: obtenerClima,
                child: Text("Actualizar Clima"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
