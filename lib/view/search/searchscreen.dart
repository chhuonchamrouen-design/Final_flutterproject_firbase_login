import 'package:flutter/material.dart';
class Searchscreen extends StatefulWidget {
  const new({super.key});
  @override
  State<Searchscreen> createState() => _SearchscreenState();
}
class _SearchscreenState extends State<Searchscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search bar",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
      ),
    );
  }
}
