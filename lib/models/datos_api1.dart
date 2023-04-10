class Datos_Api1 {
  String title = "";
  String descripcion = "";
  String urlToImage = "";

  Datos_Api1(this.title, this.descripcion, this.urlToImage);

  Datos_Api1.fromJson(Map<String, dynamic> json) {
    title = json['titulo'];
    descripcion = json['descripcion'];
    urlToImage = json['urlToImage'];
  }
}
