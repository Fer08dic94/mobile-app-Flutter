import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'datos_productos.dart';

class AddFavoritos extends StatefulWidget {
  int idProd, index;

  static var routeName;
  AddFavoritos(this.idProd, this.index, {super.key});

  @override
  State<AddFavoritos> createState() => _AddFavoritos();
}

class _AddFavoritos extends State<AddFavoritos> {
  List<Datos_Productos> data = List<Datos_Productos>.empty(growable: true);

  Future<List<Datos_Productos>> obtenerProductos(
      int id_usu, int id_prod) async {
    var url = Uri.http("dtai.uteq.edu.mx",
        '/~luiher203/awos/proyecto/back/carrito/agregadeseo/');
    var map = <String, dynamic>{};
    map['idusuario'] = id_usu;
    map['idproducto'] = id_prod;

    var response =
        await http.post(url, body: map).timeout(const Duration(seconds: 90));

    print(response.statusCode);

    //Toma 1 x 1
    var registros = List<Datos_Productos>.empty(growable: true);

    return registros;
  }

  @override
  void initState() {
    print("ID ${widget.index}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Deseos"),
      ),
      body: Center(
        child: Column(children: [
          const Text("Producto agregado a favoritos"),
          const Padding(padding: EdgeInsets.all(15)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Regresar"),
          ),
        ]),
      ),
    );
  }
}
