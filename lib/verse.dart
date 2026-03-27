import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_writing.dart';
import 'package:awzan/data/verse.dart';

class PoetryVerse extends StatefulWidget {
  const PoetryVerse({
    super.key,
    required this.verse,
    this.onChange,
    this.onFocus,
  });

  final Verse verse;
  final void Function(Map result)? onChange;
  final void Function()? onFocus;

  @override
  State<PoetryVerse> createState() => _PoetryVerseState();
}

class _PoetryVerseState extends State<PoetryVerse> {
  void handleChange(Map result) {
    if (widget.onChange != null) {
      widget.onChange!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Part 1: Aligned to start
                PoetryInput(
                  initialValue: widget.verse.chest.value,
                  onChange: handleChange,
                  onFocus: widget.onFocus,
                  alignment: .start,
                ),
                const SizedBox(height: 8), // Vertical space between runs
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: PoetryInput(
                    initialValue: widget.verse.rump.value,
                    onChange: handleChange,
                    onFocus: widget.onFocus,
                    alignment: .end,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: PoetryInput(
                    initialValue: widget.verse.chest.value,
                    onChange: handleChange,
                    onFocus: widget.onFocus,
                    alignment: .start,
                  ),
                ),
                const SizedBox(width: 20), // Horizontal space between parts
                Expanded(
                  child: PoetryInput(
                    initialValue: widget.verse.rump.value,
                    onChange: handleChange,
                    onFocus: widget.onFocus,
                    alignment: .end,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class PoetryInput extends StatefulWidget {
  const PoetryInput({
    super.key,
    this.initialValue,
    this.onChange,
    this.onFocus,
    required this.alignment,
  });

  final String? initialValue;
  final void Function(Map result)? onChange;
  final void Function()? onFocus;
  final MainAxisAlignment alignment;

  @override
  State<PoetryInput> createState() => _PoetryInputState();
}

class _PoetryInputState extends State<PoetryInput> {
  final FocusNode _focusNode = FocusNode();
  final QuillController _controller = QuillController.basic();

  late bool hasText = false;
  late bool focused = false;

  @override
  void initState() {
    _controller.document = Document.fromJson([
      {"insert": "${widget.initialValue}\n"},
    ]);

    // _controller.addListener(() {
    //   hasText = _controller.getPlainText().isNotEmpty;

    //   final prosody = ProsodyWriting(text: _controller.getPlainText());

    //   if (widget.onChange != null) {
    //     widget.onChange!({
    //       "output": prosody.output,
    //       "tafaeel": prosody.tafaeelString,
    //       'baharName': prosody.baharName,
    //     });
    //   }
    // });

    _controller.addListener(() async {
      var text = _controller.document.toPlainText();
      text = text.substring(0, text.length - 1);

      var prosody = ProsodyWriting.textToProsody(text);
      var chunkedBits = ProsodyWriting.prosodyToChunkedBits(prosody);
      var errors = ProsodyWriting.validate(chunkedBits);

      if (text.isNotEmpty) {
        _controller.document.replace(
          0,
          text.length,
          Delta.fromJson([
            {"insert": text},
          ]),
        );
      }

      if (errors.isNotEmpty) {
        // Check if the error is marked already.

        for (var err in errors) {
          _controller.formatText(
            err.from,
            err.to - err.from,
            ColorAttribute("#dc2626"),
            shouldNotifyListeners: false,
          );
        }

        if (widget.onChange != null) {
          widget.onChange!({'errors': errors});
        }
      } else {
        String binary = chunkedBits.fold("", (a, b) => "$a${b.value}");
        var matches = ProsodyWriting.findMatchesForBinary(binary);

        String tafaeel = "";
        String output = "";
        String baharName = "";

        if (matches.isNotEmpty) {
          // Let's take the first match for now
          // We can add more details
          var (bahar, sowrah) = matches.elementAt(0);

          output = ProsodyWriting.splitTextBasedOnTafaeel(
            prosody.fold("", (a, b) => "$a${b.value}"),
            sowrah,
          );
          tafaeel = sowrah.join(" ");
          baharName = bahar.name;
        } else {
          // Try to write tafaeel
          var sowar = ProsodyWriting.binaryToTafaeel(binary);

          if (sowar.isNotEmpty) {
            output = ProsodyWriting.splitTextBasedOnTafaeel(
              prosody.fold("", (a, b) => "$a${b.value}"),
              sowar.elementAt(0),
            );
            tafaeel = sowar.elementAt(0).join(" ");
          }
        }

        widget.onChange!({
          'output': output,
          'tafaeel': tafaeel,
          'baharName': baharName,
        });
      }
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        if (widget.onFocus != null && focused == false) {
          widget.onFocus!();
        }
        focused = true;
      } else {
        focused = false;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(
          color: focused ? Colors.black45 : Colors.black26,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      constraints: BoxConstraints(maxWidth: 380),
      child: QuillEditor.basic(
        controller: _controller,
        focusNode: _focusNode,
        config: const QuillEditorConfig(
          customStyles: DefaultStyles(
            paragraph: DefaultTextBlockStyle(
              TextStyle(
                fontSize: 20,
                fontFamily: 'Scheherazade',
                color: Colors.black87,
              ),
              HorizontalSpacing(6.0, 0.0),
              VerticalSpacing(0.0, 0.0),
              VerticalSpacing(0.0, 0.0),
              null,
            ),
          ),
          padding: EdgeInsets.all(4),
        ),
      ),

      //  TextField(
      //   controller: _controller,
      //   textDirection: TextDirection.rtl,
      //   textAlign: TextAlign.center,
      //   style: TextStyle(
      //     fontSize: 20,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.black87,
      //   ),
      //   decoration: InputDecoration(
      //     border: InputBorder.none,
      //     contentPadding: EdgeInsetsGeometry.all(4),
      //   ),
      // ),
    );
  }
}
