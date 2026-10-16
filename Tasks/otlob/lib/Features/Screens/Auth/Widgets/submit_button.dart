import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onTap,
    required this.title,
    this.isLoading = false,
    this.isVisiable = true,
  });
  final Function()? onTap;
  final String title;
  final bool isLoading;
  final bool isVisiable;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF5C39),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        fixedSize: Size(456, 50),
      ),
      onPressed: onTap,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(title),
    );
  }
}
