import 'package:flutter/material.dart';

class FocusCountdownSetDialog extends StatefulWidget {
  final bool isCountdown;
  final bool isMultiPlayer;
  final void Function(bool isCountdown, bool isMultiPlayer) onChanged;

  const FocusCountdownSetDialog({
    super.key,
    required this.isCountdown,
    required this.isMultiPlayer,
    required this.onChanged,
  });

  static Future<void> show(
      BuildContext context, {
        required bool isCountdown,
        required bool isMultiPlayer,
        required void Function(bool isCountdown, bool isMultiPlayer) onChanged,
      }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => FocusCountdownSetDialog(
        isCountdown: isCountdown,
        isMultiPlayer: isMultiPlayer,
        onChanged: onChanged,
      ),
    );
  }

  @override
  State<FocusCountdownSetDialog> createState() =>
      _FocusCountdownSetDialogState();
}

class _FocusCountdownSetDialogState
    extends State<FocusCountdownSetDialog> {
  late bool isCountdown;
  late bool isMultiPlayer;

  @override
  void initState() {
    super.initState();
    isCountdown = widget.isCountdown;
    isMultiPlayer = widget.isMultiPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          widget.onChanged(isCountdown, isMultiPlayer);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '专注模式',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildModeSelector(),
              const SizedBox(height: 24),
              if (isCountdown) ...[
                _buildMultiPlayerSetting(),
                const SizedBox(height: 20),
              ],
              _buildDeepFocusSetting(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _buildModeButton(
              title: '倒计时',
              selected: isCountdown,
              onTap: () {
                setState(() {
                  isCountdown = true;
                });
              },
            ),
          ),
          Expanded(
            child: _buildModeButton(
              title: '正计时',
              selected: !isCountdown,
              onTap: () {
                setState(() {
                  isCountdown = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMultiPlayerSetting() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '多人一起种树',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '和好友一起进行专注',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: isMultiPlayer,
          onChanged: (value) {
            setState(() {
              isMultiPlayer = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDeepFocusSetting() {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '深度专注',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '专注期间减少其他干扰',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}