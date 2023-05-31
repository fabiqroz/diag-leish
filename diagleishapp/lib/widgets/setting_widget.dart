import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget({Key? key}) : super(key: key);

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  late YoutubePlayerController controllerV1;
  late YoutubePlayerController controllerV2;

  @override
  void initState() {
    controllerV1 = YoutubePlayerController(
      initialVideoId: 'L3zioEy_QWg',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    controllerV2 = YoutubePlayerController(
      initialVideoId: 's0yiOq4bnNQ',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            "O que é a Leishmaniose ?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          YoutubePlayer(
            controller: controllerV1,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.purple,
            progressColors: const ProgressBarColors(
              playedColor: Colors.purple,
              handleColor: Colors.purpleAccent,
            ),
            onReady: () {
              controllerV1.addListener(() {});
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
          ),
          const Text(
            "Diagnóstico, prevenção e tratamento da Leishmaniose Visceral",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          YoutubePlayer(
            controller: controllerV2,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.purple,
            progressColors: const ProgressBarColors(
              playedColor: Colors.purple,
              handleColor: Colors.purpleAccent,
            ),
            onReady: () {
              controllerV1.addListener(() {});
            },
          ),
        ],
      ),
    );
  }
}
