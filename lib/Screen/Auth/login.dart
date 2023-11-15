
import 'package:dormakaba/Screen/Dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';

import '../../theme.dart';
import 'Regis.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var breed_type=null;
  final  emailController =  TextEditingController();
  final  nameController =  TextEditingController();
  final  passwordController =  TextEditingController();
  final _auth = FirebaseAuth.instance;
  final uid1 = new FlutterSecureStorage();
  final LocalStorage emaile =  LocalStorage('localstorage_app');


  bool passwordVisible=false;

  @override
  void initState(){
    super.initState();
    passwordVisible=true;
  }


  @override
  Widget build(BuildContext context) {










    return Scaffold(
      backgroundColor: Mytheme().primary,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      TextFormField(
                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Email",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        validator: (emailController) {
                          if (!emailController.toString().contains("@")) {
                            return "Please enter the valid email";
                          }
                          if (emailController!.isEmpty) {
                            return ("Please enter the value");
                          }

                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                        autofocus: false,
                        obscureText: passwordVisible,

                        controller: passwordController,
                        onSaved: (value) {
                          passwordController.text = value!;
                        },

                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(
                                      () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                            prefixIcon: Icon(Icons.vpn_key),
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "password",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          // RegExp regex= new RegExp(r'^.{6,}$');
                          print(value);
                          if (value!.isEmpty) {
                            return (" Please enter password");
                          }

                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      InkWell(
                        onTap:  _isLoading ? null :() async {
                          if (_formKey.currentState!.validate()) {

                            login(
                              emailController.text,
                              passwordController.text,
                            );


                          }
                        },
                        child: Container(

                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Mytheme().primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text('LOGIN',

                              style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 3.0),
                            ),
                          ),

                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Dont have a account?"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Regis()));
                            },
                            child: Text(
                              'Signup',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Mytheme().primary),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(String email, String password) async {
    setState(() => _isLoading = true);
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) async => {
      uid1.write(key: 'uid', value: uid.toString()),
    emaile.setItem('email', email.toString()),
      Fluttertoast.showToast(msg: "Login Successful"),//
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Dashboard(),
      ))
    })
        .catchError((e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: e!.message);
    });
  }


}