import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/local/db_anime.dart';
import '../../data/models/anime.dart';

class AnimeItem extends StatefulWidget {

  const AnimeItem({super.key, required this.anime, this.isFavoriteScreen = false});
  final Anime anime;
  final bool isFavoriteScreen;

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
            widget.isFavoriteScreen
                ? Icons.delete
                : Icons.add_circle,
            color: isFavorite ? const Color.fromARGB(255, 227, 30, 217) : Colors.grey,
          ),
        ),
      ),
    );
  }
}
