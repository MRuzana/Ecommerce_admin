import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:clothing_admin_panel/view_models/provider/size_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {
  const SizeWidget({super.key, this.selectedType, this.sizeList});
  final String? selectedType;
  final List<String>? sizeList;

  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context, listen: false);
    final sizeProvider = Provider.of<SizeProvider>(context);

    //Ensure the initial selected values are set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedType != null && radioProvider.selectedValue.isEmpty) {
        radioProvider.setSelectedValue(selectedType!);
      }

      if (sizeList != null && sizeProvider.selectedSizes.isEmpty) {
        sizeProvider.setSelectedSizes(sizeList!);
      }
    });

    return Consumer<RadioProvider>(
      builder: (context, radioProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['XS', 'S', 'M', 'L', 'XL'].map((size) {
                return sizeOption(context, size, sizeProvider);
              }).toList(),
            ),

            const SizedBox(height: 20),

            Text('Category Type',style: Theme.of(context).textTheme.bodySmall,),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Men',
                      groupValue: radioProvider.selectedValue,
                      onChanged: (value) {
                        radioProvider.setSelectedValue(value!);
                      },
                    ),
                    const Text('Men'),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Women',
                      groupValue: radioProvider.selectedValue,
                      onChanged: (value) {
                        radioProvider.setSelectedValue(value!);
                      },
                    ),
                    const Text('Women'),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget sizeOption(
      BuildContext context, String size, SizeProvider sizeProvider) {
    bool isSelected = sizeProvider.selectedSizes.contains(size);

    return GestureDetector(
      onTap: () {
        sizeProvider.toggleSizeSelection(size);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected
              ? Colors.green
              : const Color.fromARGB(255, 254, 254, 253),
        ),
        child: Center(
            child: Text(size,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black))),
      ),
    );
  }
}
