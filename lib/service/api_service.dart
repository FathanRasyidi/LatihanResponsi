import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/amiibo_model.dart';

class AmiiboService {
  static final String _baseUrl = 'https://www.amiiboapi.com/api/amiibo';

  Future<List<Amiibo>> fetchAmiiboList() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> amiiboList = jsonResponse['amiibo'];
        return amiiboList.map((item) => Amiibo.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}