import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/controller/bottom_nav_controller.dart';
import 'package:latres/screen/favorite.dart';
import 'package:latres/screen/detail_page.dart'; // Tambahkan import
import '../service/api_service.dart';
import '../model/amiibo_model.dart';
import '../model/favorite_amiibo.dart'; // Tambahkan import

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final BottomNavController _navController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildAmiiboList(),
      const FavoritePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nintendo Amiibo List'),
      ),
      body: Obx(() => pages[_navController.index.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _navController.index.value,
          onTap: _navController.changeIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmiiboList() {
    return FutureBuilder<List<Amiibo>>(
      future: AmiiboService().fetchAmiiboList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const Center(child: Text('No items found'));
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final amiibo = items[index];
              return ValueListenableBuilder(
                valueListenable: Hive.box<FavoriteAmiibo>('favorites').listenable(),
                builder: (context, Box<FavoriteAmiibo> box, _) {
                  final isFavorite = box.values.any((fav) => fav.name == amiibo.name);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black26,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: SizedBox(
                          width: 56,
                          height: 56,
                          child: Image.network(
                            amiibo.image,
                            fit: BoxFit.cover,
                            
                            errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(amiibo.name.isNotEmpty ? amiibo.name : amiibo.character),
                        subtitle: Text("Game Series : ${amiibo.gameSeries}"),
                        trailing: IconButton(
                          onPressed: () {
                            final box = Hive.box<FavoriteAmiibo>('favorites');
                            if (isFavorite) {
                              box.deleteAt(box.values.toList().indexWhere((fav) => fav.name == amiibo.name));
                            } else {
                              box.add(FavoriteAmiibo.fromAmiibo(amiibo));
                            }
                          },
                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline, color: isFavorite ? Colors.red : null),
                        ),
                        onTap: () {
                          Get.to(() => DetailPage(amiibo: amiibo));
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}