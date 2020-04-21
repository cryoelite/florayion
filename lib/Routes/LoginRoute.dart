import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import './LoadingRoute.dart';
import '../logindata/LoginData.dart';
import '../logindata/RegisterData.dart';
import '../LoginData/tempData.dart';

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
          UserName.setter(name);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AnimatedOpacity(
                      opacity: j == 0 ? 1.0 : 0.5,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        width: (MediaQuery.of(context).size.width) / 2,
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
                    AnimatedOpacity(
                      opacity: j == 1 ? 1.0 : 0.5,
                      duration: Duration(
                        milliseconds: 200,
                      ),
                      child: Container(
                        width: (MediaQuery.of(context).size.width) / 2,
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
                  ],
                ),
                j == 0 ? loginBox() : registerBox(),
              ],
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
        width: 300,
        height: 250,
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
        width: 300,
        height: 250,
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
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "Wrong Credentials !",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              hintText: "Phone Number",
            ),
            controller: enteredName,
            keyboardType: TextInputType.phone,
            onSubmitted: (_) {
              authentize();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              hintText: "Password",
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

  Column inputLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              hintText: "Phone Number",
            ),
            controller: enteredName,
            keyboardType: TextInputType.phone,
            onSubmitted: (_) {
              authentize();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.center,
            decoration: new InputDecoration(
              hintText: "Password",
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

  Column register() {
    if (k == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                hintText: "Phone Number",
              ),
              controller: enteredName,
              keyboardType: TextInputType.phone,
              onSubmitted: (_) {
                registerize();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                hintText: "Password",
              ),
              controller: enteredPas,
              onSubmitted: (_) {
                registerize();
              },
            ),
          ),
        ],
      );
    } else if (k == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Already Registered User !",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                hintText: "Phone Number",
              ),
              controller: enteredName,
              keyboardType: TextInputType.phone,
              onSubmitted: (_) {
                registerize();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                hintText: "Password",
              ),
              controller: enteredPas,
              onSubmitted: (_) {
                registerize();
              },
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Please input 10-digit phone number",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                hintText: "Phone Number",
              ),
              controller: enteredName,
              keyboardType: TextInputType.phone,
              onSubmitted: (_) {
                registerize();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                hintText: "Password",
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
}
