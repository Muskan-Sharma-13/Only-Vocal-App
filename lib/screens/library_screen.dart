import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'full_player_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Library',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFFD700),
          labelColor: const Color(0xFFFFD700),
          unselectedLabelColor: Colors.white,
          tabs: const [
            Tab(text: 'Playlists'),
            Tab(text: 'Artists'),
            Tab(text: 'Albums'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlaylistsTab(),
          _buildArtistsTab(),
          _buildAlbumsTab(),
        ],
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    // Mock playlists
    final playlists = [
      {
        'name': 'Liked Songs',
        'count': MockData.likedSongs.length,
        'image': 'assets/images/playlist.jpeg',
      },
      {
        'name': 'Workout Mix',
        'count': 25,
        'image': 'assets/images/playlist.jpeg',
      },
      {
        'name': 'Chill Vibes',
        'count': 42,
        'image': 'assets/images/playlist.jpeg',
      },
      {
        'name': 'Road Trip',
        'count': 18,
        'image': 'assets/images/playlist.jpeg',
      },
      {
        'name': 'Party Anthems',
        'count': 30,
        'image': 'assets/images/playlist.jpeg',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              playlist['image'] as String,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            playlist['name'] as String,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            '${playlist['count']} songs',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
          ),
          trailing: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onTap: () {
            // Navigate to playlist detail
          },
        );
      },
    );
  }

  Widget _buildArtistsTab() {
    // Extract unique artists from mock data
    final artistNames = MockData.recentlyPlayed.map((song) => song.artist).toSet().toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: artistNames.length,
      itemBuilder: (context, index) {
        final artistName = artistNames[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/300/1A1E3F/FFFFFF?text=${artistName.split(' ')[0]}',
            ),
          ),
          title: Text(
            artistName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            'Artist',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
          ),
          onTap: () {
            // Navigate to artist detail
          },
        );
      },
    );
  }

  Widget _buildAlbumsTab() {
    // Extract unique albums from mock data
    final albums = MockData.recentlyPlayed.map((song) => {
      'name': song.album,
      'artist': song.artist,
      'image': song.albumArt,
    }).toSet().toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              album['image'] as String,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            album['name'] as String,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            album['artist'] as String,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
          ),
          onTap: () {
            // Navigate to album detail
          },
        );
      },
    );
  }
}
