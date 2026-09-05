import 'package:flutter/material.dart';
class Cartscreen extends StatefulWidget {
  const new({super.key});
  @override
  State<Cartscreen> createState() => _CartscreenState();
}
class _CartscreenState extends State<Cartscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My cart",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
      ),
    );
  }
}
