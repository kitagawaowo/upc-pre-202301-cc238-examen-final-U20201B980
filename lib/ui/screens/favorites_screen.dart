import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/local/db_anime.dart';
import '../../data/models/anime.dart';
import '../widgets/anime_widget.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({super.key});

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  DbHelper? dbHelper;
  List<Anime>? animes;

  loadAnimes() async {
    await dbHelper?.openDb();
    final result = await dbHelper?.fetchAll();
    setState(() {
      animes = result;
    });
  }

  showSummaryDialog(String totalEpisodes, String totalMembers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Total Episodes and Members'),
          content: Text(
            'Total Episodes: $totalEpisodes\nTotal Members: $totalMembers',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalEpisodes = prefs.getInt('totalEpisodes') ?? 0;
    int totalMembers = prefs.getInt('totalMembers') ?? 0;
    showSummaryDialog(totalEpisodes.toString(), totalMembers.toString());
  }

  @override
  void initState() {
    animes = List.empty();
    dbHelper = DbHelper();
    loadAnimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite List'),
      ),
      body: ListView.builder(
        itemCount: animes?.length,
        itemBuilder: (context, index) {
          return AnimeItem(anime: animes![index], isFavoriteScreen: true);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showSharedPreferences();
        },
        label: const Text('Summary'),
        icon: const Icon(Icons.info),
      ),
    );
  }
}
