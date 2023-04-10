import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/screens/sign_in/components/sign_form.dart';
import 'package:shop/size_config.dart';

import 'complete_profile_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text("Completa tu perfil", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                CompleteProfileForm(
                  id: id_global,
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
