import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const XylophoneApp());
}

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Play Xylophone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Play Xylophone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Color.fromARGB(255, 199, 19, 253),
  ];

  final List<String> notes = [
    'note1.wav',
    'note2.wav',
    'note3.wav',
    'note4.wav',
    'note5.wav',
    'note6.wav',
    'note7.wav',
    'note5.wav',
    'note6.wav',
  ];

  final List<String> names = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
  ];

  double h = 350.0;

  final List<Widget> images = List.filled(9, Container());

  Future<void> playSound(int noteIndex) async {
    final player = AudioPlayer();
    await player.play(AssetSource('note${noteIndex+1}.wav'));

  }

  void displayImage(int noteIndex) {
    setState(() {
      images[noteIndex] = Image.asset(
        'assets/g${noteIndex + 1}.gif',
        height: 100.0,
        width: 100.0,
      );
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        images[noteIndex] = Container();
      });
    });
  }

  Widget buildKey(
      {required int noteIndex,
      required Color color,
      required double height,
      required String name}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 9.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              fixedSize: Size(20, height),
              side: const BorderSide(color: Colors.white, width: 4),
            ),
            onPressed: () {
              playSound(noteIndex);
              displayImage(noteIndex);
            },
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned.fill(child: images[noteIndex]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < colors.length; i++)
                buildKey(
                  noteIndex: i,
                  color: colors[i],
                  height: h - 30.0 * i,
                  name: names[i],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
