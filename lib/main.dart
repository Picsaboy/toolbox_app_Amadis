import 'package:flutter/material.dart';
import 'genero.dart';
import 'edad.dart';
import 'pokemon.dart';
import 'universidades.dart';
import 'clima.dart';
import 'noticias.dart';
import 'acerca_de.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predicciones App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 247, 211),
        title: Text("Inicio")),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/toolbox.png'),
            Text("Bienvenido a la app de predicciones", style: TextStyle(fontSize: 18)),
          ],
        )        
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: const Color.fromARGB(255, 30, 247, 211)),
            child: Text(
              "Menú de Navegación",
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 20),
            ),
          ),
          _buildMenuItem(context, Icons.batch_prediction, 'Predicción de Género', GenderPredictorScreen()),
          _buildMenuItem(context, Icons.person, 'Predicción de Edad', AgePredictorScreen()),
          _buildMenuItem(context, Icons.games, 'Pokemon', PokemonScreen()),
          _buildMenuItem(context, Icons.science, 'Universidades', UniversitySearchScreen()),
          _buildMenuItem(context, Icons.cloud, 'Clima', ClimaScreen()),
          _buildMenuItem(context, Icons.newspaper, 'Noticias', NoticiasScreen()),
          _buildMenuItem(context, Icons.info, 'Acerca de', AcercaDeScreen()),
          
          
        ],
      ),
    );
  }

  static Widget _buildMenuItem(BuildContext context, IconData icon, String title, Widget screen) {
    return MouseRegion(
    onEnter: (_) {
      _hovered = true;
    },
    onExit: (_) {
      _hovered = false;
    },
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      tileColor: _hovered ? Colors.blue.shade100 : null,
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        },
      ),
    );
  }
  static bool _hovered = false;
}
