class Datos_Deseo {
  String idproducto = "";
  String nomproducto = "";
  String img = "";

  Datos_Deseo(this.idproducto, this.nomproducto, this.img);

  Datos_Deseo.fromJson(Map<String, dynamic> json) {
    idproducto = json['idproducto'];
    nomproducto = json['nomproducto'];
    img = json['img'];
  }
}
