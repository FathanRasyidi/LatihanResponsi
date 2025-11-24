import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres/model/amiibo_model.dart';
import 'package:latres/model/favorite_amiibo.dart';

class DetailPage extends StatelessWidget {
  final Amiibo amiibo;

  const DetailPage({super.key, required this.amiibo});

  @override
  Widget build(BuildContext context) {
  final favoritesBox = Hive.box<FavoriteAmiibo>('favorites');

    return Scaffold(
      appBar: AppBar(
        title: Text(amiibo.name.isNotEmpty ? amiibo.name : amiibo.character),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          ValueListenableBuilder(
            valueListenable: favoritesBox.listenable(),
            builder: (context, Box<FavoriteAmiibo> box, _) {
              final isFav = box.values.any((fav) => fav.name == amiibo.name);
              return IconButton(
                onPressed: () {
                  if (isFav) {
                    final idx = box.values.toList().indexWhere((fav) => fav.name == amiibo.name);
                    if (idx >= 0) box.deleteAt(idx);
                  } else {
                    box.add(FavoriteAmiibo.fromAmiibo(amiibo));
                  }
                },
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.black,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  amiibo.image,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              amiibo.name.isNotEmpty ? amiibo.name : amiibo.character,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Character:', style: const TextStyle(fontSize: 16)),
                Text('${amiibo.character}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('Game Series:', style: TextStyle(fontSize: 16)),
              Text('${amiibo.gameSeries}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('Amiibo Series:', style: TextStyle(fontSize: 16)),
              Text('${amiibo.amiiboSeries}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('Type:', style: TextStyle(fontSize: 16)),
              Text('${amiibo.type}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('Head:', style: TextStyle(fontSize: 16)),
              Text('${amiibo.head}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('Tail:', style: TextStyle(fontSize: 16)),
              Text('${amiibo.tail}', style: const TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            const Text('Release Dates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            // Show release map as list (ordered)
            ..._buildReleaseWidgets(amiibo.release),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReleaseWidgets(dynamic releaseData) {
    final List<Widget> widgets = [];
    if (releaseData == null) {
      widgets.add(const Text('No release info', style: TextStyle(color: Colors.black54)));
      return widgets;
    }

    Map<String, dynamic> map;
    if (releaseData is Map<String, dynamic>) {
      map = releaseData;
    } else {
      // fallback: show raw
      widgets.add(Text(releaseData.toString(), style: const TextStyle(color: Colors.black54)));
      return widgets;
    }

    final order = ['au', 'eu', 'jp', 'na'];
    for (final key in order) {
      if (map.containsKey(key)) {
        final region = switch (key) {
          'au' => 'Australia',
          'eu' => 'Europe',
          'jp' => 'Japan',
          'na' => 'North America',
          _ => key,
        };
        final date = (map[key] ?? '').toString();
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(region, style: const TextStyle(color: Colors.black87)),
              Text(date, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ));
      }
    }

    if (widgets.isEmpty) {
      widgets.add(const Text('No release info', style: TextStyle(color: Colors.black54)));
    }

    return widgets;
  }
}
