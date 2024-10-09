import 'package:clothing_admin_panel/views/widgets/order/order_table_helper.dart';
import 'package:flutter/material.dart';

class BottomSheetOrderDetails extends StatelessWidget {
  const BottomSheetOrderDetails({
    super.key,required this.shippingAddresId,required this.userId,required this.orderId,
    required this.totalAmount,required this.formattedDateTime,required this.products,required this.status

  });
  final String shippingAddresId;
  final String userId;
  final String orderId;
  final String totalAmount;
  final String formattedDateTime;
  final String status;
  final List products;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAddress(shippingAddresId, userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading spinner while the address is being fetched
          return const Center(child: CircularProgressIndicator());
        }
    
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
    
        // If the snapshot data is null, handle it by showing a message or default UI
        final addressData = snapshot.data;
        String name = addressData!['name'];
        String address = addressData['address'];
        String pin = addressData['postalCode'];
        String state = addressData['state'];
        String phone = addressData['phone'];
    
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Order and Shipping Details in a Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Order Details Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Order Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text('Order ID     : $orderId'),
                                Text('Total Amt    : ₹$totalAmount'),
                                Text('Order Time : $formattedDateTime'),
                                Text('Status         : $status'),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
    
                          const SizedBox(
                              width:
                                  20), // Add some space between Order and Shipping Details
    
                          // Shipping Address Section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5 ,),
                                const Text(
                                  'Shipping Address:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text('Name    : $name'),
                                Text('Address : $address'),
                                Text('PIN        : $pin'),
                                Text('State      : $state'),
                                Text('Phone    : $phone'),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
    
                      const SizedBox(height: 10),
    
                      // Products Section
                      const Text(
                        'Products:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
    
                      // Display products
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            color: Colors.grey[100],
                            elevation: 2,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product image
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(product['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Product details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['productName'] ??
                                            'Unknown Product',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text('Size: ${product['size']}',
                                          style:
                                              const TextStyle(fontSize: 12)),
                                      Text('Quantity: ${product['quantity']}',
                                          style:
                                              const TextStyle(fontSize: 12)),
                                      Text('Price: ₹${product['price']}',
                                          style:
                                              const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
    
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Close the modal
                          },
                          child: const Text('Close',style: TextStyle(color: Colors.black),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}