import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typeweight/typeweight.dart';
import 'package:video_player/video_player.dart';

import 'package:hlsd/components/action_button.dart';

class VideoPlayerPage extends StatefulWidget {
  final String path;

  VideoPlayerPage(this.path);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _videoPlayerController;
  Future<void> _future;

  Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();
    setState(() {
      print(_videoPlayerController.value.aspectRatio);
    });
  }

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.file(File(widget.path));
    _future = initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video Player',
          style: GoogleFonts.ubuntuMono(
            fontWeight: TypeWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: ActionButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (_videoPlayerController.value.initialized) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: StatefulBuilder(
        builder: (_, setCurrentState) {
          return FloatingActionButton(
            child: Icon(
              _videoPlayerController.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
            onPressed: () {
              if (_videoPlayerController.value.isPlaying) {
                _videoPlayerController.pause();
              } else {
                _videoPlayerController.play();
              }
              setCurrentState(() {});
            },
          );
        },
      ),
    );
  }
}
