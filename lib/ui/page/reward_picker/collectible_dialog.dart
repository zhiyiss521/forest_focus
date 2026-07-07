import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'collectible_provider.dart';

class CollectibleDialog extends StatelessWidget {
  const CollectibleDialog({super.key});

  @override
  Widget build(BuildContext context) {

    return Dialog(
      child: SizedBox(
        width: 500,
        height: 500,
        child: Column(
          children: [

            const SizedBox(height: 16),

            const Text(
              "选择素材",
              style: TextStyle(fontSize: 22),
            ),

            const Divider(),

            Expanded(
              child: Consumer<CollectibleProvider>(
                builder: (_, provider, __) {

                  return GridView.builder(

                    padding: const EdgeInsets.all(16),

                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),

                    itemCount: provider.items.length,

                    itemBuilder: (_, index) {

                      final item = provider.items[index];

                      final selected =
                          provider.selected?.id == item.id;

                      return InkWell(

                        onTap: () {
                          provider.select(item);
                        },

                        child: Container(

                          decoration: BoxDecoration(

                            border: Border.all(

                              color: selected
                                  ? Colors.orange
                                  : Colors.grey,

                              width: selected ? 3 : 1,
                            ),
                          ),

                          child: Column(

                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [

                              Expanded(
                                child: Image.asset(item.assetPath),
                              ),

                              const SizedBox(height: 6),

                              Text(item.name),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const Divider(),

            Consumer<CollectibleProvider>(
              builder: (_, provider, __) {

                final item = provider.selected;

                if (item == null) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("请选择一个素材"),
                  );
                }

                return Padding(

                  padding: const EdgeInsets.all(16),

                  child: Column(

                    children: [

                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(item.id),

                      const SizedBox(height: 8),

                      Text(item.type.name),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}