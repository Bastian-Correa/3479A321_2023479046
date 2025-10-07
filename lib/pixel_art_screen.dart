import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/configuration_data.dart';

class PixelArtScreen extends StatefulWidget {
  final int parentCounter;
  const PixelArtScreen({super.key, required this.parentCounter});

  @override
  State<PixelArtScreen> createState() => _PixelArtScreenState();
}

class _PixelArtScreenState extends State<PixelArtScreen> {
  int _sizeGrid = 0; // el tamaño

  @override
  void initState() {
    super.initState();
    debugPrint('[PixelArt] initState');
    _sizeGrid = context.read<ConfigurationData>().size;
    debugPrint('[PixelArt] sizeGrid (init): $_sizeGrid');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('[PixelArt] didChangeDependencies');
  }

  @override
  void setState(VoidCallback fn) {
    debugPrint('[PixelArt] setState() called');
    super.setState(fn);
  }

  @override
  void didUpdateWidget(covariant PixelArtScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint(
      '[PixelArt] didUpdateWidget: parentCounter ${oldWidget.parentCounter} -> ${widget.parentCounter}',
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    debugPrint('[PixelArt] reassemble (hot reload)');
  }

  @override
  void deactivate() {
    debugPrint('[PixelArt] deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('[PixelArt] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[PixelArt] build()');

    return Scaffold(
      appBar: AppBar(title: const Text('Pixel Art')),
      body: Center(child: Text('Tamaño por defecto del pixel art: $_sizeGrid')),
    );
  }
}
