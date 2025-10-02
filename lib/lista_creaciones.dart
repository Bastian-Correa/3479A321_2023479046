import 'package:flutter/material.dart';

class CreacionesScreen extends StatelessWidget {
  const CreacionesScreen({super.key});

  // Lista de creaciones
  final List<Map<String, String>> _creaciones = const [
    {'nombre': 'Slime', 'fecha': '06-04-2025'},
    {'nombre': 'Guerrero base', 'fecha': '02-04-2025'},
    {'nombre': 'Fondo bosque', 'fecha': '26-08-2025'},
    {'nombre': 'Icono manzana', 'fecha': '09-07-2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis creaciones')),
      // ListView.builder: renderiza filas bajo demanda (Con listas largas)
      body: ListView.builder(
        itemCount: _creaciones.length,
        itemBuilder: (context, index) {
          final c = _creaciones[index];
          // ListTile: fila estándar con avatar, título, subtítulo e ícono trailing
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.image)),
            title: Text(c['nombre']!),
            subtitle: Text('Creado: ${c['fecha']}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Abriendo ${c['nombre']}')),
              );
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
