import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/controller/bottom_nav_controller.dart';
import 'package:latres/screen/favorite.dart';
import 'package:latres/screen/detail_page.dart';
import '../service/api_service.dart';
import '../model/amiibo_model.dart';
import '../model/favorite_amiibo.dart'; 

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final BottomNavController _navController = Get.put(BottomNavController());

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Obx(() => Text(_navController.index.value == 0 ? 'Nintendo Amiibo List' : 'Favorite Amiibos')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildAmiiboList(),
      const FavoritePage(),
    ];

    return Scaffold(
      appBar: _buildAppBar(),
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading Amiibo...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load Amiibo',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your connection and try again',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No Amiibo found',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try refreshing or check back later',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            (context as Element).markNeedsBuild();
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final amiibo = items[index];
              return ValueListenableBuilder(
                valueListenable: Hive.box<FavoriteAmiibo>('favorites').listenable(),
                builder: (context, Box<FavoriteAmiibo> box, _) {
                  final isFavorite = box.values.any((fav) => fav.name == amiibo.name);
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Get.to(() => DetailPage(amiibo: amiibo));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'amiibo-${amiibo.head}-${amiibo.tail}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  amiibo.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    amiibo.name.isNotEmpty ? amiibo.name : amiibo.character,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Game Series: ${amiibo.gameSeries}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Type: ${amiibo.type}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                final box = Hive.box<FavoriteAmiibo>('favorites');
                                if (isFavorite) {
                                  box.deleteAt(box.values.toList().indexWhere((fav) => fav.name == amiibo.name));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${amiibo.name} removed from favorites'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  box.add(FavoriteAmiibo.fromAmiibo(amiibo));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${amiibo.name} added to favorites'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Theme.of(context).colorScheme.secondary : Colors.grey,
                              ),
                            ),
                          ],
                        ),
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