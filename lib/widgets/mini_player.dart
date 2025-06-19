import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../screens/full_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const MiniPlayer({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context) {
    final song = MockData.currentlyPlaying;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPlayerScreen(song: song),
          ),
        );
      },
      child: Center(
        child: Container(
          height: 60,
          width: screenWidth*0.92,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 71, 67, 67),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 30, 24, 24).withOpacity(0.5),
                blurRadius: 12,
                spreadRadius:2,
                offset: const Offset(0,6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Album Art
              Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(20),
                  //   bottomLeft: Radius.circular(20),
                  // ),
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    song.albumArt,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Song Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
              ),
              
              // Play/Pause Button
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: const Color.fromARGB(255, 230, 173, 5),
                  size: 32,
                ),
                onPressed: onPlayPause,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
