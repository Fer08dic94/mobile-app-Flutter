import 'package:flutter/material.dart';
//import 'package:proyect_end/screens/inicio_page.dart';
import 'package:shop/screens/sign_in/components/sign_form.dart';
import '../models/datos_deseo.dart';
//import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'navegacion.dart';

class Deseos extends StatefulWidget {
  const Deseos({super.key, required String id});

  @override
  State<Deseos> createState() => _DeseosState();
}

class _DeseosState extends State<Deseos> {
  List<Datos_Deseo> data = List<Datos_Deseo>.empty(growable: true);
  Future<List<Datos_Deseo>> obtenerProductos() async {
    var url = Uri.http("dtai.uteq.edu.mx",
        '/~luiher203/awos/proyecto/back/carrito/getdeseos2/');
    var map = <String, dynamic>{};
    map["idusuario"] = id_global;

    var response = await http
        .post(
          url,
          body: map,
        )
        .timeout(Duration(seconds: 90));
    var datos = jsonDecode(response.body);

    var registros = List<Datos_Deseo>.empty(growable: true);

    for (datos in datos) {
      registros.add(Datos_Deseo.fromJson(datos));
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

  Future<bool> borradeseos(String idusuario, String idproducto) async {
    var url = Uri.http("dtai.uteq.edu.mx",
        '/~luiher203/awos/proyecto/back/carrito/borradeseo2/');
    var map = <String, dynamic>{};
    map['idusuario'] = idusuario;
    map['idproducto'] = idproducto;

    print("URI OK ${url.path} ${idusuario} ${idproducto}");
    http.Response response = await http.post(
      url,
      body: map,
    );

    print(response.body);
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      bool respuesta = data["resultado"];
      if (respuesta) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> _dialogError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Eliminado"),
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text("Okey"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
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
                        Container(
                          height: 80,
                          child: Image.network(data[index].img),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${data[index].idproducto} - ${data[index].nomproducto}",
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
                                  if (await borradeseos(
                                      id_global, data[index].idproducto)) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => InicioPage(
                                                  id: id_global,
                                                )));
                                  }
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
