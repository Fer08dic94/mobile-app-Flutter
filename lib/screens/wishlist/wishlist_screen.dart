import 'package:flutter/material.dart';
import 'package:shop/models/Cart.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../enums.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';

class WishListScreen extends StatelessWidget {
  static String routeName = "/wishlist";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
      bottomNavigationBar:
          CustomBottomNavBar(selectedMenu: MenuState.favourite),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Tu lista de deseos",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${demoCarts.length} deseos",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
