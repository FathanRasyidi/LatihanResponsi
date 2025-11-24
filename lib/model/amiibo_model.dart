class Amiibo {
  final String amiiboSeries;
  final String character;
  final String gameSeries;
  final String head;
  final String tail;
  final String image;
  final String name;
  final Map<String, dynamic> release;
  final String type;

  Amiibo({
    required this.amiiboSeries,
    required this.character,
    required this.gameSeries,
    required this.head,
    required this.tail,
    required this.image,
    required this.name,
    required this.release,
    required this.type,
  });

  // Factory method untuk mengubah JSON Map menjadi Object Amiibo
  factory Amiibo.fromJson(Map<String, dynamic> json) {
    return Amiibo(
      amiiboSeries: json['amiiboSeries'] ?? '',
      character: json['character'] ?? '',
      gameSeries: json['gameSeries'] ?? '',
      head: json['head'] ?? '',
      tail: json['tail'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      release: json['release'] ?? '',
      type: json['type'] ?? '',
    );
  }
}