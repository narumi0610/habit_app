import 'package:flutter/material.dart';
import 'package:habit_app/utils/app_color.dart';

class CustomButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  final Color? textColor;
  final EdgeInsets padding;
  final BorderSide border;
  final BorderRadius? borderRadius;
  // trueのとき2回目以降はonPressedを呼ばない（1回だけ押せるボタン）
  final bool blockDoubleClick;
  final bool loading;
  final bool isDisabled;

  static CustomButton primary({
    required Widget child,
    required bool isDisabled,
    required bool loading,
    required VoidCallback onPressed,
    EdgeInsets padding = const EdgeInsets.all(4.0),
  }) {
    return CustomButton(
      onPressed: onPressed,
      padding: padding,
      color: AppColor.primary,
      textColor: Colors.white,
      isDisabled: isDisabled,
      loading: loading,
      child: child,
    );
  }

  static CustomButton grey({
    required Widget child,
    required bool isDisabled,
    required bool loading,
    required VoidCallback onPressed,
    EdgeInsets padding = const EdgeInsets.all(4.0),
  }) {
    return CustomButton(
      onPressed: onPressed,
      padding: padding,
      color: Colors.grey,
      textColor: Colors.white,
      borderRadius: BorderRadius.circular(100.0),
      isDisabled: isDisabled,
      loading: loading,
      child: child,
    );
  }

  const CustomButton({super.key, 
    required this.child,
    required this.onPressed,
    required this.color,
    this.textColor,
    this.padding = const EdgeInsets.all(4.0),
    this.border = BorderSide.none,
    this.borderRadius,
    this.blockDoubleClick = false,
    required this.loading,
    required this.isDisabled,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
      ),
      child: Material(
        color: widget.color,
        shape: RoundedRectangleBorder(
          side: widget.border,
          borderRadius: BorderRadius.circular(50.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        textStyle: TextStyle(color: widget.textColor),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: widget.isDisabled || widget.loading
              ? null
              : () async {
                  widget.onPressed();
                },
          child: Center(
            child: Container(
              margin: widget.padding,
              child: widget.loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
