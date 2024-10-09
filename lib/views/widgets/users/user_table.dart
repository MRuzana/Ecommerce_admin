import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TableViewUser extends StatelessWidget {
  const TableViewUser({super.key, required this.usersList});
  final List<QueryDocumentSnapshot>? usersList;


@override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        columnWidths: const {
          0: FlexColumnWidth(1), // sl No      
          1: FlexColumnWidth(2), // user name
          2: FlexColumnWidth(2), // email
          3: FlexColumnWidth(1), // phone number
        
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Table headers
          _buildTableHeader(),
          // Table rows for each product
           for (var i = 0; i < usersList!.length; i++) 
            _buildTableRow(usersList![i], i + 1, context),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Colors.blue),
      children:  [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Sl No',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
    
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'User Name',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
         Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Email',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
         Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Phone Number',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
       
      ],
    );
  }

  TableRow _buildTableRow(QueryDocumentSnapshot user,int index, BuildContext context) {
   
    final username = user['name'];
    final email = user['email'];
    final phone = user['phoneNumber'];
  
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(index.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(username,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(email,
            textAlign: TextAlign.center,
          ),
        ),
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(phone,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}