import 'package:hive/hive.dart';
import 'amiibo_model.dart';

part 'favorite_amiibo.g.dart';

@HiveType(typeId: 0)
class FavoriteAmiibo extends HiveObject {
  @HiveField(0)
  final String amiiboSeries;

  @HiveField(1)
  final String character;

  @HiveField(2)
  final String gameSeries;

  @HiveField(3)
  final String head;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final String name;

  @HiveField(6)
  final String release;

  @HiveField(7)
  final String tail;

  @HiveField(8)
  final String type;

  FavoriteAmiibo({
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.head,
    required this.image,
    required this.name,
    required this.release,
    required this.tail,
    required this.type,
  });

  factory FavoriteAmiibo.fromAmiibo(Amiibo amiibo) {
    return FavoriteAmiibo(
      amiiboSeries: amiibo.amiiboSeries,
      character: amiibo.character,
      gameSeries: amiibo.gameSeries,
      head: amiibo.head,
      image: amiibo.image,
      name: amiibo.name,
      release: amiibo.release.toString(),
      tail: amiibo.tail,
      type: amiibo.type,
    );
  }
}