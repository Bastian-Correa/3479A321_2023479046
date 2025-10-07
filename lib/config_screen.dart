import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/configuration_data.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cfg = context
        .watch<ConfigurationData>(); // para estar atento a los cambios

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tamaño del pixel art',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            //Tamaños para el pixel art
            DropdownButtonFormField<int>(
              value: cfg.size, // valor actual del provider
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 16, child: Text('16')),
                DropdownMenuItem(value: 18, child: Text('18')),
                DropdownMenuItem(value: 20, child: Text('20')),
                DropdownMenuItem(value: 24, child: Text('24')),
                DropdownMenuItem(value: 32, child: Text('32')),
              ],
              onChanged: (value) {
                if (value == null) return;
                context.read<ConfigurationData>().setSize(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tamaño actualizado a $value')),
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Paleta principal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: cfg.paletteKey,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'cian', child: Text('Cian')),
                DropdownMenuItem(value: 'magenta', child: Text('Magenta')),
                DropdownMenuItem(value: 'amber', child: Text('Ámbar')),
                DropdownMenuItem(value: 'purple', child: Text('Púrpura')),
              ],
              onChanged: (key) {
                if (key == null) return;
                context.read<ConfigurationData>().setPalette(key);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Paleta actual: $key')));
              },
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Vista previa:'),
                const SizedBox(width: 12),
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: cfg.paletteColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
