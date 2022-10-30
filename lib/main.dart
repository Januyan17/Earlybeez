// ignore_for_file: prefer_const_constructor, sort_child_properties_last
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'PressStart',
      ),
      home: DragDrop(),
    );
  }
}

class DragDrop extends StatefulWidget {
  DragDrop({Key? key}) : super(key: key);

  createState() => DragDropState();
}

class DragDropState extends State<DragDrop> {
  bool enable = true;
  late Timer timer;
  int secondsRemaining = 60;
  late AssetsAudioPlayer _assetsAudioPlayer;
  final Map<String, bool> score = {};
  int seed = 0;
  bool play = false;

  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enable = false;
        });
      }
    });
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    print('dispose');
    super.dispose();
  }

  final audios = <Audio>[
    Audio(
      'assets/eagle.mp3',
      metas: Metas(
        id: 'Online',
        title: 'Online',
        artist: 'Florent Champigny',
        album: 'OnlineAlbum',
      ),
    ),
  ];

  final Map choices = {};

  final List choice = [
    {
      'E': "E",
      'A': "A",
      'G': "G",
      'L': "L",
      'E': "E",
    },
    {
      'E': "E",
      'L': "L",
      'E': "E",
      'P': "P",
      'H': "H",
      'A': "A",
      'N': "N",
      'T': "T",
    },
    {
      'M': "M",
      'O': "O",
      'U': "U",
      'S': "S",
      'E': "E",
    },
    {
      'R': "R",
      'A': "A",
      'B': "B",
      'B': "B",
      'I': "I",
      'T': "T",
    },
  ];

  void openPlayer() async {
    await _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: 0),
      showNotification: true,
      autoStart: true,
    );
    setState(() {
      play = true;
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        play = false;
      });
    });
  }

  void stopPlayer() {
    _assetsAudioPlayer.stop();
    setState(() {
      play = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score ${score.length} / ${choices.length}'),
        backgroundColor: Colors.pink,
        actions: [
          secondsRemaining != 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    'You Have $secondsRemaining seconds',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Container(
                  child: TextButton(
                    child: const Text(
                      "Retry",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => super.widget));
                    },
                  ),
                )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                score.clear();
                seed++;
              });
            },
          ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            onPressed: () {
              stopPlayer();
            },
            backgroundColor: play ? Colors.red : Colors.green,
            child: Icon(play ? Icons.spatial_audio_off : Icons.spatial_audio),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: enable
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: GestureDetector(
                        onTap: () {
                          openPlayer();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0) //
                                    ),
                          ),

                          child: const Image(
                            image: AssetImage('assets/eagleimg.jpeg'),
                            fit: BoxFit.cover,
                          ),

                          // BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                        ),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            itemCount: choice.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (emoji, index) {
                              return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                10.0) //                 <--- border radius here
                                            ),
                                        color: Colors.green),
                                    child: Center(
                                        child:
                                            _buildDragTarget(choice[index][1])),
                                  ));
                            },
                          )
                        ]),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ListView.builder(
                          itemCount: choice.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            10.0) //                 <--- border radius here
                                        ),
                                    border: Border.all(color: Colors.red),
                                    color: Colors.red),
                                child: Draggable(
                                  data: choice,
                                  child: Emoji(
                                      emoji: score[choice[index][1]] == true
                                          ? '✅'
                                          : choice.toString()),
                                  feedback:
                                      Emoji(emoji: choice[index][1].toString()),
                                  childWhenDragging:
                                      Emoji(emoji: choice[index][1].toString()),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                )
              : Container(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Time Out !!!!",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Lottie.asset('assets/timer.json'),
                      ],
                    ),
                  ),
                )),
    );
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        // if (score[emoji] == true) {
        // return Container(
        // color: Colors.white,
        // child: Text('Correct!'),
        // alignment: Alignment.center,
        // height: 20,
        // width: 50,
        // );
        // } else {
        return Text(
          choices[emoji].toString(),
          style: const TextStyle(fontSize: 50),
        );

        // Container(choices[emoji].toString(), height: 20, width: 50);
        // }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
        });
      },
      onLeave: (data) {},
    );
  }
}

class Emoji extends StatelessWidget {
  Emoji({Key? key, required this.emoji}) : super(key: key);

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 70,
        width: 70,
        // padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: const TextStyle(color: Colors.black, fontSize: 50),
        ),
      ),
    );
  }
}
