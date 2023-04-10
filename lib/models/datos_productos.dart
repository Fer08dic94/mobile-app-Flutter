class Datos_Productos {
  String IDProd = "";
  String Nombre = "";
  String Precio = "";
  String Img = "";
  String Descripcion = "";
  String Existencia = "";

  Datos_Productos(this.IDProd, this.Nombre, this.Precio, this.Img,
      this.Descripcion, this.Existencia);

  Datos_Productos.fromJson(Map<String, dynamic> json) {
    IDProd = json['idproducto'];
    Nombre = json['nomproducto'];
    Precio = json['precio'];
    Img = json['img'];
    Descripcion = json['descripcion'];
    Existencia = json['existencia'];
  }
}
