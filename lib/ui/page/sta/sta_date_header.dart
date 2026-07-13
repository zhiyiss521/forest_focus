import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/sta/sta_provider.dart';
import 'package:provider/provider.dart';

class StaDateHeader extends StatelessWidget {
  const StaDateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dateTitle = context.select<StaProvider, String>(
          (p) => p.dateTitle,
    );

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          _ArrowButton(
            icon: Icons.chevron_left,
            onTap: () {
              context.read<StaProvider>().previous();
            },
          ),

          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  dateTitle,
                  key: ValueKey(dateTitle),
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
            onTap: () {
              context.read<StaProvider>().next();
            },
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
        ),
      ),
    );
  }
}