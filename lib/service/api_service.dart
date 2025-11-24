import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/amiibo_model.dart';

class AmiiboService {
  static final String _baseUrl = 'https://www.amiiboapi.com/api/amiibo';

  // Function untuk mengambil List Amiibo
  Future<List<Amiibo>> fetchAmiiboList() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        // 1. Decode JSON response body
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // 2. Ambil list yang ada di dalam key 'amiibo'
        final List<dynamic> amiiboList = jsonResponse['amiibo'];
        
        // 3. Mapping dari JSON ke Object Amiibo
        return amiiboList.map((item) => Amiibo.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}