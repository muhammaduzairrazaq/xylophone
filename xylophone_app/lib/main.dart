import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
  ];
  final List<String> names = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
  ];
  final List<String> notes = [
    'note1.wav',
    'note2.wav',
    'note3.wav',
    'note4.wav',
    'note5.wav',
    'note6.wav',
    'note7.wav',
  ];
  final List<String> notesDisplay = [
    'note1.wav',
    'note2.wav',
    'note3.wav',
    'note4.wav',
    'note5.wav',
    'note6.wav',
    'note7.wav',
  ];

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  double h = 350.0;
  late Color selectedColor;
  late String selectedNotePath;

  final List<Widget> images = List.filled(9, Container());

  void playSound(int noteIndex) {
    final player = AudioPlayer();
    player.play(AssetSource(notes[noteIndex]));
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
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Customize'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(''),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Select a Note'),
                                    content: Container(
                                      width: 200.0,
                                      child: ListView.builder(
                                        itemCount: notesDisplay.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final note = notesDisplay[index];
                                          return ListTile(
                                            title: Text(note),
                                            onTap: () {
                                              setState(() {
                                                selectedNotePath = note;
                                                notes[noteIndex] =
                                                    selectedNotePath;
                                                Navigator.of(context).pop();
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text('Change Audio'),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  Color selectedColor = colors[noteIndex];
                                  return AlertDialog(
                                    title: Text('Select a Color'),
                                    content: ColorPicker(
                                      pickerColor: selectedColor,
                                      onColorChanged: (Color color) {
                                        selectedColor = color;
                                      },
                                      pickerAreaHeightPercent: 0.8,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            colors[noteIndex] = selectedColor;
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Change Color'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Ok'),
                        ),
                      ],
                    );
                  },
                );
              }),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < colors.length; i++)
                  buildKey(
                    noteIndex: i,
                    color: colors[i],
                    height: h - 45.0 * i,
                    name: names[i],
                  ),
              ],
            ),
            Text(
              "Press and hold on a tile for customization",
              style: GoogleFonts.caveat(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
