
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;


  int _counter = 0;





  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),


      body: SingleChildScrollView(
        child: Container(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/signin.png",height: 250,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text("Sign in",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(

                      validator: (input) =>
                      input!.isValidEmail() ? null : " Please Enter valid email",
                      controller: _emailController,
                      decoration: const InputDecoration(

                        border: OutlineInputBorder(),

                        hintText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          size: 24,
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      obscureText: _isObscure,
                      controller: _passwordController,

                      // obscureText: _isHidden ? true : false,
                      keyboardType: TextInputType.text,
                      validator: (msg) {
                        if (msg!.isEmpty) {
                          return "Please Enter Valid Password!";
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 24,
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure ? Icons.visibility : Icons.visibility_off,color: Colors.blue,),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              })
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // singIn();
                      }
                    },
                    child:
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent,
                      ),
                      height: 56,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                    ),
                    //  onTap: singIn,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text("Or Continue With Social Media"),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: (){
                            // signInWithGoogle();
                          },
                          child: Image.asset("assets/Google.png",height: 35,)),

                      GestureDetector(
                          onTap: (){
                            showNotification();
                          },
                          child: Image.asset("assets/Facebook-logo.png",height: 40,))
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        " Dont'have an account? ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        // Within the `FirstRoute` widget
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const RegisterPage()),
                          // );
                        },
                        child: const Text(
                          "Register Now ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 18,
                            color: CupertinoColors.systemBlue,
                          ),
                        ),
                      )
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

