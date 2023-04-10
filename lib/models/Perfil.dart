import 'package:flutter/material.dart';
import 'package:shop/models/navegacion.dart';
import 'package:shop/screens/profile/components/datos_perfil.dart';
import 'package:shop/screens/sign_in/components/sign_form.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

String id_global = "";

class Perfil extends StatefulWidget {
  static const String routeName = "/perfil";
  const Perfil({super.key, required String id_global});

  static const colorFondoAppBar = Color.fromARGB(209, 0, 119, 255);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  List<Datos_Perfil> data = List<Datos_Perfil>.empty(growable: true);
  Future<List<Datos_Perfil>> obtenerpersonas() async {
    var url = Uri.http("dtai.uteq.edu.mx",
        '/~luiher203/awos/proyecto/back/usuarios/getcliente2/');
    var map = <String, dynamic>{};
    map['idusuario'] = id_global;

    print(id_global);
    var response = await http
        .post(
          url,
          body: map,
        )
        .timeout(const Duration(seconds: 90));

    var datos = jsonDecode(response.body);

    final registros = List<Datos_Perfil>.empty(growable: true);

    for (datos in datos) {
      registros.add(Datos_Perfil.fromJson(datos));
    }
    return registros;
  }

  @override
  void initState() {
    super.initState();
    obtenerpersonas().then((value) {
      setState(() {
        data.addAll(value);
      });
    });
  }

  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _correo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(209, 234, 138, 28),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 50),
                    color: Color.fromARGB(255, 253, 253, 253),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _nombre,
                          decoration: InputDecoration(
                            icon: Icon(Icons.account_circle_outlined),
                            hintText: "${data[index].IDUsu}",
                            label: Text(
                              "Nombre:",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 6, 101, 55)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _correo,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: "${data[index].Correo}",
                            label: Text(
                              "Correo:",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 6, 101, 55)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: data.length,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => InicioPage()));
          setState(() {});
        },
        label: const Text('Exit'),
        icon: const Icon(Icons.fire_extinguisher_sharp),
        backgroundColor: Colors.blue,
      ),
    ));
  }
}
