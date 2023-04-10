import 'package:flutter/material.dart';

import 'components/body.dart';

class LoginSuccessScreen extends StatelessWidget {
  String id = "";
  static String routeName = "/login_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Inicio de sesión exitoso"),
      ),
      body: Body(),
    );
  }
}
