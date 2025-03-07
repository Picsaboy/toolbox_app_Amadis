import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as htmlParser;
import 'main.dart';

class NoticiasScreen extends StatefulWidget {
  @override
  _NoticiasScreenState createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  String logoUrl = "https://wptavern.com/wp-content/uploads/2023/06/cropped-tavern-favicon.png";
  bool isSvg = false;
  List noticias = [];

  @override
  void initState() {
    super.initState();
    obtenerNoticias();
    obtenerLogo();
  }

  Future<void> obtenerLogo() async {
    const String logoApiUrl = "https://wptavern.com/wp-json/wp/v2/media/127030";
    try {
      final response = await http.get(Uri.parse(logoApiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          logoUrl = data["source_url"] ?? logoUrl;
          isSvg = logoUrl.endsWith(".svg");
        });
      } else {
        print("Error al obtener el logo: ${response.statusCode}");
      }
    } catch (e) {
      print("Error de conexión: $e");
    }
  }

  Future<void> obtenerNoticias() async {
    const String apiUrl = "https://wptavern.com/wp-json/wp/v2/posts?_embed&per_page=3";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          noticias = jsonDecode(response.body);
        });
      } else {
        print("Error al obtener noticias: ${response.statusCode}");
      }
    } catch (e) {
      print("Error de conexión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 247, 211),
        title: Text("Noticias de WordPress")),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLogo(),
            SizedBox(height: 10),
            Expanded(child: _buildNoticiasList()),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return isSvg
        ? SvgPicture.network(
            logoUrl,
            height: 60,
            placeholderBuilder: (context) => Center(child: CircularProgressIndicator()),
          )
        : Image.network(
            logoUrl,
            height: 60,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 50, color: Colors.red);
            },
          );
  }

  Widget _buildNoticiasList() {
    return noticias.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              final noticia = noticias[index];
              final titulo = htmlParser.parse(noticia["title"]["rendered"]).body!.text;
              final resumen = htmlParser.parse(noticia["excerpt"]["rendered"]).body!.text;
              final url = noticia["link"];

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titulo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(resumen, maxLines: 3, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _abrirURL(url),
                        child: Text("Leer más"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  void _abrirURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("No se pudo abrir la URL: $url");
    }
  }
}
