import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:awzan/app/theme.dart';
import 'package:awzan/features/poetry/pages/poetry_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أوزان',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      theme: AppTheme.dark,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: PoetryPage(),
      ),
    );
  }
}