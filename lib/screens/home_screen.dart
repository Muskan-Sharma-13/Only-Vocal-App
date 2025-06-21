import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:only_vocal/resources/user_provider.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/genre.dart';
import '../models/song.dart';
import 'genre_detail_screen.dart';
import 'full_player_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  final carouselImages=[
    'assets/carousel/red.png',
    'assets/carousel/red.png',
    'assets/carousel/red.png',
    'assets/carousel/red.png',
    'assets/carousel/red.png'
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    
  if (user == null) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OnlyVocals4U',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: const Color.fromARGB(255, 156, 98, 167),
                          ),
                    ),
                    const Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              // Greeting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${_getGreeting()}, ${user.username}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1E3F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for songs, artists, or albums',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),

              Center(
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    height:200,
                    autoPlay: true,
                    //reverse: true,
                    autoPlayInterval: Duration(seconds:4)
                  ),
                  itemCount:carouselImages.length,
                  itemBuilder: (context,index,realIndex){
                    final carouselImage=carouselImages[index];
                    return buildImage(carouselImage,index);
                  },
                )
                ,
              ),

              SizedBox(height:20),

              // Recently Played Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Recently Played',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.recentlyPlayed.length,
                  itemBuilder: (context, index) {
                    final song = MockData.recentlyPlayed[index];
                    return _buildRecentlyPlayedItem(context, song);
                  },
                ),
              ),

              // Genre Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Browse Genres',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: MockData.genres.length,
                  itemBuilder: (context, index) {
                    final genre = MockData.genres[index];
                    return _buildGenreItem(context, genre);
                  },
                ),
              ),

              // Liked Songs Slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Your Favorites',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.likedSongs.length + 1, // +1 for "See All"
                  itemBuilder: (context, index) {
                    if (index == MockData.likedSongs.length) {
                      return _buildSeeAllItem(context);
                    }
                    final song = MockData.likedSongs[index];
                    return _buildLikedSongItem(context, song);
                  },
                ),
              ),

              // Bottom padding to account for mini player
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(String carouselImage,int index)=>Container(
    margin:EdgeInsets.symmetric(horizontal:12),
    color:Colors.grey,
    child:Image.asset(
      carouselImage,
      fit:BoxFit.cover,
    )
  );

  Widget _buildRecentlyPlayedItem(BuildContext context, Song song) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPlayerScreen(song: song),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                song.albumArt,
                height: 100,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              song.title,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              song.artist,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreItem(BuildContext context, Genre genre) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenreDetailScreen(genre: genre),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              genre.color,
              genre.color.withOpacity(0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    genre.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    genre.icon,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    genre.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikedSongItem(BuildContext context, Song song) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPlayerScreen(song: song),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                song.albumArt,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeAllItem(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1E3F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_forward,
                color: Color(0xFFFFD700),
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
