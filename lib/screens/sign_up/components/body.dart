import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/size_config.dart';

import 'sign_up_form.dart';

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
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Registro de cuenta", style: headingStyle),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),

                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
