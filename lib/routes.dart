import 'package:flutter/widgets.dart';
import 'package:shop/models/add_favoritos.dart';
import 'package:shop/screens/cart/cart_screen.dart';
import 'package:shop/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop/screens/details/details_screen.dart';
//import 'package:shop/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop/screens/home/home_screen.dart';
import 'package:shop/screens/login_success/login_success_screen.dart';
import 'package:shop/screens/profile/profile_screen.dart';
import 'package:shop/screens/sign_in/sign_in_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/wishlist/wishlist_screen.dart';

import 'models/productos.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  //Productos.routeName: (context) => Productos(),

  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  //Productos.routeName: (context) => Productos(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  WishListScreen.routeName: (context) => WishListScreen(),
};
