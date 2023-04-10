import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/carrito.dart';
import 'package:shop/models/deseos.dart';
import 'package:shop/models/productos.dart';
import 'package:shop/screens/complete_profile/components/complete_profile_form.dart';
import 'package:shop/screens/login_success/login_success_screen.dart';
import 'package:shop/screens/profile/components/profile_menu.dart';
import 'package:shop/screens/sign_in/components/sign_form.dart';
import 'package:shop/models/map.dart';
import 'package:shop/services/home_screen2.dart';

import 'api1.dart';

class InicioPage extends StatefulWidget {
  @override
  String id = "";
  State<InicioPage> createState() => _InicioPageState();
  InicioPage({id});
}

class _InicioPageState extends State<InicioPage> {
  int pageIndex = 0;

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final _productos = Productos(id: id_global);
  final _carrito = Carrito(id: id_global);
  final _deseos = Deseos(id: id_global);
  final _completeProfile = CompleteProfileForm(id: id_global);
  final _perfil = ProfileMenu(id: id_global, text: "eeee", icon: "www");
  final _api1 = Api1();
  final _map = Map();
  final _canal = HomeScreen2();

  Widget _showPage = Productos(id: id_global);

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _productos;
        break;
      case 1:
        return _carrito;
        break;
      case 2:
        return _deseos;
        break;
      case 3:
        return _completeProfile;
        break;
      case 4:
        return _perfil;
        break;
      case 5:
        return _api1;
        break;
      case 6:
        return _map;
        break;
      case 7:
        return _canal;
      default:
        return Container(
            child: const Center(
          child: Text(
            'No se encontro la pagina',
            style: TextStyle(fontSize: 18.0),
          ),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.shopping_cart, size: 30),
            Icon(Icons.favorite, size: 30),
            Icon(Icons.person, size: 30),
            Icon(Icons.person_add_alt_outlined, size: 30),
            Icon(Icons.newspaper, size: 30),
            Icon(Icons.map, size: 30),
            Icon(Icons.youtube_searched_for_sharp, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (int tappedIndex) {
            setState(() {
              _showPage = _pageChooser(tappedIndex);
            });
          },
          letIndexChange: (index) => true,
        ),
        body: Container(
          color: Colors.blueAccent,
          child: Center(
            child: Center(
              child: _showPage,
            ),
          ),
        ));
  }
}
