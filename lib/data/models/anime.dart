class Anime {
  final String id;
  final String title;
  final String image;
  final String year;
  final String members;
  final String episodes;

  Anime({
    required this.id,
    required this.title,
    required this.image,
    required this.year,
    required this.members,
    required this.episodes,
  });

  Anime.fromJson(Map<String, dynamic> json)
      : this(
          id: json['mal_id'].toString(),
          title: json['title'],
          image: json['images']['jpg']['image_url'],
          year: json['year'].toString(),
          members: json['members'].toString(),
          episodes: json['episodes'].toString(),
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'year': year,
      'members': members,
      'episodes': episodes,
    };
  }

  Anime.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'],
          title: map['title'],
          image: map['image'],
          year: map['year'],
          members: map['members'],
          episodes: map['episodes'],
        );
}
