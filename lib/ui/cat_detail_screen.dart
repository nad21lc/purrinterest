import 'package:flutter/material.dart';
import 'package:purrinterest/models/cat.dart';

class CatDetailScreen extends StatelessWidget {
  final Cat cat;

  const CatDetailScreen({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat.name ?? 'Unknown Cat'),
        backgroundColor: const Color(0xFFBB9AB1),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              cat.referenceImageId ?? '',
              fit: BoxFit.cover,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${cat.name ?? 'Unknown Cat'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF987D9A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Origin: ${cat.origin ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF987070),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Decription: ${cat.description ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF987070),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Temperament: ${cat.temperament ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF987070),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Energy Level: ${cat.energyLevel ?? 0}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF987070),
                    ),
                  ),
                  Slider(
                    value: (cat.energyLevel ?? 0).toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: cat.energyLevel?.toString() ?? '0',
                    onChanged: null, // Disabled
                  ),
                  Text(
                    'Intelligence: ${cat.intelligence ?? 0}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF987070),
                    ),
                  ),
                  Slider(
                    value: (cat.intelligence ?? 0).toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: cat.intelligence?.toString() ?? '0',
                    onChanged: null, // Disabled
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
