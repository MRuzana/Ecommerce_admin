import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:clothing_admin_panel/view_models/provider/size_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SizeWidget extends StatelessWidget {
  const SizeWidget({
    super.key,this.selectedType,this.sizeList
  });
  final String? selectedType;
  final List<String>? sizeList;
  
  @override
  Widget build(BuildContext context) {
    final radioProvider = Provider.of<RadioProvider>(context,listen: false);
    final sizeProvider = Provider.of<SizeProvider>(context);

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
        return Row(
      
        children: [
          Row(
            children: [
              sizeOption(context, 'XS', sizeProvider),
              const SizedBox(width: 10),
              sizeOption(context, 'S', sizeProvider),
              const SizedBox(width: 10),
              sizeOption(context, 'M', sizeProvider),
              const SizedBox(width: 10),
              sizeOption(context, 'L', sizeProvider),
              const SizedBox(width: 10),
              sizeOption(context, 'XL', sizeProvider),
            ],
          ),
      
          const SizedBox(width: 100,),
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
          
              const SizedBox(width: 20,),
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
      );
      },
      
    );
  }

  Widget sizeOption(BuildContext context, String size, SizeProvider sizeProvider) {
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
          color: isSelected ? Colors.green  : const Color.fromARGB(255, 254, 254, 253),
        ),
        child: Center(child: Text(size,style: TextStyle(
          color: isSelected ? Colors.white : Colors.black 
        ))),
      ),
    );
  }
}

















