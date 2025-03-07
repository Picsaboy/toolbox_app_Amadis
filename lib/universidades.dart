import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class UniversitySearchScreen extends StatefulWidget {
  @override
  _UniversitySearchScreenState createState() => _UniversitySearchScreenState();
}

class _UniversitySearchScreenState extends State<UniversitySearchScreen> {
  TextEditingController _countryController = TextEditingController();
  String _message = "Introduce un país en inglés y presiona el botón";
  List universities = [];

  Future<void> fetchUniversities(String country) async {
    final String url = "http://universities.hipolabs.com/search?country=$country";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          universities = jsonDecode(response.body);
          _message = universities.isNotEmpty
              ? "Universidades encontradas en $country"
              : "No se encontraron universidades en este pais";
        });
      } else {
        setState(() {
          _message = "Error al obtener universidades";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error de conexion";
      });
    }
  }

  Future<void> _openWebsite(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 247, 211),
        title: Text("Buscar Universidades")),
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
                    controller: _countryController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "País (en inglés)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String country = _countryController.text.trim();
                    if (country.isNotEmpty) {
                      fetchUniversities(country);
                    } else {
                      setState(() {
                        _message = "Por favor, introduce un pais valido";
                      });
                    }
                  },
                  child: Text("Buscar Universidades"),
                ),
                SizedBox(height: 20),
                Text(
                  _message,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                universities.isEmpty
                    ? Center(child: Text("No hay resultados"))
                    : SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: universities.length,
                          itemBuilder: (context, index) {
                            var uni = universities[index];
                            return Card(
                              child: ListTile(
                                title: Text(uni["name"]),
                                subtitle: Text(uni["domains"].isNotEmpty ? uni["domains"][0] : "Sin dominio"),
                                trailing: uni["web_pages"].isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.link),
                                        onPressed: () => _openWebsite(uni["web_pages"][0]),
                                      )
                                    : null,
                              ),
                            );
                          },
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
