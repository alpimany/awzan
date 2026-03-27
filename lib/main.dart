import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_writing.dart';
import 'package:awzan/data/verse.dart';
import 'package:awzan/verse.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      // Must add this line.
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = WindowOptions(
        size: Size(800, 600),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
      );

      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أوزان',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Scheherazade',
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: PoetryPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PoetryPage extends StatefulWidget {
  const PoetryPage({super.key});

  @override
  State<PoetryPage> createState() => _PoetryPageState();
}

class _PoetryPageState extends State<PoetryPage> {
  final ScrollController _scrollController = ScrollController();
  int? _activeIndex;

  late List<Verse> verses;
  late String error = "";
  late String prosody = "";
  late String tafaeel = "";
  late String baharName = "";

  // Function to focus the input and scroll it to the top
  void _onInputTap(int index) async {
    setState(() => _activeIndex = index);
  }

  void _resetFocus() {
    setState(() => _activeIndex = null);
  }

  @override
  void initState() {
    verses = [
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
      Verse(),
    ];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 672),
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  itemCount: verses.length,
                  padding: const EdgeInsets.only(bottom: 400, top: 20),
                  itemBuilder: (context, index) {
                    final verse = verses[index];

                    bool isActive = _activeIndex == index;
                    bool isDimmed = _activeIndex != null && !isActive;

                    return TapRegion(
                      // onTapInside: (event) => {_onInputTap(index)},
                      onTapOutside: (event) => {
                        if (index == _activeIndex) _resetFocus(),
                      },
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isDimmed ? 0.5 : 1.0,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            key: verse.key,
                            children: [
                              PoetryVerse(
                                verse: verse,
                                onFocus: () {
                                  _onInputTap(index);
                                },
                                onChange: (result) {
                                  setState(() {
                                    if (result.containsKey("errors")) {
                                      List<ProsodyError> errors =
                                          result['errors'];

                                      if (errors.any(
                                        (err) => err.type == .twoSaken,
                                      )) {
                                        error =
                                            "لا يَجُوز التِقاءُ ساكِنين إلا في القافية";
                                      }
                                    } else {
                                      error = "";
                                      prosody = result['output'];
                                      tafaeel = result['tafaeel'];
                                      baharName = result['baharName'];
                                    }
                                  });
                                },
                              ),

                              if (isActive)
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(20),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.black12,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: error.isEmpty
                                        ? [
                                            Text(
                                              prosody,
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade900,
                                              ),
                                            ),
                                            Text(
                                              tafaeel,
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade900,
                                              ),
                                            ),
                                            baharName.isNotEmpty
                                                ? Text(
                                                    baharName,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.green.shade900,
                                                    ),
                                                  )
                                                : Text(""),
                                          ]
                                        : [
                                            Text(
                                              error,
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade900,
                                              ),
                                            ),
                                          ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
