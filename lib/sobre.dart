import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con el título de la pantalla "Sobre"
      appBar: AppBar(title: const Text('Sobre el proyecto')),

      // Padding externo para separar la Card de los bordes de la pantalla
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Desarrollador: Bastián Correa',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8), // espacio entre título y descripción
                const Text(
                  'Proyecto de pixel art con navegación básica entre pantallas, '
                  'listas con ListView y uso de Card para la pantalla principal.',
                ),
                const SizedBox(height: 16),
                // Botón Volver alineado a la derecha
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    // Navigator.pop: vuelve a la pantalla anterior
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver'),
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
