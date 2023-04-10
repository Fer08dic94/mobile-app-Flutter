import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:shop/screens/sign_in/components/sign_form.dart';
import '../models/datos_carrito.dart';
//import 'inicio_page.dart';
//import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'navegacion.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key, required String id});

  @override
  State<Carrito> createState() => _carritoState();
}

class _carritoState extends State<Carrito> {
  List<Datos_Carrito> data = List<Datos_Carrito>.empty(growable: true);
  Future<List<Datos_Carrito>> obtenerProductos() async {
    var url = Uri.http("dtai.uteq.edu.mx",
        "/~luiher203/awos/proyecto/back/carrito/get_carrito/");
    var map = <String, dynamic>{};
    map["idusuario"] = id_global;

    var response = await http
        .post(
          url,
          body: map,
        )
        .timeout(Duration(seconds: 90));
    var datos = jsonDecode(response.body);

    var registros = List<Datos_Carrito>.empty(growable: true);

    for (datos in datos) {
      registros.add(Datos_Carrito.fromJson(datos));
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

  Future<bool> borracarrito(String idusuario, String idproducto) async {
    var url = Uri.http("dtai.uteq.edu.mx",
        '/~luiher203/awos/proyecto/back/carrito/borra_carrito/');
    var map = <String, dynamic>{};
    map['idusuario'] = idusuario;
    map['idproducto'] = idproducto;

    print("URI OK ${url.path} ${idproducto} ${idusuario}");
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

  Future<bool> agregarventa(
      String idusuario, String cantidad, String idproducto) async {
    var url = Uri.http("dtai.uteq.edu.mx",
        '~luiher203/awos/proyecto/back/carrito/compracarritoApp/');
    var map = <String, dynamic>{};
    map['idusuario'] = idusuario;
    map['cantidad'] = cantidad;
    map['idproducto'] = idproducto;

    //print("URI OK ${url.path} ${id_prod} ${id_prod}");
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

  double total = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              FadeInImage(
                                placeholder: const NetworkImage(
                                    "https://flevix.com/wp-content/uploads/2020/01/Bounce-Bar-Preloader-1.gif"),
                                image: NetworkImage(data[index].img),
                                fit: BoxFit.fitHeight,
                                height: 45.0,
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              Text(
                                "${data[index].idproducto} - ${data[index].nomproducto}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  if (await borracarrito(
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
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Precio: \$" + data[index].precio,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                "Cantidad: " + data[index].cantidad,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                "Subtotal:\$${double.parse(data[index].precio) * double.parse(data[index].cantidad)}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.tealAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: data.length,
            ),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 12, 159, 233),
          onPressed: () {
            _onCompraButtonPressed();
            var snackBar = const SnackBar(content: Text('Compra éxitosa'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Icon(Icons.paypal_outlined),
        ));
  }
}

Future<void> _onCompraButtonPressed() async {
  var url = Uri(
      scheme: '',
      host: 'dtai.uteq.edu.mx',
      path: '~luiher203/awos/proyecto/back/carrito/compracarritoApp/');

  var map = <String, dynamic>{};
  //map['id_prod'] = idpro;
  map["idusuario"] = id_global;

  http.Response response = await http.post(
    url,
    body: map,
  );
  print(response.body);

  var datos = jsonDecode(response.body);
  var prod = datos["lista_deseos"];
  var carrito = datos["carrito"];

  print(prod);
}



/*
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => UsePaypal(
                    sandboxMode: true,
                    clientId:
                        "AXtf1udf_MTFtL8E-FCqUrgq4qm_QwjEgco4sSh8r4FodXLa5PJxI50M4myo4qIZTtOvF3ra7ImcKSl9",
                    secretKey:
                        "ELd_0MRd6ZL95Dwfp-3si2dX-OY6VC-p2UwM_2N_KxLLoBbzwcZl1gNbWVAn0XYf1weiEPafgaW_uTQS",
                    returnURL: "https://samplesite.com/return",
                    cancelURL: "https://samplesite.com/cancel",
                    transactions: const [
                      {
                        "amount": {
                          "total": '520',
                          "currency": "USD",
                          "details": {
                            "subtotal": '520',
                            "shipping": '0',
                            "shipping_discount": 0
                          }
                        },
                        "description": "The payment transaction description.",
                        // "payment_options": {
                        //   "allowed_payment_method":
                        //       "INSTANT_FUNDING_SOURCE"
                        // },
                        "item_list": {
                          "items": [
                            {
                              "name": "A demo product",
                              "quantity": 1,
                              "price": '10.12',
                              "currency": "USD"
                            }
                          ],

                          // shipping address is not required though
                          "shipping_address": {
                            "recipient_name": "Manuel",
                            "line1": "Travis County",
                            "line2": "",
                            "city": "Austin",
                            "country_code": "US",
                            "postal_code": 73301,
                            "phone": 4423206452,
                            "state": "Texas"
                          },
                        }
                      }
                    ],
                    note: "Contact us for any questions on your order.",
                    onSuccess: (Map params) async {
                      print("onSuccess: $params");
                    },
                    onError: (error) {
                      print("onError: $error");
                    },
                    onCancel: (params) {
                      print('cancelled: $params');
                    }),
              ),
            );

            */