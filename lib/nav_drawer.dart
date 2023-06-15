import 'package:flutter/material.dart';
import 'package:pos_app/value/app_string.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("Nwe Yi Aung"),
                accountEmail: Text("nweyiaung1990@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                      child: Image.network(
                    "https://randomuser.me/api/portraits/women/73.jpg",
                    width: 90,
                    height: 90,
                  )),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtjWuez2Xz2-IfbrXR2D0lEZy1GRsmsiYwcw&usqp=CAU"),
                  fit:BoxFit.cover
                  )             
                ),
              ),
              Divider(
                height: 1,
                thickness: 2,
                color: Colors.green[300],
              ),
              ListTile(
                leading: Icon(Icons.shopping_basket),
                title: Text(AppString.sale),
                onTap: (){
                    Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.receipt),
                title: Text(AppString.receipt),
                onTap: (){
                  Navigator.of(context).pushReplacementNamed('/receipt_page');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text(AppString.item),
                onTap: (){
                  Navigator.of(context).pushReplacementNamed('/item_page');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(AppString.setting),
                onTap: (){
                  Navigator.of(context).pushReplacementNamed('/setting_page');
                },
              ),
            ],
          ),
        );
  }
}