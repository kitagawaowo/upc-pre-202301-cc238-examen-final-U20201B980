import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/local/db_anime.dart';
import '../../data/models/anime.dart';
import '../../data/services/http_anime.dart';

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
        title: const Text('AppSuperZound'),
      ),
      body: ListView.builder(
          itemCount: animes?.length,
          itemBuilder: (context, index) {
            return AnimeItem(anime: animes![index]);
          }),
    );
  }
}

class AnimeItem extends StatefulWidget {
  const AnimeItem({super.key, required this.anime});
  final Anime anime;

  @override
  State<AnimeItem> createState() => _AnimeItemState();
}

class _AnimeItemState extends State<AnimeItem> {
  bool isFavorite = false;
  DbHelper? dbHelper;

  @override
  void initState() {
    dbHelper = DbHelper();
    isFavoriteAnime();
    super.initState();
  }

  isFavoriteAnime() async {
    await dbHelper?.openDb();
    final result = await dbHelper?.isFavorite(widget.anime);
    setState(() {
      isFavorite = result!;
    });
  }
  addToSharedPreferences(int episodes, int members) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalEpisodes = (prefs.getInt('totalEpisodes') ?? 0) + episodes;
    int totalMembers = (prefs.getInt('totalMembers') ?? 0) + members;
    await prefs.setInt('totalEpisodes', totalEpisodes);
    await prefs.setInt('totalMembers', totalMembers);
  }

  removeFromSharedPreferences(int episodes, int members) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalEpisodes = (prefs.getInt('totalEpisodes') ?? 0) - episodes;
    int totalMembers = (prefs.getInt('totalMembers') ?? 0) - members;
    await prefs.setInt('totalEpisodes', totalEpisodes);
    await prefs.setInt('totalMembers', totalMembers);
  }

  addAnime() {
    addToSharedPreferences(int.parse(widget.anime.episodes), int.parse(widget.anime.members));
    dbHelper?.insert(widget.anime);
  }
  removeAnime() {
    removeFromSharedPreferences(int.parse(widget.anime.episodes), int.parse(widget.anime.members));
    dbHelper?.delete(widget.anime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.anime.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.anime.year),
          ],
        ),
        leading: Hero(
            tag: widget.anime.id,
            child: Image(image: NetworkImage(widget.anime.image))),
        trailing: IconButton(
          onPressed: () {
            isFavorite
                ? removeAnime()
                : addAnime();
            setState(() {
              isFavorite = !isFavorite;
            });
          },
          icon: Icon(
            Icons.favorite,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }
}
