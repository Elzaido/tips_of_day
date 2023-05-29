import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tips_of_day/shared/component.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class video extends StatefulWidget {
  @override
  _videoState createState() => _videoState();
}

class _videoState extends State<video> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    '2siikxiKeKo',
    'o58OJJT37Nk',
    '1bx8PbZIxj8',
    'OAq8Slzd838',
    'rvtY0GYk1wk',
    '66XMo96D4Pk',
    'xXed7Us97iw',
    'P6fRp1S67W8',
    'ne-TDvj3GUM',
    'pT-vHCEAFTg',
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              log('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) => Scaffold(
        backgroundColor: Color.fromARGB(255, 226, 238, 255),
        appBar: defaultAppBar(context: context, title: 'Video Quotes'),
        body: ListView(
          children: [
            Center(
              child: welcomeMessege(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                  elevation: 5,
                  color: Color.fromARGB(255, 193, 217, 248),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        player,
                        SizedBox(
                          height: 10,
                        ),
                        _text('Title', _videoMetaData.title),
                        _space,
                        _text('Channel', _videoMetaData.author),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      defualtElevatedButton(
                          'Previous',
                          Icon(Icons.skip_previous),
                          _isPlayerReady
                              ? () => _controller.load(_ids[
                                  (_ids.indexOf(_controller.metadata.videoId) -
                                          1) %
                                      _ids.length])
                              : null,
                          Colors.amber),
                      defualtElevatedButton(
                          '',
                          Icon(_muted ? Icons.volume_off : Icons.volume_up),
                          _isPlayerReady
                              ? () {
                                  _muted
                                      ? _controller.unMute()
                                      : _controller.mute();
                                  setState(() {
                                    _muted = !_muted;
                                  });
                                }
                              : null,
                          Colors.amber),
                      defualtElevatedButton(
                          'Next',
                          Icon(Icons.skip_next),
                          _isPlayerReady
                              ? () => _controller.load(_ids[
                                  (_ids.indexOf(_controller.metadata.videoId) +
                                          1) %
                                      _ids.length])
                              : null,
                          Colors.amber),
                    ],
                  ),
                  _space,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: _getStateColor(_playerState),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _playerState.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
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

  Widget _text(String title, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '$title : ',
          style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              fontSize: 15),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
