import 'package:flutter/material.dart';

class ForestDialog extends StatelessWidget {

  final String image;

  final String title;

  final String message;

  final String confirmText;

  final String cancelText;

  final VoidCallback onConfirm;

  final VoidCallback? onCancel;

  const ForestDialog({
    super.key,
    required this.image,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.transparent,

      child: Container(
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(

          color: const Color(0xFFF8F1E7),

          borderRadius:
          BorderRadius.circular(32),

          border: Border.all(
            color: const Color(0xFFD8C3A5),
            width: 3,
          ),

          boxShadow: const [
            BoxShadow(
              blurRadius: 24,
              offset: Offset(0, 8),
              color: Colors.black12,
            )
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Image.asset(
              image,
              width: 150,
            ),

            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                height: 1.5,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: onConfirm,

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF7CB342),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                        18),
                  ),
                ),

                child: Text(
                  confirmText,
                ),
              ),
            ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: onCancel ??
                      () {
                    Navigator.pop(context);
                  },
              child: Text(
                cancelText,
                style: const TextStyle(
                  color: Colors.brown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}