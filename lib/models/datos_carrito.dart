class Datos_Carrito {
  String idproducto = "";
  String nomproducto = "";
  String img = "";
  String precio = "";
  String cantidad = "";

  Datos_Carrito(
      this.idproducto, this.nomproducto, this.precio, this.img, this.cantidad);

  Datos_Carrito.fromJson(Map<String, dynamic> json) {
    idproducto = json['idproducto'];
    nomproducto = json['nomproducto'];
    img = json['img'];
    precio = json['precio'];
    cantidad = json['cantidad'];
  }
}
