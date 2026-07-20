import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/tag.dart';
import '../../widget/hud.dart';
import '../focus/FocusProvider.dart';
import 'tag_provider.dart';

class TagManagePage extends StatelessWidget {
  const TagManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TagProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("标签管理"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO
              // Navigator.push(...)
            },
            child: const Icon(Icons.add),
          ),
          body: provider.items.isEmpty
              ? const _EmptyView()
              : ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            itemCount: provider.items.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1),
            itemBuilder: (context, index) {
              final tag = provider.items[index];

              return _TagTile(tag: tag);
            },
          ),
        );
      },
    );
  }
}

class _TagTile extends StatelessWidget {
  final Tag tag;

  const _TagTile({
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TagProvider>();
    final focusProvider = context.read<FocusProvider>();

    return ListTile(
      leading: CircleAvatar(
        radius: 8,
        backgroundColor: Color(tag.color),
      ),
      title: Text(
        tag.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: PopupMenuButton<_MenuAction>(
        onSelected: (action) async {
          switch (action) {
            case _MenuAction.edit:
            // TODO
              break;

            case _MenuAction.delete:
              if (tag.id == focusProvider.session.currentTagId) {
                HUD.showError("当前正在使用该标签");
                return;
              }

              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("删除标签"),
                  content: Text(
                    "确定删除「${tag.name}」吗？",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          false,
                        );
                      },
                      child: const Text("取消"),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          true,
                        );
                      },
                      child: const Text("删除"),
                    ),
                  ],
                ),
              );

              if (ok == true && tag.id != null) {
                await provider.delete(tag.id!);
              }

              break;
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(
            value: _MenuAction.edit,
            child: Text("编辑"),
          ),
          PopupMenuItem(
            value: _MenuAction.delete,
            child: Text("删除"),
          ),
        ],
      ),
      onTap: () {
        // TODO
        // 编辑页面
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "暂无标签",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}

enum _MenuAction {
  edit,
  delete,
}