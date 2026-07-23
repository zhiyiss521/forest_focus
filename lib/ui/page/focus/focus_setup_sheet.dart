import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/focus/tag_chip.dart';
import 'package:forest_focus/ui/page/reward_picker/collectible_provider.dart';
import 'package:forest_focus/ui/page/tag/tag_provider.dart';
import 'package:forest_focus/ui/widget/ff_button.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../model/collectible_item.dart';
import '../../../model/tag.dart';
import '../../../theme/app_colors.dart';
import '../../../util/extension.dart';
import '../../widget/inventory_grid.dart';
import '../../widget/inventory_slot.dart';
import '../reward_picker/collectible_category_bar.dart';
import 'focus_Provider.dart';

class FocusSetupSheet extends StatelessWidget {
  const FocusSetupSheet({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FocusSetupSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 100,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Reward
                  Text(
                    "Reward",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

                  const SizedBox(
                    height: 250,
                    child: RewardSection(),
                  ),

                  /// Duration
                  Text(
                    "Duration",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

                  const SizedBox(
                    height: 56,
                    child: DurationSection(),
                  ),

                  const SizedBox(height: 24),

                  /// Tag
                  Text(
                    "Tag",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

                  const SizedBox(
                    height: 32,
                    child: TagSection(),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: Container(
              height: 100,
              child: const BottomSummary(),
            ),
          ),
        ],
      ),
    );
  }
}

class RewardSection extends StatefulWidget {
  const RewardSection({super.key});

  @override
  State<RewardSection> createState() => _RewardSectionState();
}

class _RewardSectionState extends State<RewardSection> {

  CollectibleType? _selectedType;

  List<CollectibleType> _categories(List<CollectibleItem> items,) {
    final list = items.map((e) => e.type).toSet().toList();
    list.sort((a, b) => a.index.compareTo(b.index),);
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

    final collectibleProvider = context.watch<CollectibleProvider>();
    final focusProvider = context.watch<FocusProvider>();
    final items = collectibleProvider.items;
    final categories = _categories(items);
    final filteredItems = _filteredItems(items);

    return Column(
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
            });
          },
        ),
        Expanded(
          child: Container(
            child: InventoryGrid(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 3,
              itemCount: filteredItems.length,
              itemBuilder: (_, index) {
                final item = filteredItems[index];
                return Container(
                  child: InventorySlot(
                    selected: focusProvider.currentCollectibleItemId == item.id,
                    onTap: () {
                      focusProvider.changeCollectibleItem(
                        item.id,
                      );
                    },
                    image: Image.asset(
                      item.assetPath,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.none,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class DurationSection extends StatelessWidget {
  const DurationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusProvider>(
      builder: (_, provider, __) {
        final values = List.generate(
          ((AppConstants.maxMinutes - AppConstants.minMinutes) ~/ AppConstants.step) + 1,
          (index) => AppConstants.minMinutes + index * AppConstants.step,
        );

        if(!provider.isCountdown){
          return Text("超过${AppConstants.minMinutes}给于奖励，正计时上限${AppConstants.maxCountUpMinutes}分钟，超过不再计时");
        }

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: values.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final minutes = values[index];
            final selected =  Duration(seconds:minutes * 60) == provider.userSetDuration;

            return ChoiceChip(
              label: Text("$minutes min"),
              selected: selected,
              onSelected: (_) {
                provider.changeTargetMinutes(minutes);
              },
            );
          },
        );
      },
    );
  }
}

class TagSection extends StatelessWidget {
  const TagSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<TagProvider, FocusProvider>(
      builder: (_, tagProvider, focusProvider, __) {
        final tags = tagProvider.items;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final tag = tags[index];
            final selected = tag.id == focusProvider.currentTagId;
            return TagChip(
              tag: tag,
              isSelected: selected,
              onTap: (){
                focusProvider.changeTag(tag.id!);
              },
            );
          },
        );
      },
    );
  }
}

class BottomSummary extends StatelessWidget {
  const BottomSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final focusProvider = context.watch<FocusProvider>();
    final tagProvider = context.watch<TagProvider>();
    final collectibleProvider = context.watch<CollectibleProvider>();
    Tag tag = tagProvider.getById(focusProvider.currentTagId)!;
    CollectibleItem item = collectibleProvider.getById(focusProvider.currentCollectibleItemId);
    
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: Row(
        children: [

          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundSecondary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    item.assetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 时间
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 15,
                        color: Colors.black54,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        "${focusProvider.userSetDuration.mm}min",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  // tag
                  Row(
                    children: [

                      Icon(
                        Icons.circle,
                        size: 15,
                        color: Color(tag.color),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        tag.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          Spacer(),

          FFButton(
            text: "Start",
            onPressed: (){
              Navigator.pop(context);
              focusProvider.clkStart();
            },
            width: 100,
          ),
        ],
      ),
    );
  }
}