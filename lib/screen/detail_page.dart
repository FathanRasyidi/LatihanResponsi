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
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Theme.of(context).colorScheme.secondary : null,
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
              child: Hero(
                tag: 'amiibo-${amiibo.head}-${amiibo.tail}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      amiibo.image,
                      fit: BoxFit.fitHeight,
                      errorBuilder: (c, e, s) => Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amiibo.name.isNotEmpty ? amiibo.name : amiibo.character,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Character', amiibo.character),
                    _buildInfoRow('Game Series', amiibo.gameSeries),
                    _buildInfoRow('Amiibo Series', amiibo.amiiboSeries),
                    _buildInfoRow('Type', amiibo.type),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technical Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Head ID', amiibo.head),
                    _buildInfoRow('Tail ID', amiibo.tail),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Release Dates',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildReleaseWidgets(amiibo.release),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReleaseWidgets(dynamic releaseData) {
    final List<Widget> widgets = [];
    if (releaseData == null) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'No release info available',
            style: TextStyle(color: Color(0xFF666666)),
          ),
        ),
      );
      return widgets;
    }

    Map<String, dynamic> map;
    if (releaseData is Map<String, dynamic>) {
      map = releaseData;
    } else {
      widgets.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Release info format not supported',
            style: TextStyle(color: Color(0xFF666666)),
          ),
        ),
      );
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
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  region,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (widgets.isEmpty) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'No release info available',
            style: TextStyle(color: Color(0xFF666666)),
          ),
        ),
      );
    }

    return widgets;
  }
}
