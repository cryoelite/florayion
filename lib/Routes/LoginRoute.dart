import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import './LoadingRoute.dart';
import '../logindata/LoginData.dart';
import '../logindata/RegisterData.dart';

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

  @override
  Widget build(BuildContext context) {
    RouterConf().init(context);
    return loader
        ? Loading()
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xCCF3377A),
                  Color(0xFF9C3788),
                  Color(0xFC6B3890),
                ],
              ),
            ),
            child: Center(
              child: SizedBox(
                height: (RouterConf.blockV) * 40,
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
                      bottom: 7,
                      left: 5,
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
      margin: EdgeInsets.only(
        top: 0.0,
      ),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: (RouterConf.blockH) * 77,
        height: (RouterConf.blockV) * 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            i == 1 ? invalidLogin() : inputLogin(),
            GradientButton(
              increaseWidthBy: 150,
              increaseHeightBy: 4,
              callback: () {
                authentize();
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
      margin: EdgeInsets.only(
        top: 0.0,
      ),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: (RouterConf.blockH) * 77,
        height: (RouterConf.blockV) * 32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            register(),
            GradientButton(
              increaseWidthBy: 150,
              increaseHeightBy: 4,
              callback: () {
                registerize();
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
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              hintText: "Phone Number",
              hintStyle: TextStyle(
                fontSize: (RouterConf.blockV) * 3,
              ),
            ),
            controller: enteredName,
            keyboardType: TextInputType.phone,
            onSubmitted: (_) {
              authentize();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: (RouterConf.blockV) * 1, bottom: (RouterConf.blockV) * 3),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(
                fontSize: (RouterConf.blockV) * 3,
              ),
            ),
            controller: enteredPas,
            onSubmitted: (_) {
              authentize();
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
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              hintText: "Phone Number",
              hintStyle: TextStyle(
                fontSize: (RouterConf.blockV) * 3,
              ),
            ),
            controller: enteredName,
            keyboardType: TextInputType.phone,
            onSubmitted: (_) {
              registerize();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: (RouterConf.blockV) * 1, bottom: (RouterConf.blockV) * 3),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(
                fontSize: (RouterConf.blockV) * 3,
              ),
            ),
            controller: enteredPas,
            onSubmitted: (_) {
              registerize();
            },
          ),
        ),
      ],
    );
  }
}
