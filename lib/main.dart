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
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 0, 0, 0),
            ), // Icono dentro
          ),

          const SizedBox(width: 20),

          // Botón de Reiniciar
          ElevatedButton(
            onPressed: _resetCounter,
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
                borderRadius: BorderRadius.circular(
                  12,
                ), // Botón Cubito semicircular
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Pixel Art sobre una grilla personalizable'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      persistentFooterButtons: _buildFooterButtons(),
    );
  }
}

  // --- CARD de Home con título + imagen + botones (Crear / Compartir) ---
  Widget _buildHomeCard(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pixel Art sobre una grilla personalizable',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Imagen (usa Asset si tienes uno; aquí queda placeholder)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black12,
                // Si tienes un asset real:
                // child: Image.asset('assets/preview.png', fit: BoxFit.cover),
                child: const Center(child: Text('Imágenes.')),
              ),
            ),
            const SizedBox(height: 12),

            // Botones Crear / Compartir
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.brush),
                  label: const Text('Crear'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ListArtScreen()),
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Compartir'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Compartir (placeholder)')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeColor, // Usa el color elegido de la paleta
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sobre') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SobreScreen()),
                );
              } else if (value == 'creaciones') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListaCreacionesScreen()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(value: 'sobre', child: Text('Sobre')),
              PopupMenuItem<String>(value: 'creaciones', child: Text('Mis creaciones')),
            ],
          ),
        ],
      ),

      // Muestra la Card solicitada en el centro
      body: Center(child: _buildHomeCard(context)),

      // Mantiene los botones del pie
      persistentFooterButtons: _buildFooterButtons(),
    );
  }
}