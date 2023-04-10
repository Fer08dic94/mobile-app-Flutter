import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/components/custom_surfix_icon.dart';
import 'package:shop/components/default_button.dart';
import 'package:shop/components/form_error.dart';
import 'package:shop/screens/complete_profile/complete_profile_screen.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../sign_in/sign_in_screen.dart';

// agregue esta funcion
Future<bool> registrar(
    String nombre, String apellidos, String correo, String pass) async {
  var url = Uri.http("dtai.uteq.edu.mx",
      "/~luiher203/awos/proyecto/back/usuarios/registrausuario/");
  var map = <String, dynamic>{};
  map['correo'] = correo;
  map['contra'] = pass;
  map['nombre'] = nombre;
  map['apellidos'] = apellidos;

  print("URI OK ${url.path} ${correo} ${pass} ${nombre} ${apellidos}");
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

// AGREGUE
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
      msg: 'Registro exitoso',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 20.0);
}

final TextEditingController _apellidos = TextEditingController();
final TextEditingController _nombre = TextEditingController();
final TextEditingController _correo = TextEditingController();
final TextEditingController _pass = TextEditingController();

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? nombre;
  String? apellidos;
  bool remember = false;
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
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate() &&
                  await registrar(_nombre.text, _apellidos.text, _correo.text,
                      _pass.text)) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                Navigator.pushNamed(context, SignInScreen.routeName);
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

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      controller: _nombre,
      onSaved: (newValue) => nombre = newValue,
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
        labelText: "Nombre",
        hintText: "Ingresa tu nombre",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      controller: _apellidos,
      onSaved: (newValue) => apellidos = newValue,
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
        password = value;
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
        labelText: "Password",
        hintText: "Enter your password",
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
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
