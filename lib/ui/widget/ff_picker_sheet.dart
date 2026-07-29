import 'package:flutter/material.dart';

class FFPickerSheet<T> extends StatelessWidget {

  final String title;
  final List<T> items;
  final String Function(T item) itemLabel;
  final bool Function(T item) isSelected;
  final ValueChanged<T> onSelected;


  const FFPickerSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabel,
    required this.isSelected,
    required this.onSelected,
  });


  static Future<void> show<T>(
      BuildContext context, {
        required String title,
        required List<T> items,
        required String Function(T item) itemLabel,
        required bool Function(T item) isSelected,
        required ValueChanged<T> onSelected,
      }) {

    return showModalBottomSheet(
      context: context,
      builder: (_) {

        return FFPickerSheet<T>(
          title: title,
          items: items,
          itemLabel: itemLabel,
          isSelected: isSelected,
          onSelected: onSelected,
        );

      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),


          ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,

            itemBuilder: (_, index) {

              final item = items[index];

              return ListTile(

                title: Text(
                  itemLabel(item),
                ),

                trailing: isSelected(item)
                    ? const Icon(Icons.check)
                    : null,


                onTap: () {

                  onSelected(item);

                  Navigator.pop(context);

                },
              );
            },
          ),

        ],
      ),
    );
  }
}