import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller = VideoPlayerController.asset(
      'assets/images/TricoderDotZeroTm-splash-video.mp4',
      videoPlayerOptions: VideoPlayerOptions(),
    )..initialize().then((_) {
        _controller.setVolume(0.0);
      });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _controller.play();
      Future.delayed(
        const Duration(seconds: 4),
        () {
          context.goNamed('home');
          // Navigator.of(context).pushReplacementNamed(Routes.home);
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('width: ${_controller.value.size.width}');
    debugPrint('height: ${_controller.value.size.height}');
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
