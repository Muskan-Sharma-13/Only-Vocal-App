
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:only_vocal/models/song.dart';

class MusicAppScreen extends StatefulWidget {
  final Song song;
  const MusicAppScreen({super.key, required this.song});

  @override
  _MusicAppScreenState createState() => _MusicAppScreenState();
}

class _MusicAppScreenState extends State<MusicAppScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late bool _isLiked;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _isLiked = false;
    _audioPlayer.onPositionChanged.listen((Duration p) {
      if (!mounted) return;
      setState(() => currentPosition = p);
    });

    _audioPlayer.onDurationChanged.listen((Duration d) {
      if (!mounted) return;
      setState(() => totalDuration = d);
    });

    playMusic(widget.song);
  }

  Future<void> playMusic(Song song) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(song.audioURL));
    if (!mounted) return;
    setState(() {
      isPlaying = true;
      _isLiked = true;
    });
  }

  void togglePlayback() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    if (!mounted) return;
    setState(() => isPlaying = !isPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // stop on exit
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;

    return WillPopScope(
      onWillPop: () async {
        await _audioPlayer.stop(); // ensure music stops on back
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1A1E3F),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () async {
                          await _audioPlayer.stop();
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Now Playing',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Icon(Icons.more_vert),
                    ],
                  ),
                ),

                // Album Art
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          song.albumArt,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                // Song Info & Controls
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  song.artist,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? const Color(0xFFE6AD05) : Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                _isLiked = !_isLiked;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Slider
                      Column(
                        children: [
                          Slider(
                            min: 0,
                            max: totalDuration.inSeconds.toDouble(),
                            value: currentPosition.inSeconds.clamp(0, totalDuration.inSeconds).toDouble(),
                            onChanged: (value) {
                              _audioPlayer.seek(Duration(seconds: value.toInt()));
                            },
                            activeColor: const Color(0xFFE6AD05),
                            inactiveColor: Colors.white.withOpacity(0.3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatTime(currentPosition),
                                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                              ),
                              Text(
                                _formatTime(totalDuration),
                                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Playback Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous, size: 36),
                            color: Colors.white,
                            onPressed: () {}, // Add functionality if needed
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE6AD05),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 36,
                                color: Colors.black,
                              ),
                              onPressed: togglePlayback,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next, size: 36),
                            color: Colors.white,
                            onPressed: () {}, // Add functionality if needed
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
