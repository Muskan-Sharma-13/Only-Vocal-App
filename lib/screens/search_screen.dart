import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'full_player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  bool _hasSearched = false;

  List<dynamic> _searchResults = [];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    // Mock search functionality
    final songs = MockData.recentlyPlayed.where((song) {
      return song.title.toLowerCase().contains(query.toLowerCase()) ||
          song.artist.toLowerCase().contains(query.toLowerCase()) ||
          song.album.toLowerCase().contains(query.toLowerCase());
    }).toList();

    final genres = MockData.genres.where((genre) {
      return genre.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _searchResults = [...songs, ...genres];
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1E3F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search for songs, artists, or albums',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                              _performSearch('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _performSearch(value);
                  },
                ),
              ),
            ),

            // Search Results
            Expanded(
              child: _hasSearched
                  ? _searchResults.isEmpty
                      ? _buildNoResultsView()
                      : _buildSearchResultsList()
                  : _buildSearchSuggestionsView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        if (result.runtimeType.toString().contains('Song')) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                result.albumArt,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              result.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              result.artist,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.play_circle_filled,
                    color: Color(0xFFFFD700),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullPlayerScreen(song: result),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    result.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: result.isLiked ? const Color(0xFFFFD700) : Colors.white,
                  ),
                  onPressed: () {
                    // Toggle like status
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullPlayerScreen(song: result),
                ),
              );
            },
          );
        } else {
          // Genre result
          return ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: result.color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                result.icon,
                color: Colors.white,
              ),
            ),
            title: Text(
              result.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              'Genre',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
            ),
            onTap: () {
              // Navigate to genre detail
            },
          );
        }
      },
    );
  }

  Widget _buildNoResultsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white54,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found for "$_searchQuery"',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.5),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestionsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Mock recent searches
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'The Weeknd',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              setState(() {
                _searchQuery = 'The Weeknd';
              });
              _performSearch(_searchQuery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'Pop',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              setState(() {
                _searchQuery = 'Pop';
              });
              _performSearch(_searchQuery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'Dua Lipa',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () {
              setState(() {
                _searchQuery = 'Dua Lipa';
              });
              _performSearch(_searchQuery);
            },
          ),
        ],
      ),
    );
  }
}
