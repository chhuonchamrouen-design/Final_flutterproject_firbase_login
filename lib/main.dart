import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/Mainhomepage.dart';
import 'package:shop/bloc/shop_bloc.dart'; 
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ShopBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Mainhomepage(), 
      ),
    );
  }
}
