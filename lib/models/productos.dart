import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/models/add_favoritos.dart';
import 'package:shop/models/navegacion.dart';
import 'package:shop/screens/sign_in/components/sign_form.dart';
import '../main.dart';
import 'datos_productos.dart';
import 'detalle_producto.dart';

class Productos extends StatefulWidget {
  const Productos({super.key, required String id});
  //static var routeName;
  static String routeName = "/productos";

  @override
  State<Productos> createState() => _HomeState();
}

Future<void> _dialogError(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!!, Ocurrio algo"),
          content: const Text("Cantidad no permitida"),
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

int contador = 0;
String Scontador = contador.toString();

Future<bool> agregacarrito(
    String idusuario, String idproducto, String cantidad) async {
  var url = Uri.http("dtai.uteq.edu.mx",
      "/~luiher203/awos/proyecto/back/carrito/agrega_carrito/");
  var map = <String, dynamic>{};
  map['idusuario'] = idusuario;
  map['idproducto'] = idproducto;
  map['cantidad'] = cantidad;
  print("URI OK ${url.path} ${idproducto}");
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

Future<bool> deseos(String id_usu, String id_prod) async {
  var url = Uri.http("dtai.uteq.edu.mx",
      "/~luiher203/awos/proyecto/back/carrito/agregadeseo/");
  var map = <String, dynamic>{};
  map['idusuario'] = id_usu;
  map['idproducto'] = id_prod;
  print("URI OK ${url.path} ${id_prod}");
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

class _HomeState extends State<Productos> {
  //Mapa completo
  List<Datos_Productos> data = List<Datos_Productos>.empty(growable: true);

  Future<List<Datos_Productos>> obtenerProductos() async {
    var url = Uri.http("dtai.uteq.edu.mx",
        '/~luiher203/awos/proyecto/back/carrito/getproductos2');
    var map = <String, dynamic>{};
    map['apikey'] = 'UTEQ';

    var response =
        await http.post(url, body: map).timeout(const Duration(seconds: 90));

    var datos = jsonDecode(response.body);

    //Toma 1 x 1
    var registros = List<Datos_Productos>.empty(growable: true);

    for (datos in datos) {
      registros.add(Datos_Productos.fromJson(datos));
    }

    return registros;
  }

  @override
  void initState() {
    super.initState();
    var id_usu = MyApp().readIdcliente();
    obtenerProductos().then((value) {
      setState(() {
        data.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 76, 81, 80), width: 1)),
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
                              image: NetworkImage(data[index].Img),
                              fit: BoxFit.fitHeight,
                              height: 45.0,
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            Text(
                              "${data[index].IDProd} - ${data[index].Nombre}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              data[index].Precio,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Image.asset(
                                'ojo.png',
                                height: 25,
                              ),
                              iconSize: 50,
                              onPressed: () {
                                /*print(data[index].IDProd);
                                print("Indice: ${index}");
                                print(int.parse(data[index].IDProd));*/
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetalleProducto(
                                            int.parse(data[index].IDProd),
                                            index)));
                              },
                            ),
                            IconButton(
                              icon: Image.asset(
                                'carrito.png',
                                height: 25,
                              ),
                              iconSize: 50,

                              /*print(data[index].IDProd);
                                print("Indice: ${index}");
                                print(int.parse(data[index].IDProd));*/

                              onPressed: () async {
                                if (contador <= 0) {
                                  _dialogError(context);
                                } else {
                                  if (await agregacarrito(
                                    id_global,
                                    data[index].IDProd,
                                    contador.toString(),
                                  )) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InicioPage()));
                                    setState(() {});
                                    contador = 0;
                                  }
                                }
                              },
                            ),
                            IconButton(
                              icon: Image.asset(
                                'fav.png',
                                height: 25,
                              ),
                              iconSize: 50,
                              onPressed: () async {
                                if (await deseos(
                                    id_global, data[index].IDProd)) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InicioPage(),
                                      ));
                                }
                                setState(() {});
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 209, 207, 207))
                                  .copyWith(
                                      elevation:
                                          ButtonStyleButton.allOrNull(0.0)),
                              onPressed: () {
                                contador++;
                                print(contador);
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Text('Ingresar', style: TextStyle(color: Colors.black)),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.add_box,
                                        color: Colors.purple,
                                      ),
                                      Text(
                                        'Cantidad',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(contador.toString(),
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 28))
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 209, 207, 207))
                                  .copyWith(
                                      elevation:
                                          ButtonStyleButton.allOrNull(0.0)),
                              onPressed: () {
                                contador = 0;
                                print(contador);
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Text('Ingresar', style: TextStyle(color: Colors.black)),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.remove,
                                        color: Colors.purple,
                                      ),
                                      Text(
                                        'reset',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
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
        )
      ]),
    );
  }
}
