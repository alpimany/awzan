import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

import 'package:awzan/app/theme.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_writing.dart';
import 'package:awzan/shared/utils/responsive.dart';

class PoetryInput extends StatefulWidget {
  const PoetryInput({
    super.key,
    this.initialValue,
    this.onChange,
    this.onFocus,
    required this.alignment,
    this.placeholder = '',
  });

  final String? initialValue;
  final void Function(Map result)? onChange;
  final void Function()? onFocus;
  final MainAxisAlignment alignment;
  final String placeholder;

  @override
  State<PoetryInput> createState() => _PoetryInputState();
}

class _PoetryInputState extends State<PoetryInput> {
  final FocusNode _focusNode = FocusNode();
  final QuillController _controller = QuillController.basic();

  bool _focused = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    _controller.document = Document.fromJson([
      {"insert": "${widget.initialValue ?? ''}\n"},
    ]);

    _controller.addListener(_onTextChanged);

    _focusNode.addListener(() {
      final hasFocus = _focusNode.hasFocus;
      setState(() => _focused = hasFocus);
      if (hasFocus && !_focused) {
        widget.onFocus?.call();
      }
    });
  }

  void _onTextChanged() {
    var text = _controller.document.toPlainText();
    text = text.substring(0, text.length - 1);

    final prosody = ProsodyWriting.textToProsody(text);
    final chunkedBits = ProsodyWriting.prosodyToChunkedBits(prosody);
    final errors = ProsodyWriting.validate(chunkedBits);

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
      for (final err in errors) {
        _controller.formatText(
          err.from,
          err.to - err.from,
          ColorAttribute('#E05252'),
          shouldNotifyListeners: false,
        );
      }
      widget.onChange?.call({'errors': errors});
    } else {
      final binary = chunkedBits.fold('', (a, b) => '$a${b.value}');
      final matches = ProsodyWriting.findMatchesForBinary(binary);

      String tafaeel = '';
      String output = '';
      String baharName = '';

      if (matches.isNotEmpty) {
        final (bahar, sowrah) = matches.first;
        output = ProsodyWriting.splitTextBasedOnTafaeel(
          prosody.fold('', (a, b) => '$a${b.value}'),
          sowrah,
        );
        tafaeel = sowrah.join(' ');
        baharName = bahar.name;
      } else {
        final sowar = ProsodyWriting.binaryToTafaeel(binary);
        if (sowar.isNotEmpty) {
          output = ProsodyWriting.splitTextBasedOnTafaeel(
            prosody.fold('', (a, b) => '$a${b.value}'),
            sowar.first,
          );
          tafaeel = sowar.first.join(' ');
        }
      }

      widget.onChange?.call({
        'output': output,
        'tafaeel': tafaeel,
        'baharName': baharName,
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = screenScale(context);
    final fontSize = scaledFont(context, 20);

    final borderColor = _focused
        ? AppColors.gold.withOpacity(0.7)
        : _hovered
        ? AppColors.border.withOpacity(0.9)
        : AppColors.border.withOpacity(0.5);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: _focused ? 1.5 : 1.0),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.06),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            // ── placeholder ──
            if (!_focused)
              Positioned.fill(
                child: IgnorePointer(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12 * s,
                      vertical: 10 * s,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ValueListenableBuilder<String>(
                        valueListenable: _PlainTextNotifier(_controller),
                        builder: (_, val, __) {
                          if (val.trim().isNotEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            widget.placeholder,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Scheherazade',
                              fontSize: fontSize,
                              color: AppColors.textSec,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

            // ── editor ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 6 * s),
              child: QuillEditor.basic(
                controller: _controller,
                focusNode: _focusNode,
                config: QuillEditorConfig(
                  customStyles: DefaultStyles(
                    paragraph: DefaultTextBlockStyle(
                      TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'Scheherazade',
                        color: AppColors.textPri,
                        height: 1.6,
                      ),
                      const HorizontalSpacing(4.0, 4.0),
                      const VerticalSpacing(0.0, 0.0),
                      const VerticalSpacing(0.0, 0.0),
                      null,
                    ),
                  ),
                  padding: EdgeInsets.all(4 * s),
                  expands: false,
                  scrollable: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlainTextNotifier extends ValueNotifier<String> {
  _PlainTextNotifier(QuillController controller)
    : super(controller.document.toPlainText()) {
    controller.addListener(() {
      value = controller.document.toPlainText();
    });
  }
}
