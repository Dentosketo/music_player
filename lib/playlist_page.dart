import 'dart:math' as math;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/player_page.dart';
import 'package:music_player/utils.dart';
import 'package:palette_generator/palette_generator.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> with SingleTickerProviderStateMixin {
  final player = AssetsAudioPlayer();
  bool isPlaying = true;

  // Define an animation controller to rotate the song cover image
  late final AnimationController _animationController = 
      AnimationController(vsync: this, duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    openPlayer();

    player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });
  }

  // Define a playlist for the player
  void openPlayer() async {
    await player.open(
      Playlist(audios: songs),
      autoStart: false,
      showNotification: true,
      loopMode: LoopMode.playlist,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(.2),
      appBar: AppBar(
        title: const Text(
          'Music Player',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.white30,
                  height: 0,
                  thickness: 1,
                  indent: 85,
                );
              },
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    title: Text(
                      songs[index].metas.title!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      songs[index].metas.artist!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(songs[index].metas.image!.path),
                    ),
                    onTap: () async {
                      await player.playlistPlayAtIndex(index);
                      setState(() {
                        player.getCurrentAudioImage;
                        player.getCurrentAudioTitle;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          player.getCurrentAudioImage == null
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.white12,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerPage(player: player),
                        ),
                      );
                    },
                    leading: AnimatedBuilder(
                      animation: _animationController,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _animationController.value * 2 * math.pi,
                          child: child,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            AssetImage(player.getCurrentAudioImage!.path),
                        radius: 25,
                      ),
                    ),
                    title: Text(
                      player.getCurrentAudioTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      player.getCurrentAudioArtist,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await player.playOrPause();
                        setState(() {
                          player.getCurrentAudioImage;
                          player.getCurrentAudioTitle;
                          player.getCurrentAudioArtist;
                        });
                      },
                      icon: isPlaying
                          ? const Icon(
                              CupertinoIcons.pause_fill,
                              color: Colors.white,
                            )
                          : const Icon(
                              CupertinoIcons.play_fill,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

// Playlist of songs
final List<Audio> songs = [
  Audio(
    'assets/nf_Let_You_Down.mp3',
    metas: Metas(
      title: 'Let You Down',
      artist: 'NF',
      image: const MetasImage.asset('assets/1b7f41e39f3d6ac58798a500eb4a0e2901f4502dv2_hq.jpeg'),
    ),
  ),
  Audio(
    'assets/lil_nas_x_industry_baby.mp3',
    metas: Metas(
      title: 'Industry Baby',
      artist: 'Lil Nas X',
      image: const MetasImage.asset('assets/81Uj3NtUuhL._SS500_.jpg'),
    ),
  ),
  Audio(
    'assets/Beautiful.mp3',
    metas: Metas(
      title: 'Beautiful',
      artist: 'Eminem',
      image: const MetasImage.asset('assets/916WuJt833L._SS500_.jpg'),
    ),
  ),
];
