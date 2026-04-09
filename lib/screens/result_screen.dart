import 'dart:io';
import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/gbif_service.dart';
import 'history_screen.dart';
import 'plant_map_screen.dart';

class ResultScreen extends StatefulWidget {
  final Plant plant;
  final File photo;
  final String identificationId;

  const ResultScreen({
    super.key,
    required this.plant,
    required this.photo,
    required this.identificationId,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _occurrenceCount = 0;
  bool _isLoadingCount = true;
  @override
  void initState() {
    super.initState();
    _loadOccurrenceCount(); // Call this when screen loads
  }

  Future<void> _loadOccurrenceCount() async {
    final count =
        await GBIFService.getOccurrenceCount(widget.plant.scientificName);
    setState(() {
      _occurrenceCount = count;
      _isLoadingCount = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Résultat'),
          centerTitle: true,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          // Add this button where you display the plant info
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlantMapScreen(
                      plantName: widget.plant.name,
                      scientificName: widget.plant.scientificName,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.public, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _isLoadingCount ? '...' : '$_occurrenceCount',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(widget.photo,
                    height: 250, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.eco, color: Colors.green, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.plant.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.plant.scientificName.isNotEmpty)
                                Text(
                                  widget.plant.scientificName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    if (widget.plant.family.isNotEmpty)
                      _infoRow(Icons.category, 'Famille', widget.plant.family),
                    if (widget.plant.localName != null)
                      _infoRow(
                          Icons.language, 'Nom local', widget.plant.localName!),
                    _infoRow(
                      Icons.analytics,
                      'Confiance',
                      '${(widget.plant.confidence * 100).toStringAsFixed(1)}%',
                    ),
                    _infoRow(
                      Icons.fingerprint,
                      'ID',
                      widget.identificationId.substring(0, 8),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Nouvelle photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HistoryScreen()),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Voir historique'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
