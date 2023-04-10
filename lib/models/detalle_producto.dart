import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'datos_productos.dart';

class DetalleProducto extends StatefulWidget {
  int idProd, index;
  DetalleProducto(this.idProd, this.index, {super.key});

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  List<Datos_Productos> data = List<Datos_Productos>.empty(growable: true);
  Future<List<Datos_Productos>> obtenerProductos() async {
    var url = Uri.http("dtai.uteq.edu.mx",
        '/~luiher203/awos/proyecto/back/carrito/getproductos2');
    var map = <String, dynamic>{};
    map['apikey'] = 'UTEQ';

    var response =
        await http.post(url, body: map).timeout(const Duration(seconds: 90));

    print(response.statusCode);
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
    print("ID ${widget.index}");
    super.initState();
    obtenerProductos().then((value) {
      setState(() {
        data.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      print(widget.idProd);
      return Scaffold(
        appBar: AppBar(
          title: const Text(" Detalle de Productos"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(15)),
                Text(
                  data[widget.index].Nombre,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                FadeInImage(
                  placeholder: const NetworkImage(
                      "https://flevix.com/wp-content/uploads/2020/01/Bounce-Bar-Preloader-1.gif"),
                  image: NetworkImage(data[widget.index].Img),
                  fit: BoxFit.fitHeight,
                  height: 200.0,
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Text(
                  "\$${data[widget.index].Precio}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.green),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                Text(
                  "\Genero: ${data[widget.index].Descripcion}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color.fromARGB(255, 11, 109, 170)),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    //Navigator.pushNamed(context, "/SegundaPagina");
                  },
                  child: const Text("Regresar"),
                ),
              ]),
        ),
      );
    } else {
      return const Center();
    }
  }
}
