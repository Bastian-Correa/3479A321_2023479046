import 'package:flutter/material.dart';

class ListArtScreen extends StatelessWidget {
  const ListArtScreen({super.key});

  final List<String> _artes = const [
    'Diseño 8x8',
    'Diseño 16x16',
    'Diseño 32x32',
    'Diseño 64x64',
    'Diseño 128x128',
    'Diseño 256x256',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pixel Art disponibles')),
      // ListView.builder dibuja ítems bajo demanda (Para listas largas).
      body: ListView.builder(
        itemCount: _artes.length,
        itemBuilder: (context, index) {
          final item = _artes[index];

          // ListTile: fila estándar con ícono, título, subtítulo y un trailing.
          return ListTile(
            leading: const Icon(Icons.brush),
            title: Text(item),
            subtitle: const Text('Toca para ver detalles'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Abriendo $item')));
            },
          );
        },
      ),
      // Botón Volver, usa Navigator.pop para regresar a la pantalla anterior.
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        label: const Text('Volver'),
        tooltip: 'Volver',
        // Colores tomados del tema para asegurar  fondos claros o oscuros.
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
