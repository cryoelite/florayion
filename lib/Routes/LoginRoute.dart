import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import './LoadingRoute.dart';
import '../logindata/LoginData.dart';
import '../logindata/RegisterData.dart';
import 'package:florayion/i_c1_icons.dart';

import '../routeConfig.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  var k = 0;
  var i = 0;
  var j = 0;

  bool loader = false;
  final enteredName = TextEditingController();
  final enteredPas = TextEditingController();
  void setter() {
    setState(
      () {
        i = 1;
      },
    );
  }

  void authentize() async {
    final tempname = enteredName.text;
    final pass = enteredPas.text;
    if (tempname.isEmpty || pass.isEmpty) {
      return;
    } else {
      final nameR = [];
      for (var typer = 0; typer < tempname.length; typer++) {
        nameR.add(tempname[typer]);
      }
      if (nameR[0] == "0") {
        nameR.removeAt(0);
      } else if (nameR[0] == "+") {
        nameR.removeRange(0, 3);
      }
      final name = nameR.join("");
      if (name.length == 10) {
        final loginData = LoginData(name, pass);
        setState(
          () {
            loader = true;
          },
        );
        var checker = await loginData.checkData();
        if (checker == 1) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/second',
            (_) => false,
          );
        } else {
          setter();
        }
      } else {
        setter();
      }
      setState(
        () {
          loader = false;
        },
      );
    }
  }

  void registerize() async {
    final tempname = enteredName.text;
    final pass = enteredPas.text;
    if (tempname.isEmpty || pass.isEmpty) {
      return;
    } else {
      final nameR = [];
      for (var typer = 0; typer < tempname.length; typer++) {
        nameR.add(tempname[typer]);
      }
      if (nameR[0] == "0") {
        nameR.removeAt(0);
      } else if (nameR[0] == "+") {
        nameR.removeRange(0, 3);
      }
      final name = nameR.join("");
      if (name.length == 10) {
        final registerData = RegisterData(name, pass);
        setState(
          () {
            loader = true;
          },
        );

        var checker = await registerData.registerData();
        if (checker == 1) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/second',
            (_) => false,
          );
        } else {
          setState(
            () {
              loader = false;
              k = 1;
            },
          );
        }
        setState(
          () {
            loader = false;
          },
        );
      } else {
        setState(() {
          k = 2;
        });
      }
    }
  }

  void checker(String option) async {
    if (await DataConnectionChecker().hasConnection == true) {
      if (option == "register") {
        registerize();
      } else {
        authentize();
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/fourth',
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    RouterConf().init(context);
    return loader
        ? Loading()
        : Container(
            color: Colors.black,
            child: Center(
              child: SizedBox(
                height: (RouterConf.blockV) * 44,
                width: (RouterConf.blockH) * 80,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 1,
                      left: 1,
                      child: AnimatedOpacity(
                        opacity: j == 0 ? 1.0 : 0.5,
                        duration: Duration(milliseconds: 200),
                        child: Container(
                          height: (RouterConf.blockV) * 7.3,
                          width: (RouterConf.blockV) * 17,
                          margin: EdgeInsets.only(bottom: 1.0),
                          child: GradientCard(
                            gradient: Gradients.hotLinear,
                            child: FlatButton(
                              onPressed: () {
                                setState(
                                  () {
                                    j = 0;
                                  },
                                );
                              },
                              child: Text(
                                "Login",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1,
                      right: 5,
                      child: AnimatedOpacity(
                        opacity: j == 1 ? 1.0 : 0.5,
                        duration: Duration(
                          milliseconds: 200,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 1.0),
                          height: (RouterConf.blockV) * 7.3,
                          width: (RouterConf.blockV) * 17,
                          child: GradientCard(
                            gradient: Gradients.hotLinear,
                            child: FlatButton(
                              onPressed: () {
                                setState(
                                  () {
                                    j = 1;
                                  },
                                );
                              },
                              child: Text(
                                "Register",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: (RouterConf.blockV) * 1,
                      left: (RouterConf.blockV) * 0.95,
                      right: (RouterConf.blockV) * 1.1,
                      child: j == 0 ? loginBox() : registerBox(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Card loginBox() {
    return Card(
      borderOnForeground: true,
      shadowColor: Color(0xFFF56395),
      margin: EdgeInsets.only(
        top: 0.0,
      ),
      color: Color(0xFF19191a),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: (RouterConf.blockH) * 77,
        height: (RouterConf.blockV) * 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            i == 1 ? invalidLogin() : inputLogin(),
            GradientButton(
              increaseWidthBy: 150,
              increaseHeightBy: 4,
              callback: () {
                checker("login");
              },
              gradient: Gradients.hotLinear,
              child: GradientText(
                "Login",
                shaderRect: Rect.fromLTWH(0.0, 0.0, 50.0, 50.0),
                gradient: Gradients.deepSpace,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card registerBox() {
    return Card(
      borderOnForeground: true,
      shadowColor: Color(0xFFF9AE70),
      margin: EdgeInsets.only(
        top: 0.0,
      ),
      color: Color(0xFF19191a),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: (RouterConf.blockH) * 77,
        height: (RouterConf.blockV) * 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            register(),
            GradientButton(
              increaseWidthBy: 150,
              increaseHeightBy: 4,
              callback: () {
                checker("register");
              },
              gradient: Gradients.hotLinear,
              child: GradientText(
                "Register",
                shaderRect: Rect.fromLTWH(0.0, 0.0, 50.0, 50.0),
                gradient: Gradients.deepSpace,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column invalidLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: (RouterConf.blockV) * 1, bottom: (RouterConf.blockV) * 1),
          child: Center(
            child: Text(
              "Wrong Credentials !",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        loginMain(),
      ],
    );
  }

  Column inputLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[loginMain()],
    );
  }

  Column register() {
    if (k == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          registerMain(),
        ],
      );
    } else if (k == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: (RouterConf.blockV) * 1, bottom: (RouterConf.blockV) * 1),
            child: Center(
              child: Text(
                "Already Registered User !",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          registerMain(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: (RouterConf.blockV) * 1, bottom: (RouterConf.blockV) * 1),
            child: Center(
              child: Text(
                "Please input 10-digit phone number",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          registerMain(),
        ],
      );
    }
  }

  Column loginMain() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: (RouterConf.blockV) * 1, bottom: (RouterConf.blockV) * 3),
          child: TextField(
            cursorColor: Color(
              0xFFF56395,
            ),
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              prefixIconConstraints: BoxConstraints(maxHeight: 0),
              prefixIcon: Icon(
                IC1.user,
                color: Color(
                  0xFFF56395,
                ),
              ),
              labelText: "Phone Number",
              labelStyle: TextStyle(
                  height: 0,
                  fontSize: (RouterConf.blockV) * 3,
                  color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            style: TextStyle(color: Colors.white),
            controller: enteredName,
            keyboardType: TextInputType.phone,
            onSubmitted: (_) {
              checker("login");
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: (RouterConf.blockV) * 1, bottom: (RouterConf.blockV) * 3),
          child: TextField(
            cursorColor: Color(
              0xFFF56395,
            ),
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              prefixIconConstraints: BoxConstraints(maxHeight: 0),
              prefixIcon: Icon(
                IC1.key,
                color: Color(
                  0xFFF56395,
                ),
              ),
              labelText: "Password",
              labelStyle: TextStyle(
                  height: 0,
                  fontSize: (RouterConf.blockV) * 3,
                  color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            style: TextStyle(color: Colors.white),
            controller: enteredPas,
            onSubmitted: (_) {
              checker("login");
            },
          ),
        ),
      ],
    );
  }

  Column registerMain() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: (RouterConf.blockV) * 1, bottom: (RouterConf.blockV) * 3),
          child: TextField(
            cursorColor: Color(
              0xFFF9AE70,
            ),
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              prefixIconConstraints: BoxConstraints(maxHeight: 0),
              prefixIcon: Icon(
                IC1.user,
                color: Color(
                  0xFFF9AE70,
                ),
              ),
              labelText: "Phone Number",
              labelStyle: TextStyle(
                  height: 0,
                  fontSize: (RouterConf.blockV) * 3,
                  color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            style: TextStyle(color: Colors.white),
            controller: enteredName,
            keyboardType: TextInputType.phone,
            onSubmitted: (_) {
              checker("register");
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: (RouterConf.blockV) * 1, bottom: (RouterConf.blockV) * 3),
          child: TextField(
            cursorColor: Color(
              0xFFF9AE70,
            ),
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              prefixIconConstraints: BoxConstraints(maxHeight: 0),
              prefixIcon: Icon(
                IC1.key,
                color: Color(
                  0xFFF9AE70,
                ),
              ),
              labelText: "Password",
              labelStyle: TextStyle(
                  height: 0,
                  fontSize: (RouterConf.blockV) * 3,
                  color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            style: TextStyle(color: Colors.white),
            controller: enteredPas,
            onSubmitted: (_) {
              checker("register");
            },
          ),
        ),
      ],
    );
  }
}
