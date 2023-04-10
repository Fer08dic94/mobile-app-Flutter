import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/components/custom_surfix_icon.dart';
import 'package:shop/components/form_error.dart';
import 'package:shop/helper/keyboard.dart';
import 'package:shop/models/navegacion.dart';
import 'package:shop/screens/login_success/login_success_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../../../size_config.dart';
import 'dart:convert';

String id_global = "";

Future<bool> login(String correo, String pass) async {
  var url = Uri.http(
      "dtai.uteq.edu.mx", "/~luiher203/awos/proyecto/back/usuarios/acceso/");
  var map = <String, dynamic>{};
  map['correo'] = correo;
  map['contra'] = pass;
  print("URI OK ${url.path} ${correo} ${pass}");
  http.Response response = await http.post(
    url,
    body: map,
  );

  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);

  //var datos = jsonDecode(response.body);
  //var usuario = datos["usuario"];
  //var resultado = datos["resultado"];

  if (response.statusCode == 200) {
    bool respuesta = data["resultado"];
    if (respuesta == true) {
      //const MyApp().guardaid(usuario[0]["idusuario"].toString());
      //var idUsu = await const MyApp().readIdcliente();
      // print("saco id: " + idUsu);
      String id = data["usuario"]["idusuario"];
      id_global = id;
      print(id_global);
      //id_usuario2 = id;
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
          content: const Text("Error, Usuario o contraseña incorrectos."),
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

Future<bool?> showToast() {
  return Fluttertoast.showToast(
      msg: 'Bienvenido',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 20.0);
}

final TextEditingController _correo = TextEditingController();
final TextEditingController _pass = TextEditingController();

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

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
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continuar",
            press: () async {
              if (_formKey.currentState!.validate() &&
                  await login(_correo.text,
                      md5.convert(utf8.encode(_pass.text)).toString())) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => InicioPage(id: id_global))));
                showToast();
              } else {
                _dialogError(context);
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _pass,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Contraseña",
        hintText: "Ingresa tu contraseña",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _correo,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Correo electrónico",
        hintText: "Ingresa tu correo",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
