import 'package:flutter/material.dart';
import 'list_art.dart';
import 'lista_creaciones.dart';
import 'sobre.dart';
import 'config_screen.dart';
import 'package:lab2/pixel_art_screen.dart';
import 'package:provider/provider.dart';
import 'providers/configuration_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Color para todo (App y botones al comenzar al app)
  //Color _themeColor = const Color.fromARGB(255, 211, 182, 231);

  // Valor de reinicio (es 0)
  static const int _defaultCounter = 0;

  // Para Aumentar
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Para disminuir
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  // Para reiniciar
  void _resetCounter() {
    setState(() {
      _counter = _defaultCounter; // Usa constante
    });
  }

  // Abre la paleta de colores
  void _palette() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 260,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Elige un color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _colorOption('magenta', const Color(0xFFE91E63)),
                  _colorOption('cian', const Color(0xFF009688)),
                  _colorOption('amber', const Color(0xFFFFC107)),
                  _colorOption('purple', const Color(0xFF9C27B0)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _colorOption(String key, Color color) {
    return GestureDetector(
      onTap: () {
        context.read<ConfigurationData>().setPalette(
          key,
        ); // <- guarda y notifica
        Navigator.pop(context);
      },
      child: CircleAvatar(backgroundColor: color, radius: 24),
    );
  }

  // Metodo que concentra "todos" los botones al pie
  List<Widget> _buildFooterButtons(Color themeColor) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón de Menos
          ElevatedButton(
            onPressed: _decrementCounter,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(5),
              backgroundColor: themeColor,
            ),
            child: const Icon(
              Icons.remove,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),

          const SizedBox(width: 20),

          // Botón de Más
          ElevatedButton(
            onPressed: _incrementCounter,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(5),
              backgroundColor: themeColor,
            ),
            child: const Icon(Icons.add, color: Color.fromARGB(255, 0, 0, 0)),
          ),

          const SizedBox(width: 20),

          // Botón de Reiniciar
          ElevatedButton(
            onPressed: _resetCounter,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(5),
              backgroundColor: themeColor,
            ),
            child: const Icon(
              Icons.refresh,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),

          const SizedBox(width: 20),

          // Botón de paleta
          ElevatedButton(
            onPressed: _palette,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(5),
              backgroundColor: themeColor,
            ),
            child: const Icon(
              Icons.palette,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Tomamos el color actual desde el Provider
    final cfg = context.watch<ConfigurationData>();
    final themeColor = cfg.paletteColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor, // Usa el color elegido de la paleta
        title: Text(widget.title),
        actions: [
          // Botón para abrir Configuración
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConfigScreen()),
              );
            },
          ),

          // Ícono que abre la pantalla "Sobre"
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sobre',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),

      // Card principal del Home
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.hardEdge, // recorta contenido que se salga
          child: Column(
            mainAxisSize: MainAxisSize.min, // alto ajustado al contenido
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.asset('assets/Fondo.jpg', fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pixel Arts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Contador: $_counter',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),

                    // Botones con tamaños configurables
                    Row(
                      children: [
                        // Crear
                        SizedBox(
                          width: 80,
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ListArtScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.brush, size: 12),
                            label: const Text(
                              'Crear',
                              style: TextStyle(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Compartir
                        SizedBox(
                          width: 90,
                          height: 40,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Compartido')),
                              );
                            },
                            icon: const Icon(Icons.share, size: 12),
                            label: const Text(
                              'Compartir',
                              style: TextStyle(fontSize: 14),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Creaciones
                        SizedBox(
                          width: 90,
                          height: 40,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreacionesScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.collections, size: 12),
                            label: const Text(
                              'Creaciones',
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),

                        // Ir a la pantalla de estados
                        IconButton(
                          icon: const Icon(Icons.monitor_heart),
                          tooltip: 'Estados',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PixelArtScreen(parentCounter: _counter),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: _buildFooterButtons(themeColor),
    );
  }
}
