import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/model/favorite_amiibo.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box<FavoriteAmiibo>('favorites').listenable(),
        builder: (context, Box<FavoriteAmiibo> box, _) {
          final favorites = box.values.toList();
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final fav = favorites[index];
              return Dismissible(
                key: Key(box.keyAt(index).toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                onDismissed: (_) => box.deleteAt(index),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Image.network(fav.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(fav.name),
                    subtitle: Text(fav.gameSeries),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
