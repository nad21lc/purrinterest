import 'package:flutter/material.dart';
import 'package:purrinterest/ui/home_screen.dart';
import 'package:purrinterest/utils/db_helper.dart';
import 'package:purrinterest/utils/http_helper.dart';
import 'package:purrinterest/models/cat.dart';
import 'package:purrinterest/ui/favorite_list_screen.dart';

class CatListScreen extends StatefulWidget {
  const CatListScreen({super.key});

  @override
  State<CatListScreen> createState() => _CatListScreenState();
}

class _CatListScreenState extends State<CatListScreen> {
  List<Cat> cats = [];
  List<Cat> filteredCats = [];
  late HttpHelper helper;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    helper = HttpHelper(); // Initialize HttpHelper
    _fetchCats(); // Fetch cats from server
    searchController.addListener(_filterCats);
  }

  Future<void> _fetchCats() async {
    try {
      final List<Cat> fetchedCats = await helper.getCats(); // Get cats from the helper
      setState(() {
        cats = fetchedCats; // Update cat list
        filteredCats = fetchedCats; // Initialize filtered cat list
      });
    } catch (e) {
      print('Error fetching cats: $e');
    }
  }

  void _filterCats() {
    setState(() {
      filteredCats = cats.where((cat) {
        return cat.name!.toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cats"),
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
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by breed',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: filteredCats.length,
        itemBuilder: (BuildContext context, int index) {
          return CatGridItem(cat: filteredCats[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pets,
              color: Color(0xFF987D9A),
            ),
            label: 'Show Cats',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Color(0xFFBB9AB1),
            ),
            label: 'Favorites',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FavoriteListScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}

class CatGridItem extends StatefulWidget {
  final Cat cat;
  CatGridItem({required this.cat});

  @override
  State<CatGridItem> createState() => _CatGridItemState();
}

class _CatGridItemState extends State<CatGridItem> {
  bool favorite = false; // Favorite status
  late DbHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper(); // Initialize DbHelper
    _isFavorite(); // Check if it is favorite
  }

  Future<void> _isFavorite() async {
    await dbHelper.openDb(); // Open database
    favorite = await dbHelper.isFavorite(widget.cat); // Verify if it is favorite
    setState(() {}); // Update favorite status
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                widget.cat.referenceImageId ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cat.name ?? 'Unknown Cat',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF987D9A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Origin: ${widget.cat.origin ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF987070),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: favorite ? Color(0xFFBB9AB1) : Color(0xFFFFE6E6),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: IconButton(
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.white : Color(0xFFBB9AB1),
              ),
              onPressed: () {
                setState(() {
                  favorite = !favorite; // Toggle favorite status
                });
                if (favorite) {
                  dbHelper.insertCat(widget.cat); // Add to favorites
                } else {
                  dbHelper.deleteCat(widget.cat); // Remove from favorites
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
