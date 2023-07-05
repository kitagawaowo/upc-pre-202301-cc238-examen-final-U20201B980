import 'package:flutter/material.dart';
import '../../data/models/anime.dart';
import '../../data/services/http_anime.dart';
import '../widgets/anime_widget.dart';

class AnimeList extends StatefulWidget {
  const AnimeList({super.key});

  @override
  State<AnimeList> createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  List<Anime>? animes;
  HttpHelper? httpHelper;

  Future initialize() async {
    animes = List.empty();
    animes = await httpHelper?.getAnimes();
    setState(() {
      animes = animes;
    });
  }

  @override
  void initState() {
    httpHelper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime List'),
      ),
      body: ListView.builder(
          itemCount: animes?.length,
          itemBuilder: (context, index) {
            return AnimeItem(anime: animes![index], isFavoriteScreen: false);
          }),
    );
  }
}
