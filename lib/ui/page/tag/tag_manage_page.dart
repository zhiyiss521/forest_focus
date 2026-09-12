import 'package:flutter/material.dart';
import 'package:forest_focus/theme/ff_theme_provider.dart';
import 'package:forest_focus/ui/page/tag/tag_edit_page.dart';
import 'package:provider/provider.dart';
import '../../../model/tag.dart';
import '../../widget/ff_button.dart';
import '../../widget/ff_dialog.dart';
import 'tag_provider.dart';
import '../focus/focus_Provider.dart';

class TagManagePage extends StatelessWidget {
  const TagManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TagProvider>();
    final focusProvider = context.watch<FocusProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("标签"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: provider.items.isEmpty
          ? const _EmptyView()
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        itemCount: provider.items.length,
        itemBuilder: (_, index) {
          final tag = provider.items[index];

          return TagCell(
            tag: tag,
            isCurrent: tag.id == focusProvider.session.currentTagId,
            onTap: () {
              TagEditPage.show(
                context,
                tag: tag,
              );
            },
            onDelete: () {
              _deleteTag(context, tag);
            },
          );
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: FFButton(
          width: double.infinity,
          text: "新建标签",
          onPressed: () {
            TagEditPage.show(context);
          },
        ),
      ),
    );
  }

  Future<void> _deleteTag(
      BuildContext context,
      Tag tag,
      ) async {
    final ok = await FFDialog.show<bool>(
      context,
      title: "删除标签",
      message: "确定删除「${tag.name}」吗？",
      confirmText: "删除",
      cancelText: "取消",
      onConfirm: () async{
        Navigator.pop(context,true);
      },
    );

    if (ok == true && tag.id != null) {
      await context.read<TagProvider>().delete(tag.id!);
    }
  }
}


class TagCell extends StatelessWidget {

  final Tag tag;
  final bool isCurrent;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TagCell({
    required this.tag,
    required this.isCurrent,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom:12),
        padding: const EdgeInsets.symmetric(
          horizontal:18,
          vertical:16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [

            Container(
              width:18,
              height:18,
              decoration: BoxDecoration(
                color: Color(tag.color),
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width:14),

            Expanded(
              child: Text(
                tag.name,
                style: const TextStyle(
                  fontSize:16,
                  fontWeight:FontWeight.w600,
                ),
              ),
            ),

            if(isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal:10,
                  vertical:4,
                ),
                decoration: BoxDecoration(
                  color: Color(tag.color).withOpacity(.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "使用中",
                  style: TextStyle(
                    fontSize:12,
                  ),
                ),
              ),

            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size:22,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
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
          color:Colors.grey,
        ),
      ),
    );
  }
}