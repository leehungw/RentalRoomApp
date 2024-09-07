import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rental_room_app/themes/color_palete.dart';

class NumericUpDown extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int min;
  final int max;
  final int step;
  final double arrowsWidth;
  final double arrowsHeight;
  final EdgeInsets contentPadding;
  final double borderWidth;
  final ValueChanged<int?>? onChanged;

  const NumericUpDown({
    Key? key,
    this.controller,
    this.focusNode,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.arrowsWidth = 24,
    this.arrowsHeight = kMinInteractiveDimension,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.borderWidth = 2,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NumericUpDownState();
}

class _NumericUpDownState extends State<NumericUpDown> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _canGoUp = false;
  bool _canGoDown = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _updateArrows(int.tryParse(_controller.text));
  }

  @override
  void didUpdateWidget(covariant NumericUpDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller = widget.controller ?? _controller;
    _focusNode = widget.focusNode ?? _focusNode;
    _updateArrows(int.tryParse(_controller.text));
  }

  @override
  Widget build(BuildContext context) => TextField(
      controller: _controller,
      focusNode: _focusNode,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      maxLength: widget.max.toString().length + (widget.min.isNegative ? 1 : 0),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: ColorPalette.detailBorder),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: ColorPalette.primaryColor),
              borderRadius: BorderRadius.circular(20)),
          counterText: "",
          suffixIconConstraints: BoxConstraints(
              maxHeight: widget.arrowsHeight,
              maxWidth: widget.arrowsWidth + widget.contentPadding.right),
          suffixIcon: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(widget.borderWidth),
                      bottomRight: Radius.circular(widget.borderWidth))),
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(
                  top: widget.borderWidth,
                  right: widget.borderWidth,
                  bottom: widget.borderWidth,
                  left: widget.contentPadding.right),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                                onTap: _canGoUp
                                    ? () {
                                        _focusNode.unfocus();
                                        _focusNode.canRequestFocus = false;
                                        _update(true);
                                      }
                                    : () {
                                        _focusNode.unfocus();
                                        _focusNode.canRequestFocus = false;
                                      },
                                child: Opacity(
                                    opacity: _canGoUp ? 1 : .5,
                                    child: const Icon(Icons.arrow_drop_up))))),
                    Expanded(
                        child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                                onTap: _canGoDown
                                    ? () {
                                        _focusNode.unfocus();
                                        _focusNode.canRequestFocus = false;
                                        _update(false);
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          _focusNode.canRequestFocus = true;
                                        });
                                      }
                                    : () {
                                        _focusNode.unfocus();
                                        _focusNode.canRequestFocus = false;
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          _focusNode.canRequestFocus = true;
                                        });
                                      },
                                child: Opacity(
                                    opacity: _canGoDown ? 1 : .5,
                                    child:
                                        const Icon(Icons.arrow_drop_down))))),
                  ]))),
      maxLines: 1,
      onChanged: (value) {
        final intValue = int.tryParse(value);
        widget.onChanged?.call(intValue);
        _updateArrows(intValue);
      },
      inputFormatters: [_NumberTextInputFormatter(widget.min, widget.max)]);

  void _update(bool up) {
    var intValue = int.tryParse(_controller.text);
    intValue == null
        ? intValue = 0
        : intValue += up ? widget.step : -widget.step;
    _controller.text = intValue.toString();
    _updateArrows(intValue);
  }

  void _updateArrows(int? value) {
    final canGoUp = value == null || value < widget.max;
    final canGoDown = value == null || value > widget.min;
    if (_canGoUp != canGoUp || _canGoDown != canGoDown) {
      setState(() {
        _canGoUp = canGoUp;
        _canGoDown = canGoDown;
      });
    }
  }
}

class _NumberTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _NumberTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (const ['-', ''].contains(newValue.text)) return newValue;
    final intValue = int.tryParse(newValue.text);
    if (intValue == null) return oldValue;
    if (intValue < min) return newValue.copyWith(text: min.toString());
    if (intValue > max) return newValue.copyWith(text: max.toString());
    return newValue.copyWith(text: intValue.toString());
  }
}
