import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  // optional id that can be used to show details or context
  final int? gameId;
  const FavoritePage({super.key, this.gameId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        gameId != null ? 'Favorite Page (id: $gameId)' : 'Favorite Page',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
