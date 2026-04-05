import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_size.dart';

class CodeInputBox extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final bool hasError;
  final VoidCallback? onChanged;

  const CodeInputBox({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.hasError = false,
    this.onChanged,
  });

  @override
  State<CodeInputBox> createState() => CodeInputBoxState();
}

class CodeInputBoxState extends State<CodeInputBox> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  String get code =>
      _controllers.map((c) => c.text).join();

  bool get isFilled =>
      _controllers.every((c) => c.text.isNotEmpty);

  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    widget.onChanged?.call();
    if (isFilled) {
      widget.onCompleted(code);
    }
  }

  void _onKey(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      widget.onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final rs = ResponsiveSize.of(context);
    final boxRadius = rs.radius(12);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final gap = rs.w(6);
        final totalGap = (widget.length - 1) * gap;
        final boxSize = ((availableWidth - totalGap) / widget.length)
            .clamp(rs.w(40), rs.w(64));

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : gap),
              child: SizedBox(
                width: boxSize,
                height: boxSize,
                child: KeyboardListener(
                  focusNode: FocusNode(),
                  onKeyEvent: (event) => _onKey(index, event),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: AppTextStyles.codeInput,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: boxRadius,
                        borderSide: BorderSide(
                          color: widget.hasError ? AppColors.error : AppColors.borderGray,
                          width: widget.hasError ? 1.5 : 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: boxRadius,
                        borderSide: BorderSide(
                          color: widget.hasError ? AppColors.error : AppColors.dark,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onChanged: (value) => _onChanged(index, value),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
