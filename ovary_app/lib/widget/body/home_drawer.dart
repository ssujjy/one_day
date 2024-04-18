import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: 
              Text("유저 사진 들어올 자리"),
              // CircleAvatar(
              //   backgroundImage: AssetImage('images/turtle.jpeg'),
              // ),
              accountName: Text(
                "김땡땡님(db Nickname들어올자리)",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
              accountEmail: Text(""),
              decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.red,
              ),
              title: Text("찜 병원보기"),
              onTap: () {
                print('homs is clicked');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
              ),
              title: Text("마이페이지"),
              onTap: () {
                print('homs is clicked');
              },
            ),
           
          ],
        ),
      );
  }
}