import 'package:flutter/material.dart';

class Profilescreen extends StatefulWidget {
  const new({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Arial',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      "assets/image/banner17pro.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 18),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chhuon chamrouen",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text("chhuonchamroeun168@gmail.com"),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                        child: const Text(
                          "Edit profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.dark_mode)),
                    title: Text("Dark Mode"),
                    trailing: Icon(Icons.switch_camera_rounded),
                  ),
                  // Divider(),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.notification_add)),
                    title: Text("Notification"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  // Divider(),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.privacy_tip)),
                    title: Text("Privacy"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  //Divider(),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.security)),
                    title: Text("Security"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  // Divider(),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text("Account"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  //Divider(),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.help)),
                    title: Text("Help"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  //Divider(),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text("About"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
