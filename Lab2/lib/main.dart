import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart' show Logger;
import 'pages/home.dart'; // importa la pantalla

final _log = Logger();

void main() {
  _log.d('MI APP INICIANDO!');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2023479046',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 108, 108),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          // Para que el titulo del AppBar tambien use la fuente (la ennegreceremos para que sea mas facil de ver)
          titleTextStyle: GoogleFonts.poppins(
            //Aplica la fuente a toda la aplicación de forma directa
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      home: const MyHomePage(title: '2023479046'),
    );
  }
}
