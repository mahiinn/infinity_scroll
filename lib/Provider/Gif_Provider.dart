import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gifs/Models/model_gifs.dart';

class GifProvider {
  final url =
      "https://api.giphy.com/v1/gifs/trending?api_key=081Z33Gf8OaNbdK1upYCzUqPGG90MimV&limit=10&rating=g";

  Future<List<ModelGifs>> getGifs() async {
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      String body = utf8.decode(resp.bodyBytes);
      final jsonData = jsonDecode(body);
      final gifs = Gifs.fromJsonList(jsonData);
      return gifs.items;
    } else {
      throw Exception("Ocurrio Algo ${resp.statusCode}");
    }
  }

  Future<List<ModelGifs>> getMoreGifs(int offset) async {
    final nextPageUrl =
        "https://api.giphy.com/v1/gifs/trending?api_key=081Z33Gf8OaNbdK1upYCzUqPGG90MimV&limit=10&rating=g&offset=$offset";

    final resp = await http.get(Uri.parse(nextPageUrl));
    if (resp.statusCode == 200) {
      String body = utf8.decode(resp.bodyBytes);
      final jsonData = jsonDecode(body);
      final gifs = Gifs.fromJsonList(jsonData);
      return gifs.items;
    } else {
      throw Exception("Ocurrio Algo ${resp.statusCode}");
    }
  }
}
