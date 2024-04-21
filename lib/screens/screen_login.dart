import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/screens/screen_home.dart';
import 'package:flutter_application_shopping/screens/screen_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_shopping/widgets/sucess_easy.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter_glow/flutter_glow.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> checkLogin(BuildContext context) async {
    try {
      ScreenLoader().screenLoaderSuccessFailStart();
      final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      if (userCredential.user != null) {
        // ignore: use_build_context_synchronously
        userCredential.user!.uid.toString();
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => const ScreenHome()));
        ScreenLoader().screenLoaderDismiss('1', 'Welcome Home');
      } else {}
    } catch (e) {
      ScreenLoader().screenLoaderDismiss('0', 'Unsucessfull Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text(
            'Login',
            style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Image(
                image: AssetImage('assets/logo.png'),
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a valid emial adress!';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "User Name",
                      fillColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                child: TextFormField(
                    controller: passController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password Cannot be empty!';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      fillColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(125, 50),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Text('Cancel')),
                    const SizedBox(
                      width: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            checkLogin(context);
                          }
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            fixedSize: const Size(125, 50),
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        child: const Text('Login'))
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const Center(
                  child: GlowText(
                'Need an Account?',
                glowColor: Colors.purple,
                textScaleFactor: 1.2,
              )),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 80, right: 80),
                child: GlowButton(
                    glowColor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const ScreenRegistration()));
                    },
                    child: const Text(
                      'Sign-up',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ));
  }
}
