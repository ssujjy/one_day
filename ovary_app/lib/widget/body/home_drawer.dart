import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ovary_app/view/cycle_history.dart';
import 'package:ovary_app/view/hospital_likelist.dart';
import 'package:ovary_app/view/mypage_menu.dart';
import 'package:ovary_app/widget/body/weight_chart_widget.dart';

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
                Icons.local_hospital,
                color: Colors.black,
              ),
              title: Text("찜 병원보기"),
              onTap: () {
                Get.to(HospitalLikeList());
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person_sharp,
              ),
              title: Text("마이페이지"),
              onTap: () {
                Get.to(MypageMenu());
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.bar_chart_rounded,
              ),
              title: const Text("나의 체중 변화"),
              onTap: () {
                Get.to(const WeightChartWidget());
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.water_drop,
              ),
              title: const Text("나의 생리주기 차트"),
              onTap: () {
                Get.to(const periodCycleChart());
              },
            ),
          ],
        ),
      );
  }
}