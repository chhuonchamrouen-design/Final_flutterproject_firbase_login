// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shop/bloc/shop_bloc.dart';
// // Contact method options — using an enum instead of two bools sharing
// // one variable, so the two radios are properly mutually exclusive.
// enum ContactMethod { phoneCall, telegram }
// class Checkputscreen extends StatefulWidget {
//   const Checkputscreen({super.key});
//   @override
//   State<Checkputscreen> createState() => _CheckputscreenState();
// }
// class _CheckputscreenState extends State<Checkputscreen> {
//   bool selectAddress = false;
//   bool selectDelivery = false;
//   ContactMethod? selectedContact;
//   // ---------- Pink theme palette (visual only, logic unchanged) ----------
//   static const Color pinkBackground = Color(0xFFF6C6D5);
//   static const Color pinkCard = Color(0xFFFBE0E8);
//   static const Color pinkButton = Color(0xFFF0AFC7);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: pinkBackground,
//       appBar: AppBar(
//         backgroundColor: pinkBackground,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: (){
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back_ios, size: 22),
//         ),
//         title: BlocBuilder<ShopBloc, ShopState>(
//           builder: (context, state) {
//             return Text(
//               "Checkout(${state.cartItem.length})",
//               style: TextStyle(fontSize: 20, color: Colors.black),
//             );
//           },
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: BlocBuilder<ShopBloc, ShopState>(
//             builder: (context, state) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Order Summary"),
//                   SizedBox(height: 5),
//                   SizedBox(
//                     height: 220,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: state.cartItem.length,
//                       itemBuilder: (context, index) {
//                         final item = state.cartItem[index];
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             width: 150,
//                             decoration: BoxDecoration(
//                               color: pinkCard,
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Center(
//                                     child: Image.asset(
//                                       height: 100,
//                                       width: 100,
//                                       fit: BoxFit.contain,
//                                       item.product!.image,
//                                     ),
//                                   ),
//                                   Text(item.product!.name,style: TextStyle(color: Colors.grey,fontSize: 12),),
//                                   // AppText(
//                                   //   text: item.product!.name,
//                                   //   colors: Colors.grey,
//                                   //   size: 12,
//                                   // ),
//                                   // AppText(
//                                   //   text: "Size: ${item.size}",
//                                   //   colors: Colors.grey,
//                                   //   size: 12,
//                                   // ),
//                                  Text("Size: ${item.size}",style: TextStyle(color: Colors.grey,fontSize: 16),),
//                                   // AppText(
//                                   //   text: "Color: ${item.color}",
//                                   //   colors: Colors.grey,
//                                   //   size: 12,
//                                   // ),
//                                   Text("Size: ${item.color}",style: TextStyle(color: Colors.grey,fontSize: 16),),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       // AppText(
//                                       //   text: "Quatity:${item.quantity}",
//                                       //   colors: Colors.grey,
//                                       //   size: 12,
//                                       // ),
//                                     Text("Quatity:${item.quantity}",style: TextStyle(color: Colors.grey,fontSize: 16),),
//                                       // AppText(
//                                       //   text: "Price:\$${item.product!.price}",
//                                       //   colors: Colors.grey,
//                                       //   size: 12,
//                                       // ),
//                                                                           Text("Price:\$${item.product!.price}",style: TextStyle(color: Colors.grey,fontSize: 16),),

//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   AppText(text: "Devilery Address"),
//                   SizedBox(height: 8),
//                   Container(
//                     height: 175,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: pinkCard,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 34),
//                           child: AppText(
//                             text: "Kelvin",
//                             colors: Colors.grey,
//                             size: 16,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Radio<bool>(
//                               value: true,
//                               groupValue: selectAddress,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectAddress = value!;
//                                 });
//                               },
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 1),
//                               child: AppText(
//                                 text: "099765487654",
//                                 size: 16,
//                                 colors: Colors.grey,
//                               ),
//                             ),
//                             Spacer(),
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(Icons.arrow_forward_ios, size: 20),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 34),
//                           child: AppText(
//                             text: "Phnom penh",
//                             size: 16,
//                             colors: Colors.grey,
//                           ),
//                         ),
//                         Divider(color: Colors.black12),
//                         Row(
//                           children: [
//                             Radio<bool>(
//                               value: true,
//                               groupValue: selectDelivery,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectDelivery = value!;
//                                 });
//                               },
//                             ),
//                             ClipRRect(
//                               borderRadius: BorderRadiusGeometry.circular(20),
//                               child: Image.asset(
//                                 "assets/image/brazilyellow.jpg",
//                                 height: 50,
//                                 width: 50,
//                               ),
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 AppText(
//                                   text: "Delivery",
//                                   size: 16,
//                                   colors: Colors.grey,
//                                 ),
//                                 AppText(
//                                   text: " 1-2 days",
//                                   size: 16,
//                                   colors: Colors.grey,
//                                 ),
//                               ],
//                             ),
//                             Spacer(),
//                             AppText(
//                               text: "Change",
//                               size: 16,
//                               colors: Colors.grey,
//                             ),
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(Icons.arrow_forward_ios, size: 20),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   AppText(text: "Prefarred Contact Line"),
//                   SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Radio<ContactMethod>(
//                         value: ContactMethod.phoneCall,
//                         groupValue: selectedContact,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedContact = value;
//                           });
//                         },
//                       ),
//                       Container(
//                         height: 40,
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: pinkCard,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.phone, size: 22),
//                             SizedBox(width: 3),
//                             AppText(
//                               text: "Phone call",
//                               size: 16,
//                               colors: Colors.grey,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Radio<ContactMethod>(
//                         value: ContactMethod.telegram,
//                         groupValue: selectedContact,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedContact = value;
//                           });
//                         },
//                       ),
//                       Container(
//                         height: 40,
//                         padding: EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: pinkCard,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.telegram_rounded, size: 22),
//                             SizedBox(width: 3),
//                             AppText(
//                               text: "Telegram",
//                               size: 16,
//                               colors: Colors.grey,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Container(
//                     height: 50,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: pinkCard,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Phone Number",
//                           hintStyle: TextStyle(color: Colors.grey),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   AppText(text: "Payment Method"),
//                   SizedBox(height: 10),
//                   Container(
//                     height: 50,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: pinkCard,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         children: [
//                           Icon(Icons.payment, size: 25),
//                           SizedBox(width: 10),
//                           AppText(
//                             text: "Select a mayment method",
//                             colors: Colors.grey,
//                             size: 16,
//                           ),
//                           Spacer(),
//                           IconButton(
//                             onPressed: () {},
//                             icon: Icon(Icons.arrow_forward_ios, size: 22),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   AppText(text: "Price Summary"),
//                   SizedBox(height: 10),
//                   Container(
//                     height: 125,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: pinkCard,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               AppText(
//                                 text: "Total",
//                                 size: 18,
//                                 colors: Colors.grey,
//                               ),
//                               Spacer(),
//                               AppText(
//                                 text: "\$${state.gettotal.toStringAsFixed(2)}",
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               AppText(
//                                 text: "Discount",
//                                 size: 18,
//                                 colors: Colors.grey,
//                               ),
//                               Spacer(),
//                               AppText(text: "\$${state.dis()}"),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               AppText(
//                                 text: "Deleviry",
//                                 size: 18,
//                                 colors: Colors.grey,
//                               ),
//                               Spacer(),
//                               AppText(text: "\$${state.devilery.toString()}"),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               AppText(
//                                 text: "Subtotal ",
//                                 size: 18,
//                                 colors: Colors.grey,
//                               ),
//                               Spacer(),
//                               AppText(
//                                 text: "\$${state.subtoal().toStringAsFixed(2)}",
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.all(10),
//         child: SizedBox(
//           height: 50,
//           width: double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: pinkButton,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             onPressed: (){
//               // Get.to(Checkputscreen());
//             },
//             child: const Text(
//             "Checkout",
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }