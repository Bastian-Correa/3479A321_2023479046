import 'package:flutter/material.dart';
import 'list_art.dart';
import 'lista_creaciones.dart';
import 'sobre.dart';
import 'config_screen.dart';
import 'package:lab2/pixel_art_screen.dart';
import 'package:provider/provider.dart';
import 'providers/configuration_data.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart'; // compartir imágenes

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Valor de reinicio (es 0)
  static const int _defaultCounter = 0;

  //Estado para el "último archivo creado"
  File? _lastFile; // referencia al último PNG guardado
  bool _loadingLast = false; // indicador de carga

  @override
  void initState() {
    super.initState();
    // Cargamos el último archivo al iniciar Home
    _loadLastCreation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cfg = context.read<ConfigurationData>();
      cfg.addListener(_onConfigChanged);
    });
  }

  @override
  void dispose() {
    // Quitamos listener para evitar fugas
    final cfg = context.read<ConfigurationData>();
    cfg.removeListener(_onConfigChanged);
    super.dispose();
  }

  // Se llama cuando ConfigurationData notifica cambios
  void _onConfigChanged() {
    _loadLastCreation();
  }

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

  //Carga del último archivo creado
  Future<void> _loadLastCreation() async {
    setState(() => _loadingLast = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final entries = await dir
          .list(recursive: false, followLinks: false)
          .where((e) => e is File && e.path.toLowerCase().endsWith('.png'))
          .toList();

      // Filtrar por prefijo de exportación
      final pngs = entries
          .cast<File>()
          .where((f) => f.path.contains('pixel_art_'))
          .toList();

      if (pngs.isEmpty) {
        if (mounted) setState(() => _lastFile = null);
      } else {
        // Ordenar por fecha de modificación descendente (más reciente primero)
        pngs.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
        );
        if (mounted) setState(() => _lastFile = pngs.first);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo cargar el último archivo: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingLast = false);
    }
  }

  //Para refrescar al volver de pantallas de creación/listado
  Future<void> _pushAndRefresh(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    // Al regresar, recargamos el último archivo
    await _loadLastCreation();
  }

  // Diálogo simple para ver la imagen grande
  void _openPreview(File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: Image.file(file, fit: BoxFit.contain),
        ),
      ),
    );
  }

  //Compartir último archivo con mensaje personalizado
  Future<void> _shareLastFile() async {
    if (_lastFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay imagen para compartir')),
      );
      return;
    }
    String mensaje = '';
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Mensaje para compartir'),
          content: TextField(
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Escribe tu mensaje...',
            ),
            onChanged: (value) => mensaje = value,
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(ctx),
            ),
            ElevatedButton(
              child: const Text('Compartir'),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    try {
      await Share.shareXFiles(
        [XFile(_lastFile!.path, mimeType: 'image/png')],
        text: mensaje,
        subject: 'Mi pixel art',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al compartir: $e')));
    }
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

                    //Presentación del último archivo creado
                    if (_loadingLast)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: LinearProgressIndicator(),
                      )
                    else
                      InkWell(
                        onTap: _lastFile != null
                            ? () => _openPreview(_lastFile!)
                            : null,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: _lastFile == null
                                      ? const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                          ),
                                        )
                                      : Image.file(
                                          _lastFile!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _lastFile == null
                                          ? 'Sin creaciones aún'
                                          : _lastFile!.uri.pathSegments.last,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _lastFile == null
                                          ? 'Crea tu primer pixel art para verlo aquí.'
                                          : 'Último archivo creado',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.open_in_full),
                            ],
                          ),
                        ),
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
                              // Al regresar desde esta pantalla, refrescamos
                              _pushAndRefresh(const ListArtScreen());
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

                        // Compartir (AHORA usa share_plus)
                        SizedBox(
                          width: 90,
                          height: 40,
                          child: OutlinedButton.icon(
                            onPressed: _shareLastFile, // <-- CAMBIO
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
                              // Al regresar desde Creaciones
                              _pushAndRefresh(const CreacionesScreen());
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
                            // Al regresar desde PixelArtScreen
                            _pushAndRefresh(
                              PixelArtScreen(parentCounter: _counter),
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
