import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// User Table Header
TableRow buildUserTableHeader() {
  return TableRow(
    decoration: BoxDecoration(color: Colors.grey[300]),
    children: const [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Sl No',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'User Name',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'No of Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

// User Table Row
TableRow buildUserTableRow({
  required QueryDocumentSnapshot user,
  required int index,
  required int orderCount,
  required String? selectedUserId,
  required Function(String) onSelectUser,
}) {
  final username = user['name'];
  final userid = user['uid'];

  return TableRow(
    decoration: BoxDecoration(
      color: selectedUserId == userid ? Colors.blue[200] : Colors.white,
      
    ),
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          index.toString(),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          username,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              orderCount.toString(),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () => onSelectUser(userid),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(5),
                child: const Text('Details'),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}