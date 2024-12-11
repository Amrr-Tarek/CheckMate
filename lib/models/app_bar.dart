import 'package:flutter/material.dart';

AppBar appBar(final String title) {
  return AppBar(
    backgroundColor: const Color(0xFFB9A3F4),
    title: Text(title,
        style: const TextStyle(
            color: Color(0xFF1D1B20),
            fontSize: 22,
            fontWeight: FontWeight.bold) // Change to Cairo
        ),
    centerTitle: true,
    // leading: IconButton(
    //   icon: const Icon(
    //     Icons.menu,
    //     color: Color(0xFF1D1B20),
    //   ),
    //   onPressed: () {
    //     // Display Drawer
    //   },
    // ),
  ); // Remember to add a suffix for the profile
}
