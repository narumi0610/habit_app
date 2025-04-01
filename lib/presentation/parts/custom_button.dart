import 'package:flutter/material.dart';
import 'package:habit_app/utils/app_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.child,
    required this.onPressed,
    required this.color,
    required this.loading,
    required this.isDisabled,
    super.key,
    this.textColor,
    this.padding = const EdgeInsets.all(4),
    this.border = BorderSide.none,
    this.borderRadius,
    this.blockDoubleClick = false,
  });

  const CustomButton.primary({
    required this.child,
    required this.onPressed,
    required this.isDisabled,
    required this.loading,
    super.key,
    this.padding = const EdgeInsets.all(4),
  })  : color = AppColor.primary,
        textColor = Colors.white,
        border = BorderSide.none,
        borderRadius = null,
        blockDoubleClick = false;

  CustomButton.grey({
    required this.child,
    required this.onPressed,
    required this.isDisabled,
    required this.loading,
    super.key,
    this.padding = const EdgeInsets.all(4),
  })  : color = Colors.grey.shade200,
        textColor = AppColor.text,
        borderRadius = BorderRadius.circular(100),
        border = BorderSide.none,
        blockDoubleClick = false;

  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  final Color? textColor;
  final EdgeInsets padding;
  final BorderSide border;
  final BorderRadius? borderRadius;
  final bool blockDoubleClick;
  final bool loading;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          side: border,
          borderRadius: BorderRadius.circular(50),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        textStyle: TextStyle(color: textColor),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: isDisabled || loading
              ? null
              : () async {
                  onPressed();
                },
          child: Center(
            child: Container(
              margin: padding,
              child: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}
