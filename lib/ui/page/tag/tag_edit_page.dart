import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/tag.dart';
import '../../widget/ff_button.dart';
import 'tag_provider.dart';

class TagEditPage extends StatefulWidget {
  final Tag? tag;

  const TagEditPage({
    super.key,
    this.tag,
  });

  bool get isEdit => tag != null;

  static Future<void> show(
      BuildContext context, {
        Tag? tag,
      }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TagEditPage(tag: tag),
      ),
    );
  }

  @override
  State<TagEditPage> createState() => _TagEditPageState();
}

class _TagEditPageState extends State<TagEditPage> {
  final controller = TextEditingController();

  late int selectedColor;

  static const colors = [
    0xFFE57373,
    0xFFFFB74D,
    0xFFFFF176,
    0xFF81C784,
    0xFF4DB6AC,
    0xFF64B5F6,
    0xFF7986CB,
    0xFFBA68C8,
  ];

  List<int> get colorList {
    final current = widget.tag?.color;
    if (current != null && !colors.contains(current)) {
      return [current, ...colors];
    }
    return colors;
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.tag?.name ?? "";
    selectedColor = widget.tag?.color ?? colors.first;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final name = controller.text.trim();
    if (name.isEmpty) {
      return;
    }

    final provider = context.read<TagProvider>();

    if (widget.isEdit) {
      await provider.update(
        widget.tag!.copyWith(
          name: name,
          color: selectedColor,
        ),
      );
    } else {
      await provider.add(
        Tag(
          name: name,
          color: selectedColor,
          icon: "",
        ),
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? "编辑标签" : "新建标签",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              autofocus: !widget.isEdit,
              maxLength: 20,
              decoration: const InputDecoration(
                hintText: "标签名称",
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "选择颜色",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: colorList.map((color) {
                final selected = color == selectedColor;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(
                        width: 3,
                        color: Colors.white,
                      )
                          : null,
                      boxShadow: selected
                          ? [
                        const BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 2,
                          color: Colors.black26,
                        ),
                      ]
                          : null,
                    ),
                    child: selected
                        ? const Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            FFButton(
              width: double.infinity,
              text: "保存",
              onPressed: save,
            ),
          ],
        ),
      ),
    );
  }
}