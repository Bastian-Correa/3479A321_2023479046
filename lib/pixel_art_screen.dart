import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/configuration_data.dart';
// ignore_for_file: library_private_types_in_public_api

class PixelArtScreen extends StatefulWidget {
  final int? parentCounter;
  const PixelArtScreen({super.key, this.parentCounter});

  @override
  _PixelArtScreenState createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  int _sizeGrid = 16; // tamaño de la grilla
  Color _selectedColor = Colors.black; // color actualmente seleccionado
  bool _showNumbers = true; // Mostrar/ocultar números

  // Paleta de colores disponibles
  final List<Color> _listColors = const [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.brown,
    Colors.grey,
    Colors.pink,
  ];

  // Lista de colores por celda de la grilla
  late List<Color> _cellColors;

  @override
  void initState() {
    super.initState();
    debugPrint("[PixelArt] initState. Mounted: $mounted");

    // tomar el size desde el Provider
    _sizeGrid = context.read<ConfigurationData>().size;
    debugPrint("[PixelArt] Grid size set to: $_sizeGrid");

    // asegurar que la grilla coincide con el tamaño inicial
    _cellColors = List<Color>.generate(
      _sizeGrid * _sizeGrid,
      (index) => Colors.transparent,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // si cambia el size en el Provider, regeneramos la grilla
    final newSize = context.watch<ConfigurationData>().size;
    if (newSize != _sizeGrid) {
      setState(() {
        _sizeGrid = newSize;
        _cellColors = List<Color>.generate(
          _sizeGrid * _sizeGrid,
          (index) => Colors.transparent,
        );
      });
      debugPrint("[PixelArt] Grid resized: $_sizeGrid x $_sizeGrid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creation Process'),
        actions: [
          // Toggle para mostrar/ocultar números
          IconButton(
            tooltip: _showNumbers ? 'Ocultar números' : 'Mostrar números',
            icon: Icon(_showNumbers ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _showNumbers = !_showNumbers),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$_sizeGrid x $_sizeGrid'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter title',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          debugPrint('[PixelArt] Title entered: $value');
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => debugPrint('[PixelArt] Submit pressed'),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),

            // Grilla de píxeles
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _sizeGrid,
                  childAspectRatio: 1, // celdas cuadradas
                  mainAxisSpacing: 1, // separación vertical
                  crossAxisSpacing: 1, // separación horizontal
                ),
                itemCount: _sizeGrid * _sizeGrid,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _cellColors[index] = _selectedColor; // pintar celda
                      });
                    },
                    child: Container(
                      color: _cellColors[index],
                      // Ajuste del tamaño del número según la celda
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final fontSize =
                              constraints.maxWidth *
                              0.35; // 35% del ancho de la celda
                          return Center(
                            child: _showNumbers
                                ? Text(
                                    '$index',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color: _cellColors[index] == Colors.black
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                : const SizedBox.shrink(), // no mostrar nada
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // Footer con paleta de colores seleccionable
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _listColors.map((color) {
                    final bool isSelected = color == _selectedColor;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.all(isSelected ? 12 : 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                        width: isSelected ? 36 : 28,
                        height: isSelected ? 36 : 28,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
