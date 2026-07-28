import 'package:flutter/material.dart';

class FFDateNavigator extends StatelessWidget {
  final String title;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final double height;

  const FFDateNavigator({
    super.key,
    required this.title,
    required this.onPrevious,
    required this.onNext,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Row(
        children: [
          _ArrowButton(
            icon: Icons.chevron_left,
            onTap: onPrevious,
          ),
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  title,
                  key: ValueKey(title),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          _ArrowButton(
            icon: Icons.chevron_right,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Icon(
          icon,
          size: 24,
          color: Colors.black54,
        ),
      ),
    );
  }
}