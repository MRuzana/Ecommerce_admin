import 'package:clothing_admin_panel/view_models/view_model/order_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/edit_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditOrderStatusDialog extends StatefulWidget {
  const EditOrderStatusDialog({
    super.key,
    required this.orderId,
    required this.currentStatus,
    required this.onSelectedStatus,
  });

  final String orderId;
  final String currentStatus;
  final Function(String) onSelectedStatus;

  @override
  EditOrderStatusDialogState createState() => EditOrderStatusDialogState();
}

class EditOrderStatusDialogState extends State<EditOrderStatusDialog> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus; // Set initial selected status
  }

  @override
  Widget build(BuildContext context) {
   

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        
          children: [
            _buildStatusChip('Order Placed'),
            const SizedBox(height: 10,),
            _buildStatusChip('Shipped'),
            const SizedBox(height: 10,),
            _buildStatusChip('Out for delivery'),   
            const SizedBox(height: 10,),       
            _buildStatusChip('Delivered'),

            
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    return ChoiceChip(
      label: Text(status),
      selected: selectedStatus == status, // Check if this chip is selected
      onSelected: (isSelected) {
        setState(() {
          selectedStatus = status;
          widget.onSelectedStatus(selectedStatus); // Set this as the selected status
        });
      },
      selectedColor: Colors.green, // Color for the selected chip
    );
  }
}

void editAlert(BuildContext context, String orderId, String currentStatus,String userId, VoidCallback onStatusUpdated) {
    String selectedStatus = currentStatus;
      final viewModel = Provider.of<OrderViewModel>(context,listen: false);
  showDialog(
    context: context,
    builder: (context) {
      return EditAlert(
        onEdit: () {
          Navigator.of(context).pop(); // Close the initial dialog

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Select Order Status',style: TextStyle(
                  fontSize: 16,
                 
                ),),
                content: EditOrderStatusDialog(
                  orderId: orderId,
                  currentStatus: currentStatus,
                  onSelectedStatus: (String status){
                    selectedStatus = status;
                  },
                 
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
                    onPressed: () async {               
                      await viewModel.updateStatus(userId, orderId, selectedStatus, context, onStatusUpdated);                                                                  
                    },
                    child: const Text('UPDATE',style: TextStyle(color: Colors.black),),
                  ),
                   ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
                    onPressed: () {
                      Navigator.of(context).pop(); 
                    },
                    child: const Text('CANCEL',style: TextStyle(
                      color: Colors.black
                    ),),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}





