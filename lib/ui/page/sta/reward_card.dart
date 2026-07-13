import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/sta/sta_card.dart';
import 'package:forest_focus/ui/page/sta/sta_provider.dart';
import 'package:provider/provider.dart';

import '../../../../model/CollectibleItem.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final rewards = context.select<StaProvider, List<CollectibleItem>>((p) => p.rewards,);

    return StaCard(
      title: "Collection",
      child: rewards.isEmpty
          ? const _EmptyView()
          : SizedBox(
        height: 92,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: rewards.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            return _RewardItem(
              item: rewards[index],
            );
          },
        ),
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final CollectibleItem item;

  const _RewardItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              item.assetPath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.image_not_supported_outlined,
                  size: 28,
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Center(
        child: Text(
          "No rewards yet",
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}