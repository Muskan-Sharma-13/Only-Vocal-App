import 'package:flutter/material.dart';
import '../models/song.dart';
import '../models/genre.dart';

class MockData {
  static List<Song> recentlyPlayed = [
  Song(
    id: '1',
    title: 'Levitating',
    artist: 'Dua Lipa',
    album: 'Future Nostalgia',
    albumArt: 'assets/thumbnails/levitating.jpeg',
    audioURL: 'audio/levitating.mp3',
    isLiked: true,
  ),
  Song(
    id: '2',
    title: 'As It Was',
    artist: 'Harry Styles',
    album: 'Harry’s House',
    albumArt: 'assets/thumbnails/as_it_was.jpeg',
    audioURL: 'audio/as_it_was.mp3',
  ),
  Song(
    id: '3',
    title: 'Shake It Off',
    artist: 'Taylor Swift',
    album: '1989',
    albumArt: 'assets/thumbnails/shake_it_off.jpeg',
    audioURL: 'audio/levitating.mp3',
  ),
  Song(
    id: '4',
    title: 'SICKO MODE',
    artist: 'Travis Scott',
    album: 'ASTROWORLD',
    albumArt: 'assets/thumbnails/sicko_mode.jpeg',
    audioURL: 'audio/sicko.mp3',
    isLiked: true,
  ),
  Song(
    id: '5',
    title: 'Lose Yourself',
    artist: 'Eminem',
    album: '8 Mile',
    albumArt: 'assets/thumbnails/lose_yourself.jpeg',
    audioURL: 'audio/levitating.mp3',
    isLiked: true,
  ),
  Song(
    id: '6',
    title: 'HUMBLE.',
    artist: 'Kendrick Lamar',
    album: 'DAMN.',
    albumArt: 'assets/thumbnails/humble.jpeg',
    audioURL: 'audio/levitating.mp3',
  ),
  Song(
    id: '7',
    title: 'Summertime',
    artist: 'Ella Fitzgerald & Louis Armstrong',
    album: 'Porgy and Bess',
    albumArt: 'assets/thumbnails/summertime.jpeg',
    audioURL: 'audio/summertime.mp3',
    isLiked: true,
  ),
  Song(
    id: '8',
    title: 'My Favourite Things',
    artist: 'John Coltrane',
    album: 'My Favorite Things',
    albumArt: 'assets/thumbnails/my_favourite.jpeg',
    audioURL: 'audio/levitating.mp3',

  ),
  Song(
    id: '9',
    title: 'So What',
    artist: 'Miles Davis',
    album: 'Kind of Blue',
    albumArt: 'assets/thumbnails/so_what.jpeg',
    audioURL: 'audio/levitating.mp3',

  ),
  Song(
    id: '10',
    title: 'Bohemian Rhapsody',
    artist: 'Queen',
    album: 'A Night at the Opera',
    albumArt: 'assets/thumbnails/bohemian.jpeg',
    audioURL: 'audio/bohemian.mp3',
    isLiked: true,
  ),
  Song(
    id: '11',
    title: 'In The End',
    artist: 'Linkin Park',
    album: 'Hybrid Theory',
    albumArt: 'assets/thumbnails/in_the_end.jpeg',
    audioURL: 'audio/levitating.mp3',
  ),
  Song(
    id: '12',
    title: 'Back In Black',
    artist: 'AC/DC',
    album: 'Back In Black',
    albumArt: 'assets/thumbnails/back_in_black.jpeg',
    audioURL: 'audio/levitating.mp3',
  ),
];

static List<Song> likedSongs = [
  recentlyPlayed[0],  // Levitating
  recentlyPlayed[3],  // SICKO MODE
  recentlyPlayed[4],  // Lose Yourself
  recentlyPlayed[6],  // Summertime
  recentlyPlayed[9],  // Bohemian Rhapsody
];


  static List<Genre> genres = [
    Genre(
      id: 'pop',
      name: 'Pop',
      color: const Color.fromRGBO(115, 30, 233, 1),
      icon: Icons.music_note,
      imageUrl: 'assets/genres/pop.png',
    ),
    Genre(
      id: 'rock',
      name: 'Rock',
      color: Colors.red,
      icon: Icons.music_note,
      imageUrl: 'assets/genres/rock.png',
    ),
    Genre(
      id: 'hiphop',
      name: 'Hip-Hop',
      color: Colors.purple,
      icon: Icons.headphones,
      imageUrl: 'assets/genres/hiphop.jpeg',
    ),
    Genre(
      id: 'electronic',
      name: 'Electronic',
      color: Colors.cyan,
      icon: Icons.electric_bolt,
      imageUrl: 'assets/genres/electronic.jpeg',
    ),
    Genre(
      id: 'rnb',
      name: 'R&B',
      color: Colors.blue,
      icon: Icons.piano,
      imageUrl: 'assets/genres/rb.jpeg',
    ),
    Genre(
      id: 'country',
      name: 'Country',
      color: Colors.orange,
      icon: Icons.agriculture,
      imageUrl: 'assets/genres/country.jpeg',
    ),
    Genre(
      id: 'jazz',
      name: 'Jazz',
      color: Colors.amber,
      icon: Icons.music_note,
      imageUrl: 'assets/genres/jazz.jpeg',
    ),
    // Genre(
    //   id: 'classical',
    //   name: 'Classical',
    //   color: Colors.grey,
    //   icon: Icons.piano,
    //   imageUrl: 'https://via.placeholder.com/300/C0C0C0/000000?text=Classical',
    // ),
    Genre(
      id: 'rap',
      name: 'Rap',
      color: Colors.green,
      icon: Icons.album,
      imageUrl: 'assets/genres/rap.png',
    ),
    // Genre(
    //   id: 'metal',
    //   name: 'Metal',
    //   color: Colors.grey.shade800,
    //   icon: Icons.music_note,
    //   imageUrl: 'https://via.placeholder.com/300/333333/FFFFFF?text=Metal',
    // ),
  ];

  static List<Song> genreSongs(String genreId) {
    // Return a list of songs for a specific genre
    return List.generate(
      20,
      (index) => Song(
        id: '$genreId-$index',
        title: 'Song ${index + 1}',
        artist: 'Artist ${index % 5 + 1}',
        album: 'Album ${index % 3 + 1}',
        // albumArt: 'https://via.placeholder.com/300/1A1E3F/FFFFFF?text=Song+${index + 1}',
        albumArt: 'assets/images/song.jpeg',
        audioURL: 'audio/levitating.mp3',
        isLiked: index % 3 == 0,
      ),
    );
  }

  static Song currentlyPlaying = Song(
    id: '9',
    title: 'So What',
    artist: 'Miles Davis',
    album: 'Kind of Blue',
    albumArt: 'assets/thumbnails/so_what.jpeg',
    audioURL: 'audio/levitating.mp3',
  );
}
