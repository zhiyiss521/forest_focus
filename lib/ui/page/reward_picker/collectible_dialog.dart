import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/collectible_item.dart';
import '../../widget/app_dialog_action.dart';
import '../../widget/app_window.dart';
import '../../widget/inventory_grid.dart';
import '../../widget/inventory_slot.dart';
import 'collectible_category_bar.dart';
import 'collectible_provider.dart';

class CollectibleDialog extends StatefulWidget {
  final CollectibleItem? selected;

  final ValueChanged<CollectibleItem>? onConfirm;

  const CollectibleDialog({
    super.key,
    this.selected,
    this.onConfirm,
  });

  @override
  State<CollectibleDialog> createState() => _CollectibleDialogState();
}

class _CollectibleDialogState extends State<CollectibleDialog> {
  CollectibleItem? _selected;

  CollectibleType? _selectedType;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  List<CollectibleType> _categories(List<CollectibleItem> items) {
    final list = items.map((e) => e.type).toSet().toList();

    list.sort((a, b) => a.index.compareTo(b.index));

    return list;
  }

  List<CollectibleItem> _filteredItems(List<CollectibleItem> items) {
    if (_selectedType == null) {
      return items;
    }

    return items.where((e) => e.type == _selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AppWindow(
      title: "选择素材",
      width: size.width * 0.8,
      child: Consumer<CollectibleProvider>(
        builder: (_, provider, __) {
          final items = provider.items;

          final categories = _categories(items);

          final filteredItems = _filteredItems(items);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CollectibleCategoryBar(
                categories: [
                  null,
                  ...categories,
                ],
                selectedType: _selectedType,
                onSelected: (type) {
                  setState(() {
                    _selectedType = type;

                    if (_selected != null &&
                        type != null &&
                        _selected!.type != type) {
                      _selected = filteredItems.isNotEmpty
                          ? filteredItems.first
                          : null;
                    }
                  });
                },
              ),

              SizedBox(
                height: 240,
                child: InventoryGrid(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 3,
                  itemCount: filteredItems.length,
                  itemBuilder: (_, index) {
                    final item = filteredItems[index];

                    return InventorySlot(
                      selected: _selected?.id == item.id,
                      onTap: () {
                        setState(() {
                          _selected = item;
                        });
                      },
                      image: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Image.asset(
                          item.assetPath,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                        ),
                      ),
                    );
                  },
                ),
              ),

              AppDialogActions(
                onCancel: () {
                  Navigator.pop(context);
                },
                onConfirm: _selected == null
                    ? null
                    : () {
                  widget.onConfirm?.call(_selected!);
                  Navigator.pop(context, _selected);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}