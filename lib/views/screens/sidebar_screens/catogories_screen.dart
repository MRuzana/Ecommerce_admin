// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:clothing_admin_panel/view_models/view_model/category_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/button_widget.dart';
import 'package:clothing_admin_panel/views/widgets/category/list_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatogoriesScreen extends StatelessWidget {
  CatogoriesScreen({super.key});
  static const String routName = '/catogories';
  TextEditingController catogoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final viewModel = Provider.of<CategoryViewModel>(context);

    return Column(
      children: [
        // Consumer for RadioProvider
        Consumer<RadioProvider>(
          builder: (context, provider, child) {
            return Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        catogoryTitle(context),
                        const SizedBox(height: 10),
                        catgoryName(context),
                        radioButton(
                            title: 'Men',
                            value: 'Men',
                            groupValue: provider.selectedValue,
                            onChanged: (value) {
                              provider.setSelectedValue(value!);
                            }),
                        radioButton(
                            title: 'Women',
                            value: 'Women',
                            groupValue: provider.selectedValue,
                            onChanged: (value) {
                              provider.setSelectedValue(value!);
                            }),
                        const SizedBox(height: 10),
                        button(
                            buttonText: 'SAVE',
                            color: Colors.blue,
                            buttonPressed: () {
                              viewModel.saveCatogory(
                                  context, catogoryController.text, provider.selectedValue);
                              catogoryController.clear();
                            }),
                        const SizedBox(height: 20),
                        const Divider(height: 2, color: Colors.grey),
                        const SizedBox(height: 40),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: ListCategoriesWidget(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget catogoryTitle(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        'Categories',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget catgoryName(BuildContext context) {
    
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextField(
        controller: catogoryController,
        decoration: const InputDecoration(
            labelText: 'Enter Catogory name',
            labelStyle: TextStyle(fontSize: 12),
            border: OutlineInputBorder()),
      ),
    );
  }

  Widget radioButton({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
          value: value, groupValue: groupValue, onChanged: onChanged),
    );
  }
  
}


