import 'package:flutter/material.dart';
import 'package:ovary_app/widget/body/login_widget.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인페이지"),
      ),
      body: LogInWidget(),
    );
  }
}