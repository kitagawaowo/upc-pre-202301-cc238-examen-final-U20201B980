import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/anime.dart';

class HttpHelper {
  final String urlBase = 'https://api.jikan.moe/v4/top/anime';


  Future<List<Anime>?> getAnimes() async {
    http.Response response = await http.get(Uri.parse(urlBase));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List animesMap = jsonResponse['data'];
      final List<Anime> animes =
          animesMap.map((map) => Anime.fromJson(map)).toList();
      return animes;
    } else {
      return null;
    }
  }
}
