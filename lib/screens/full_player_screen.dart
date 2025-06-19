import 'package:only_vocal/data/mock_data.dart';
import 'package:flutter/material.dart';
import '../models/song.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:phone_state/phone_state.dart';

class FullPlayerScreen extends StatefulWidget {
  final Song song;

  const FullPlayerScreen({super.key, required this.song});

  @override
  State<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends State<FullPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLiked = false;
  bool _isShuffleEnabled = false;
  int _repeatMode = 0; // 0: off, 1: repeat all, 2: repeat one
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  late Song _currentSong;
  // double sliderValue = currentPosition.inSeconds.toDouble();
  // double maxDuration = totalDuration.inSeconds.toDouble();

  // // Avoid invalid range
  // maxDuration = maxDuration == 0 ? 1.0 : maxDuration;

  // // Clamp the value to be within range
  // sliderValue = sliderValue.clamp(0.0, maxDuration);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudio();
    //_handlePhoneState();
    _currentSong=widget.song;
  }

    void _setupAudio() async {
      await _audioPlayer.setSource(AssetSource(widget.song.audioURL));
      // await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      _audioPlayer.onDurationChanged.listen((duration) {
          if (!mounted) return;
        setState(() {
          totalDuration = duration;
        });
      });

      _audioPlayer.onPositionChanged.listen((position) {
        if (!mounted) return;
        setState(() {
          currentPosition = position;
        });
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        if (!mounted) return;
          setState(() {
            _isPlaying = false;
            if (_repeatMode == 2) {
              _playAudio(); // Repeat one
            } else if (_repeatMode == 1) {
              _playNext(); // Repeat all
            }
          });
      });

      _audioPlayer.onDurationChanged.first.then((_) => _playAudio());
    }

  

    // void _handlePhoneState() {
    //   PhoneState.phoneStateStream.listen((event) {
    //     if (event == PhoneStateStatus.CALL_INCOMING ||
    //         event == PhoneStateStatus.CALL_STARTED) {
    //       _audioPlayer.pause();
    //     } else if (event == PhoneStateStatus.CALL_ENDED) {
    //       _audioPlayer.resume();
    //     }
    //   });
    // }

    Future<void> _playAudio() async {
    await _audioPlayer.resume();
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

Future<void> _switchSong(Song newSong) async {
  await _audioPlayer.stop();
  await _audioPlayer.setSource(AssetSource(newSong.audioURL));
  setState(() {
    _currentSong = newSong;
    currentPosition = Duration.zero;
    totalDuration = Duration.zero;
  });
  _playAudio();
}


  void _playNext() {
      int currentIndex = MockData.recentlyPlayed.indexWhere((song) => song.id == _currentSong.id);
      int nextIndex = (currentIndex + 1) % MockData.recentlyPlayed.length;
      _switchSong(MockData.recentlyPlayed[nextIndex]);
  }

  void _playPrevious() {
    int currentIndex = MockData.recentlyPlayed.indexWhere((song) => song.id == _currentSong.id);
    int prevIndex = (currentIndex - 1 + MockData.recentlyPlayed.length) % MockData.recentlyPlayed.length;
    _switchSong(MockData.recentlyPlayed[prevIndex]);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    final double currentSliderValue = currentPosition.inSeconds.toDouble();
    final double durationSliderMax = totalDuration.inSeconds > 0 ? totalDuration.inSeconds.toDouble() : 1.0;

    return Scaffold(
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Now Playing',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // Show options menu
                      },
                    ),
                  ],
                ),
              ),

              // Album Art
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
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
                          _currentSong.albumArt,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Song Information
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentSong.title,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currentSong.artist,
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
                            color: _isLiked ? const Color.fromARGB(255, 230, 173, 5) : Colors.white,
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

                    // Progress Bar
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                            activeTrackColor: const Color.fromARGB(255, 230, 173, 5),
                            inactiveTrackColor: Colors.white.withOpacity(0.2),
                            thumbColor: const Color.fromARGB(255, 230, 173, 5),
                            overlayColor: const Color.fromARGB(255, 230, 173, 5).withOpacity(0.2),
                          ),
                          
                          child: Slider(

                            min: 0,
                            max: durationSliderMax,
                            value: currentSliderValue.clamp(0.0, durationSliderMax),
                            onChanged: (value) {
                              _audioPlayer.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                              ),
                              Text(
                                "${totalDuration.inMinutes}:${(totalDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Control Buttons
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isShuffleEnabled ? Icons.shuffle : Icons.shuffle,
                            color: _isShuffleEnabled ? const Color.fromARGB(255, 230, 173, 5) : Colors.white.withOpacity(0.7),
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              _isShuffleEnabled = !_isShuffleEnabled;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 36,
                          ),
                          onPressed: _playPrevious,
                        ),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: const Color.fromARGB(255, 230, 173, 5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.black,
                              size: 36,
                            ),
                            onPressed: () {
                              _isPlaying ? _pauseAudio() : _playAudio();
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 36,
                          ),
                          onPressed: _playNext,
                        ),
                        IconButton(
                          icon: Icon(
                            _repeatMode == 0
                                ? Icons.repeat
                                : _repeatMode == 1
                                    ? Icons.repeat
                                    : Icons.repeat_one,
                            color: _repeatMode == 0 ? Colors.white.withOpacity(0.7) : const Color.fromARGB(255, 230, 173, 5),
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              _repeatMode = (_repeatMode + 1) % 3;
                            });
                          },
                        ),
                      ],
                    ),

                    // Additional Actions
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          context,
                          Icons.playlist_add,
                          'Add to playlist',
                          () {
                            // Add to playlist
                          },
                        ),
                        _buildActionButton(
                          context,
                          Icons.share,
                          'Share',
                          () {
                            // Share song
                          },
                        ),
                        _buildActionButton(
                          context,
                          Icons.lyrics,
                          'Lyrics',
                          () {
                            // Show lyrics
                          },
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
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
