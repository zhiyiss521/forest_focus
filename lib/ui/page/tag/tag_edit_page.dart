import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/tag.dart';
import 'tag_provider.dart';

class TagEditPage extends StatefulWidget {
  final Tag? tag;

  const TagEditPage({
    super.key,
    this.tag,
  });

  bool get isEdit => tag != null;

  @override
  State<TagEditPage> createState() => _TagEditPageState();
}

class _TagEditPageState extends State<TagEditPage> {
  final _controller = TextEditingController();

  late int _selectedColor;

  static const List<int> colors = [
    0xFFE57373,
    0xFFFFB74D,
    0xFFFFF176,
    0xFF81C784,
    0xFF4DB6AC,
    0xFF64B5F6,
    0xFF7986CB,
    0xFFBA68C8,
  ];

  @override
  void initState() {
    super.initState();

    _controller.text = widget.tag?.name ?? "";

    _selectedColor = widget.tag?.color ?? colors.first;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("请输入标签名称"),
        ),
      );
      return;
    }

    final provider = context.read<TagProvider>();

    if (widget.isEdit) {
      await provider.update(
        widget.tag!.copyWith(
          name: name,
          color: _selectedColor,
        ),
      );
    } else {
      await provider.add(
        Tag(
          name: name,
          color: _selectedColor,
          icon: "",
        ),
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("删除标签"),
          content: Text(
            "确定删除「${widget.tag!.name}」吗？",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("取消"),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("删除"),
            ),
          ],
        );
      },
    );

    if (ok != true) return;

    await context.read<TagProvider>().delete(
      widget.tag!.id!,
    );

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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _controller,
            autofocus: !widget.isEdit,
            decoration: const InputDecoration(
              labelText: "名称",
              border: OutlineInputBorder(),
            ),
            maxLength: 20,
          ),
          const SizedBox(height: 24),
          const Text(
            "颜色",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: colors.map((color) {
              final selected = color == _selectedColor;

              return InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: CircleAvatar(
                  radius: selected ? 22 : 18,
                  backgroundColor: Color(color),
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
          const SizedBox(height: 40),
          FilledButton(
            onPressed: _save,
            child: const Text("保存"),
          ),
          if (widget.isEdit) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: _delete,
              child: const Text(
                "删除标签",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}