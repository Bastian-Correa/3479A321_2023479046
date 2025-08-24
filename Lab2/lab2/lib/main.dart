import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2023479046',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 239, 235, 239),
        ),
      ),
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

  //Color para todo (App y botones)
  Color _themeColor = const Color.fromARGB(255, 211, 182, 231);

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
      _counter = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeColor, //Usa el color elegido de la paleta
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

      //Botón de Paleta
      floatingActionButton: FloatingActionButton(
        onPressed: _palette,
        tooltip: 'Elegir color',
        backgroundColor: _themeColor,
        child: const Icon(Icons.palette),
      ),

      //Botones de abajo
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _decrementCounter, //Botón de Menos
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), ////Botón Cubito semicircular
                ),
                padding: const EdgeInsets.all(10), //Espacio alrededor del icono
                backgroundColor: _themeColor, //Color asignado de paleta
              ),
              child: const Icon(
                Icons.remove,
                color: Color.fromARGB(255, 0, 0, 0),
              ), //Icono dentro
            ),

            const SizedBox(width: 40),
            ElevatedButton(
              onPressed: _incrementCounter, //Botón de Mas
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), ////Botón Cubito semicircular
                ),
                padding: const EdgeInsets.all(10), //Espacio alrededor del icono
                backgroundColor: _themeColor, //Color asignado de paleta
              ),
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 0, 0, 0),
              ), //Icono dentro
            ),

            const SizedBox(width: 40),
            ElevatedButton(
              onPressed: _resetCounter, //Botón de Reiniciar
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12,
                  ), ////Botón Cubito semicircular
                ),
                padding: const EdgeInsets.all(10), //Espacio alrededor del icono
                backgroundColor: _themeColor, //Color asignado de paleta
              ),
              child: const Icon(
                Icons.refresh,
                color: Color.fromARGB(255, 0, 0, 0),
              ), //Icono dentro
            ),
          ],
        ),
      ],
    );
  }
}
