import 'package:ems/widgets/inputfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String password = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: kPadding,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/graph.png',
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Internal EMS",
                style: kHeadingOne.copyWith(fontSize: 42),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: kPadding,
                child: Column(
                  children: [
                    InputField(
                      getValue: (value) {
                        setState(() {
                          print(value);
                          email = value;
                        });
                      },
                      labelText: "Email",
                      textHint: "your email",
                      prefixIcon: const Icon(
                        Icons.email,
                        color: kWhite,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InputField(
                      getValue: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      isPassword: true,
                      labelText: "Password",
                      textHint: "your password",
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: kWhite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: kPadding.copyWith(top: 10, bottom: 10),
                  primary: Colors.white,
                  textStyle: kParagraph,
                  backgroundColor: kDarkestBlue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(kBorderRadius),
                  ),
                ),
                onPressed: () {
                  if (email.isEmpty | password.isEmpty) return;

                  print("email $email\npassword $password");
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Login'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
