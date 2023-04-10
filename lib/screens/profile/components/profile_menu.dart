import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/screens/profile/components/datos_perfil.dart';

import '../../../constants.dart';
import 'package:http/http.dart' as http;

import '../../../models/navegacion.dart';
import '../../sign_in/components/sign_form.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu(
      {super.key,
      required String id,
      required this.text,
      required this.icon,
      this.press});

  @override
  State<ProfileMenu> createState() => _ProfileMenu();

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: kPrimaryColor,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: 22,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenu extends State<ProfileMenu> {
  List<Datos_Perfil> data = List<Datos_Perfil>.empty(growable: true);
  Future<List<Datos_Perfil>> obtenerProductos() async {
    var url = Uri.http("dtai.uteq.edu.mx",
        '/~luiher203/awos/proyecto/back/usuarios/getcliente2/');
    var map = <String, dynamic>{};
    map["idusuario"] = id_global;

    var response = await http
        .post(
          url,
          body: map,
        )
        .timeout(Duration(seconds: 90));
    var datos = jsonDecode(response.body);

    var registros = List<Datos_Perfil>.empty(growable: true);

    for (datos in datos) {
      registros.add(Datos_Perfil.fromJson(datos));
    }

    return registros;
  }

  @override
  void initState() {
    super.initState();
    obtenerProductos().then((value) {
      setState(() {
        data.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(right: 30.0, bottom: 10.0),
                child: Material(
                  color: Color.fromARGB(255, 239, 242, 241),
                  borderRadius: BorderRadius.circular(5.0),
                  elevation: 3.0,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Row(children: <Widget>[
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${data[index].IDUsu} - ${data[index].Nombre}",
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                alignment: Alignment.topLeft,
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 36.0,
                                ),
                                onPressed: () async {
                                  setState(() {});
                                },
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              );
            },
            itemCount: data.length,
          ),
        )
      ]),
    );
  }
}
