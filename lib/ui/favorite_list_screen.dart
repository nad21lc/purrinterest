import 'package:flutter/material.dart';
import 'package:purrinterest/models/cat.dart';
import 'package:purrinterest/ui/cats_list_screen.dart';
import 'package:purrinterest/ui/home_screen.dart';
import 'package:purrinterest/utils/db_helper.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  late List<Cat> favoriteCats = [];
  late DbHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    initializeDb();
  }

  Future<void> initializeDb() async {
    await dbHelper.openDb();
    fetchFavorites();
  }

  void fetchFavorites() async {
    List<Cat> cats = await dbHelper.fetchFavorites();
    setState(() {
      favoriteCats = cats;
    });
  }

  void removeFavorite(Cat cat) async {
    await dbHelper.deleteCat(cat);
    fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cats'),
        backgroundColor: const Color(0xFFBB9AB1),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: favoriteCats.isEmpty
          ? const Center(
        child: Text(
          'No favorite cats yet.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: favoriteCats.length,
        itemBuilder: (context, index) {
          Cat cat = favoriteCats[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(cat.referenceImageId ?? ''),
                ),
                title: Text(
                  cat.name ?? 'Unknown Cat',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF987D9A),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Temperament: ${cat.temperament ?? 'Unknown'}',
                        style: const TextStyle(
                          color: Color(0xFF987070),
                        )
                    ),
                    Text(
                        'Intelligence: ${cat.intelligence ?? 0}',
                        style: const TextStyle(
                          color: Color(0xFF987070),
                        )
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
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    removeFavorite(cat);
                  },
                  color: const Color(0xFFEECEB9),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pets,
              color: Color(0xFFBB9AB1),
            ),
            label: 'Show Cats',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Color(0xFF987D9A),
            ),
            label: 'Favorites',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CatListScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}
