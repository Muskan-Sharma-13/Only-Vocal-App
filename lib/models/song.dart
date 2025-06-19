class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String albumArt;
  final String audioURL;
  final bool isLiked;


  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.albumArt,
    required this.audioURL,
    this.isLiked = false,
  });
}
