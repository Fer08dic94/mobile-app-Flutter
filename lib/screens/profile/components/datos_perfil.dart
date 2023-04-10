class Datos_Perfil {
  String IDUsu = "";
  String Nombre = "";
  String Apellidos = "";
  String Correo = "";
  String Rfc = "";
  String Domicilio = "";
  String Colonia = "";
  String Cp = "";
  String Telefono = "";

  Datos_Perfil(this.IDUsu, this.Nombre, this.Apellidos, this.Correo, this.Rfc,
      this.Domicilio, this.Colonia, this.Cp, this.Telefono);

  Datos_Perfil.fromJson(Map<String, dynamic> json) {
    IDUsu = json['idusuario'];
    Nombre = json['nomproducto'];
    Apellidos = json['apellidos'];
    Correo = json['correo'];
    Rfc = json['rfc'];
    Domicilio = json['domicilio'];
    Colonia = json['colonia'];
    Cp = json['cp'];
    Telefono = json['telefono'];
  }
}
