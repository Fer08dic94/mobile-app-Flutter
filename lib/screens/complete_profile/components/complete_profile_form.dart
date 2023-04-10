import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/components/custom_surfix_icon.dart';
import 'package:shop/components/default_button.dart';
import 'package:shop/components/form_error.dart';
import 'package:shop/screens/sign_in/components/sign_form.dart';

import '../../../constants.dart';
import '../../../models/navegacion.dart';
import '../../../models/productos.dart';
import '../../../size_config.dart';
import '../../sign_in/sign_in_screen.dart';
import 'package:http/http.dart' as http;

Future<bool> completarperfil(
    String idusuario,
    String nombre,
    String apellidos,
    String rfc,
    String domicilio,
    String colonia,
    String cp,
    String telefono) async {
  var url = Uri.http("dtai.uteq.edu.mx",
      "/~luiher203/awos/proyecto/back/usuarios/actualizaperfil2");
  var map = <String, dynamic>{};
  map['idusuario'] = idusuario;
  map['nombre'] = nombre;
  map['apellidos'] = apellidos;
  map['rfc'] = rfc;
  map['domicilio'] = domicilio;
  map['colonia'] = colonia;
  map['cp'] = cp;
  map['telefono'] = telefono;
  // map['token'] = token;

  print("URI OK ${url.path} ${rfc} ${domicilio} ${colonia} ${cp} ${telefono}");
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
          content: const Text("Error, no se registraron los datos."),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

Future<bool?> showToast() {
  return Fluttertoast.showToast(
      msg: 'Perfil actualizado con exito',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 20.0);
}

final TextEditingController _nombre = TextEditingController();
final TextEditingController _apellidos = TextEditingController();
final TextEditingController _rfc = TextEditingController();
final TextEditingController _domicilio = TextEditingController();
final TextEditingController _colonia = TextEditingController();
final TextEditingController _cp = TextEditingController();
final TextEditingController _telefono = TextEditingController();

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key, required String id});
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? lastName;
  String? phoneNumber;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNombreFormField(), // domicilio
          SizedBox(height: getProportionateScreenHeight(30)),
          buildApellidosFormField(), // domicilio
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(), // telefono
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDomicilioFormField(), // domicilio
          SizedBox(height: getProportionateScreenHeight(30)),
          buildColoniaFormField(), // colonia
          SizedBox(height: getProportionateScreenHeight(30)),
          buildCodigoPostalFormField(), // codigo postal
          SizedBox(height: getProportionateScreenHeight(30)),
          buildRfcFormField(), // rfc
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continuar",
            press: () async {
              if (_formKey.currentState!.validate() &&
                  await completarperfil(
                      id_global,
                      _nombre.text,
                      _apellidos.text,
                      _rfc.text,
                      _domicilio.text,
                      _colonia.text,
                      _cp.text,
                      _telefono.text)) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InicioPage()));
                showToast();
              } else {
                _dialogError(context);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildNombreFormField() {
    return TextFormField(
      controller: _nombre,
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Nombre",
        hintText: "Ingresa tu nombre",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildApellidosFormField() {
    return TextFormField(
      controller: _apellidos,
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Apellidos",
        hintText: "Ingresa tus apellidos",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: _telefono,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Numero de telefono",
        hintText: "Ingresa tu telefono",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildRfcFormField() {
    return TextFormField(
      controller: _rfc,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "RFC",
        hintText: "Ingresa tu rfc",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildCodigoPostalFormField() {
    return TextFormField(
      controller: _cp,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Codigo postal",
        hintText: "Ingresa tu codigo postal",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildDomicilioFormField() {
    return TextFormField(
      controller: _domicilio,
      onSaved: (newValue) => lastName = newValue,
      decoration: InputDecoration(
        labelText: "Domicilio",
        hintText: "Ingresa tu domicilio",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildColoniaFormField() {
    return TextFormField(
      controller: _colonia,
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Colonia",
        hintText: "Ingresa tu colonia",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
