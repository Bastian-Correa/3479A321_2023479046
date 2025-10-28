import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/configuration_data.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class PixelArt {
  final String id;
  final String title;
  final int size; // tamaño de la grilla
  final List<String> palette; // colores
  final List<String> gridData; // cada celda
  final DateTime createdAt;
  final DateTime lastModifiedAt;

  PixelArt({
    required this.id,
    required this.title,
    required this.size,
    required this.palette,
    required this.gridData,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'size': size,
    'palette': palette,
    'gridData': gridData,
    'createdAt': createdAt.toIso8601String(),
    'lastModifiedAt': lastModifiedAt.toIso8601String(),
  };

  factory PixelArt.fromJson(Map<String, dynamic> json) => PixelArt(
    id: json['id'] as String,
    title: json['title'] as String,
    size: json['size'] as int,
    palette: List<String>.from(json['palette'] as List<dynamic>),
    gridData: List<String>.from(json['gridData'] as List<dynamic>),
    createdAt: DateTime.parse(json['createdAt'] as String),
    lastModifiedAt: DateTime.parse(json['lastModifiedAt'] as String),
  );
}

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
  bool _showNumbers = true; // mostrar/ocultar números

  File? _backgroundImage;
  bool _backgroundVisible = true; // opcional toggle

  // Paleta de colores
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
    _sizeGrid = context.read<ConfigurationData>().size;

    _cellColors = List<Color>.generate(
      _sizeGrid * _sizeGrid,
      (index) => Colors.transparent,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newSize = context.watch<ConfigurationData>().size;
    if (newSize != _sizeGrid) {
      setState(() {
        _sizeGrid = newSize;
        _cellColors = List<Color>.generate(
          _sizeGrid * _sizeGrid,
          (index) => Colors.transparent,
        );
      });
    }
  }

  String _colorToHex(Color c) => c.value.toRadixString(16).padLeft(8, '0');
  Color _hexToColor(String hex) => Color(int.parse(hex, radix: 16));

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/background_image.png';

      final newImage = File(pickedFile.path);
      if (_backgroundImage != null && _backgroundImage!.existsSync()) {
        _backgroundImage!.deleteSync();
      }
      newImage.copySync(filePath);

      setState(() {
        _backgroundImage = File(filePath);
      });
    }
  }

  void _deleteBackgroundImage() {
    if (_backgroundImage != null && _backgroundImage!.existsSync()) {
      _backgroundImage!.deleteSync();
    }
    setState(() {
      _backgroundImage = null;
    });
  }

  //Guardar el pixel art como PNG en almacenamiento persistente
  Future<void> _savePixelArt() async {
    const double cellSize = 20.0; // tamaño de cada celda

    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, _sizeGrid * cellSize, _sizeGrid * cellSize),
      );

      // Fondo blanco
      canvas.drawRect(
        Rect.fromLTWH(0, 0, _sizeGrid * cellSize, _sizeGrid * cellSize),
        Paint()..color = Colors.white,
      );

      // Pintar cada celda
      final paint = Paint();
      for (int row = 0; row < _sizeGrid; row++) {
        for (int col = 0; col < _sizeGrid; col++) {
          final idx = row * _sizeGrid + col;
          paint.color = _cellColors[idx];
          final rect = Rect.fromLTWH(
            col * cellSize,
            row * cellSize,
            cellSize,
            cellSize,
          );
          canvas.drawRect(rect, paint);
        }
      }

      // Cerrar y exportar
      final picture = recorder.endRecording();
      final width = (_sizeGrid * cellSize).toInt();
      final height = (_sizeGrid * cellSize).toInt();
      final image = await picture.toImage(width, height);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('No se pudo codificar a PNG');
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/pixel_art_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      if (mounted) {
        context.read<ConfigurationData>().addCreation(filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pixel art guardado en: $filePath')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    }
  }

  Future<void> _saveProgress() async {
    // Diálogo para pedir título (nombre del dibujo)
    final titleController = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Guardar progreso'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Nombre del dibujo'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
    if (!mounted || titleController.text.trim().isEmpty) return;

    final now = DateTime.now();

    // Serializamos paleta y grilla
    final paletteHex = _listColors.map(_colorToHex).toList();
    final gridHex = _cellColors.map(_colorToHex).toList();

    final pixelArt = PixelArt(
      id: 'pixelart_${now.millisecondsSinceEpoch}',
      title: titleController.text.trim(),
      size: _sizeGrid,
      palette: paletteHex,
      gridData: gridHex,
      createdAt: now,
      lastModifiedAt: now,
    );

    //Nombre de archivo
    final directory = await getApplicationDocumentsDirectory();
    final safeTitle = titleController.text
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');

    final filePath =
        '${directory.path}/'
        '${safeTitle.isEmpty ? 'untitled' : safeTitle}'
        '_${pixelArt.id}.json';

    final file = File(filePath);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(pixelArt.toJson()),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Progreso guardado en: $filePath')),
      );
    }
  }

  Future<void> _loadProgress() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory
        .listSync()
        .where((e) => e is File && e.path.endsWith('.json'))
        .cast<File>()
        .toList();

    if (files.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay progresos guardados')),
      );
      return;
    }

    File? selectedFile;
    await showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Selecciona un progreso'),
        children: files
            .map(
              (f) => SimpleDialogOption(
                child: Text(f.uri.pathSegments.last),
                onPressed: () {
                  selectedFile = f;
                  Navigator.pop(ctx);
                },
              ),
            )
            .toList(),
      ),
    );
    if (selectedFile == null) return;

    final jsonStr = await selectedFile!.readAsString();
    final pixelArt = PixelArt.fromJson(
      json.decode(jsonStr) as Map<String, dynamic>,
    );

    // Reconstruir la grilla. Si el tamaño del archivo difiere, se ajusta.
    final loadedSize = pixelArt.size;
    final loadedColors = pixelArt.gridData.map(_hexToColor).toList();

    setState(() {
      _sizeGrid = loadedSize;

      final total = _sizeGrid * _sizeGrid;
      _cellColors = List<Color>.filled(
        total,
        Colors.transparent,
        growable: false,
      );

      final n = (loadedColors.length < total) ? loadedColors.length : total;
      for (int i = 0; i < n; i++) {
        _cellColors[i] = loadedColors[i];
      }
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Progreso cargado: ${pixelArt.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cfg = context.watch<ConfigurationData>(); // ← opacidad en vivo

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creation Process'),
        actions: [
          IconButton(
            tooltip: 'Tomar foto (referencia)',
            icon: const Icon(Icons.camera_alt),
            onPressed: _takePicture,
          ),
          if (_backgroundImage != null)
            IconButton(
              tooltip: 'Eliminar fondo',
              icon: const Icon(Icons.delete),
              onPressed: _deleteBackgroundImage,
            ),
          IconButton(
            tooltip: 'Guardar progreso',
            icon: const Icon(Icons.save), // disquete
            onPressed: _saveProgress,
          ),
          IconButton(
            tooltip: 'Cargar progreso',
            icon: const Icon(Icons.folder_open),
            onPressed: _loadProgress,
          ),

          // Tu toggle de números y exportar PNG
          IconButton(
            tooltip: _showNumbers ? 'Ocultar números' : 'Mostrar números',
            icon: Icon(_showNumbers ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _showNumbers = !_showNumbers),
          ),
          IconButton(
            tooltip: 'Guardar PNG',
            icon: const Icon(Icons.save_alt),
            onPressed: _savePixelArt,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Slider de opacidad
            if (_backgroundImage != null)
              Column(
                children: [
                  const Text('Ajustar Opacidad'),
                  Slider(
                    value: cfg.backgroundOpacity, // usa provider
                    min: 0.1,
                    max: 1.0,
                    divisions: 10,
                    label: '${(cfg.backgroundOpacity * 100).toInt()}%',
                    onChanged: (value) => context
                        .read<ConfigurationData>()
                        .setBackgroundOpacity(value), // persiste
                  ),
                ],
              ),

            // Grilla + imagen de fondo
            Expanded(
              child: Stack(
                children: [
                  if (_backgroundImage != null && _backgroundVisible)
                    Opacity(
                      opacity: cfg.backgroundOpacity, // usa provider
                      child: Image.file(
                        _backgroundImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _sizeGrid,
                      childAspectRatio: 1,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                    ),
                    itemCount: _sizeGrid * _sizeGrid,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _cellColors[index] = _selectedColor;
                          });
                        },
                        child: Container(
                          color: _cellColors[index],
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final fontSize = constraints.maxWidth * 0.35;
                              return Center(
                                child: _showNumbers
                                    ? Text(
                                        '$index',
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          color:
                                              _cellColors[index] == Colors.black
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Footer con paleta
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
