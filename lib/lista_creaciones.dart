import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CreacionesScreen extends StatefulWidget {
  const CreacionesScreen({super.key});

  @override
  State<CreacionesScreen> createState() => _CreacionesScreenState();
}

class _CreacionesScreenState extends State<CreacionesScreen> {
  List<File> _creacionesFiles = [];
  bool _loading = false;

  // selección múltiple
  final Set<File> _selectedFiles = {};

  @override
  void initState() {
    super.initState();
    _loadCreaciones();
  }

  Future<void> _loadCreaciones() async {
    setState(() => _loading = true);
    try {
      final dir = await getApplicationDocumentsDirectory();
      final entries = await dir
          .list(recursive: false, followLinks: false)
          .where((e) => e is File && e.path.toLowerCase().endsWith('.png'))
          .toList();

      final pngs = entries
          .cast<File>()
          .where((f) => f.path.contains('pixel_art_'))
          .toList();

      pngs.sort(
        (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
      );

      if (mounted) setState(() => _creacionesFiles = pngs);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error leyendo creaciones: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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

  String _prettyDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$d-$m-$y $hh:$mm';
  }

  // Diálogo para mensaje personalizado y compartir
  Future<void> _shareSelectedFiles() async {
    final messenger = ScaffoldMessenger.of(context); // captura antes del await

    if (_selectedFiles.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Selecciona al menos una imagen')),
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
      final files = _selectedFiles
          .map((f) => XFile(f.path, mimeType: 'image/png'))
          .toList();

      await SharePlus.instance.share(ShareParams(files: files, text: mensaje));
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error al compartir: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis creaciones'),
        actions: [
          IconButton(
            tooltip: 'Recargar',
            onPressed: _loadCreaciones,
            icon: const Icon(Icons.refresh),
          ),
          if (_creacionesFiles.isNotEmpty)
            IconButton(
              tooltip: 'Compartir seleccionados',
              icon: const Icon(Icons.share),
              onPressed: _shareSelectedFiles,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCreaciones,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _creacionesFiles.isEmpty
            ? const Center(
                child: Text(
                  'Aún no hay imágenes guardadas.\nCrea tu primer pixel art.',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: _creacionesFiles.length,
                itemBuilder: (context, index) {
                  final file = _creacionesFiles[index];
                  final name = file.uri.pathSegments.last;
                  final modified = file.statSync().modified;
                  final isSelected = _selectedFiles.contains(file);
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(
                        file,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const CircleAvatar(child: Icon(Icons.image)),
                      ),
                    ),
                    title: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('Creado: ${_prettyDate(modified)}'),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedFiles.add(file);
                          } else {
                            _selectedFiles.remove(file);
                          }
                        });
                      },
                    ),
                    onTap: () => _openPreview(file),
                  );
                },
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        label: const Text('Volver'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
