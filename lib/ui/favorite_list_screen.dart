import 'package:flutter/material.dart';
import 'package:purrinterest/models/cat.dart';
import 'package:purrinterest/utils/db_helper.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cats'),
      ),
    );
  }
}
