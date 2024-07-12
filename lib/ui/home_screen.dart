import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:purrinterest/utils/http_helper.dart';

import 'package:purrinterest/ui/cats_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _imageUrl;
  final HttpHelper _httpHelper = HttpHelper();

  @override
  void initState() {
    super.initState();
    _fetchRandomCatImage();
  }

  Future<void> _fetchRandomCatImage() async {
    try {
      final String imageUrl = await _httpHelper.getRandomCatImage();
      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (e) {
      print('Error fetching cat image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFFBB9AB1),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFEECE2), Color(0xFFEECEB9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageUrl != null)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: NetworkImage(_imageUrl!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        const Color(0xFFFEFBD8).withOpacity(0.2),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                'Purrinterest',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF987D9A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Go to list screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CatListScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFBB9AB1),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.list),
                  label: const Text('Mostrar'),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Go to favorite list
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFBB9AB1),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.favorite),
                  label: const Text('Favoritos'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}