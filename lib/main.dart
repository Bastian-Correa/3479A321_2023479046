import 'package:flutter/material.dart';
import 'list_art.dart';
import 'lista_creaciones.dart';
import 'sobre.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2023479046',
      theme: ThemeData(),
      home: const MyHomePage(title: '2023479046'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  //Color para todo (App y botones al comenzar al app)
  Color _themeColor = const Color.fromARGB(255, 211, 182, 231);

  //Valor de reinicio (es 0)
  static const int _defaultCounter = 0;

  //Para Aumentar
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  //Para disminuir
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  //Para reiniciar
  void _resetCounter() {
    setState(() {
      _counter = _defaultCounter; // Usa constante
    });
  }

  //Abre la paleta de colores
  void _palette() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 260, //Tamaño de la paleta
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
                  _colorOption(const Color.fromARGB(255, 233, 30, 99)),
                  _colorOption(const Color.fromARGB(255, 0, 151, 136)),
                  _colorOption(const Color.fromARGB(255, 255, 153, 0)),
                  _colorOption(const Color.fromARGB(255, 156, 39, 176)),
                  _colorOption(const Color.fromARGB(255, 33, 153, 251)),
                  _colorOption(const Color.fromARGB(255, 74, 233, 30)),
                  _colorOption(const Color.fromARGB(255, 17, 0, 255)),
                  _colorOption(const Color.fromARGB(255, 251, 255, 0)),
                  _colorOption(const Color.fromARGB(255, 0, 255, 225)),
                  _colorOption(const Color.fromARGB(255, 255, 0, 0)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //Un circulito que al tocarlo cambia el color del tema
  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() => _themeColor = color);
        Navigator.pop(context); //Cerrar el modal
      },
      child: CircleAvatar(backgroundColor: color, radius: 24),
    );
  }

  // Metodo que concentra "todos" los botones al pie
  List<Widget> _buildFooterButtons() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón de Menos
          ElevatedButton(
            onPressed: _decrementCounter,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ), // Botón Cubito semicircular
              ),
              padding: const EdgeInsets.all(5), // Espacio alrededor del icono
              backgroundColor: _themeColor, // Color asignado de paleta
            ),
            child: const Icon(
              Icons.remove,
              color: Color.fromARGB(255, 0, 0, 0),
            ), // Icono dentro
          ),

          const SizedBox(width: 20),

          // Botón de Más
          ElevatedButton(
            onPressed: _incrementCounter,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ), // Botón Cubito semicircular
              ),
              padding: const EdgeInsets.all(5), // Espacio alrededor del icono
              backgroundColor: _themeColor, // Color asignado de paleta
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
              padding: const EdgeInsets.all(5), // Espacio alrededor del icono
              backgroundColor: _themeColor, // Color asignado de paleta
            ),
            child: const Icon(
              Icons.refresh,
              color: Color.fromARGB(255, 0, 0, 0),
            ), // Icono dentro
          ),

          const SizedBox(width: 20),

          // Botón de paleta, abajo en el pie con los demas botones
          ElevatedButton(
            onPressed: _palette,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(5), // Espacio alrededor del icono
              backgroundColor: _themeColor, // Color asignado de paleta
            ),
            child: const Icon(
              Icons.palette,
              color: Color.fromARGB(255, 0, 0, 0),
            ), // Icono dentro
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeColor, // Usa el color elegido de la paleta
        title: Text(widget.title),
        actions: [
          // Ícono que abre la pantalla "Sobre" (Navigator.push)
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

      //Card principal del Home
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip
              .hardEdge, // recorta contenido que se salga (en este caso la imagen)
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

                    //Botones con tamaños configurables
                    Row(
                      children: [
                        // Crear
                        SizedBox(
                          width: 100, // ancho
                          height: 40, // altura
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ListArtScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.brush, size: 18),
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
                          width: 100,
                          height: 40,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Compartido')),
                              );
                            },
                            icon: const Icon(Icons.share, size: 18),
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
                          width: 100,
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
                            icon: const Icon(Icons.collections, size: 18),
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
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: _buildFooterButtons(),
    );
  }
}
