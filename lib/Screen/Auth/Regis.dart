import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../Model/User_model.dart';
import '../../theme.dart';
import 'login.dart';


class Regis extends StatefulWidget {
  const Regis({Key? key}) : super(key: key);

  @override
  State<Regis> createState() => _RegisState();
}

class _RegisState extends State<Regis> {
  bool value = false;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final  fname =  TextEditingController();
  final  lname =  TextEditingController();
  final  emailEController =  TextEditingController();
  final  phoneEController =  TextEditingController();
  final  passwordEController =  TextEditingController();
  final  cpasswordEController =  TextEditingController();
  final _auth = FirebaseAuth.instance;
  late XFile imagePath;
  final ImagePicker _picker = ImagePicker();
  String imageName = '';
  RegExp regex =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  bool passwordVisible=false;
  bool cpasswordVisible=false;
  @override
  void initState(){
    super.initState();
    cpasswordVisible=true;
    passwordVisible=true;
  }
  @override
  Widget build(BuildContext context) {


    final signup = InkWell(
      onTap:  () async {

          if(imageName==''){
            Fluttertoast.showToast(msg: 'Please set profile pic');
          }
          else{
            register(emailEController.text, passwordEController.text);

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
          child: Text('SIGNUP',

            style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 3.0),
          ),
        ),

      ),
    );
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
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      imageName == ''
                          ? Stack(children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircleAvatar(
                            minRadius: 50,
                            maxRadius: 51,
                            child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(68)),
                                child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images.jpeg',
                                    image: "https://firebasestorage.googleapis.com/v0/b/askehs-8a16d.appspot.com/o/images.jpeg?alt=media&token=86157703-245b-4e9c-a90f-9ac7d51b9894&_gl=1*1eyad72*_ga*MTU2ODEwMTc1NC4xNjk2OTEwNzk0*_ga_CW55HF8NVT*MTY5NjkxMDc5My4xLjEuMTY5NjkxMTgzNi4xMC4wLjA."
                                  //fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          top: 1,
                          child: InkWell(
                            onTap: () {
                              imagePicker();
                              //              // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile(profileresponse!.data)));
                            },
                            child: Container(
                                height: 58,
                                width: 58,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(80),
                                ),
                                child: Container(
                                  // height: 40,
                                  // width: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white),
                                      borderRadius: BorderRadius.circular(
                                          50),
                                      color: Mytheme().primary,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ))),
                          ),
                        ),
                      ])
                          : Stack(children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircleAvatar(
                            minRadius: 50,
                            maxRadius: 51,
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(68)),
                              child: Container(
                                padding: const EdgeInsets.all(1.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image:
                                        FileImage(File(imagePath!.path)),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          top: 1,
                          child: InkWell(
                            onTap: () {
                              imagePicker();
                              //              // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile(profileresponse!.data)));
                            },
                            child: Container(
                                height: 58,
                                width: 58,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(80),
                                ),
                                child: Container(
                                  // height: 40,
                                  // width: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white),
                                      borderRadius: BorderRadius.circular(
                                          50),
                                      color: Mytheme().primary,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ))),
                          ),
                        )
                      ]),


                      TextFormField(
                        autofocus: false,
                        controller: fname,
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          fname.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: " Name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your  name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autofocus: false,
                        controller: emailEController,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          emailEController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Email",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                        autofocus: false,
                        controller: phoneEController,
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          phoneEController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.call),
                            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Phone Number",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your phone number";
                          }
                          if (value.length > 10 || value.length < 10) {
                            return "Enter your valid phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autofocus: false,
                        obscureText: passwordVisible,
                        controller: passwordEController,
                        onSaved: (value) {
                          passwordEController.text = value!;
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
                            prefixIcon: const Icon(Icons.vpn_key),
                            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Password",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your password";
                          }
                          if(!regex.hasMatch(value!)){
                           return "Password should be strong  ";
                             }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autofocus: false,
                        obscureText: cpasswordVisible,
                        controller: cpasswordEController,
                        onSaved: (value) {
                          cpasswordEController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(cpasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(
                                      () {
                                    cpasswordVisible = !cpasswordVisible;
                                  },
                                );
                              },
                            ),

                            prefixIcon: const Icon(Icons.vpn_key),
                            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        validator: (value) {
                          if (
                              passwordEController.text != value) {
                            return ("password not match");
                          }
                          if (value == null || value.isEmpty) {
                            return "Enter your password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      signup,
                      const SizedBox(
                        height: 10,
                      ),

                      //Checkbox
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
  void register(String email, String password) async {
    setState(() => _isLoading = true);
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
            postDetailsToFirestore()
          })
          .catchError((e) {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    print('bhtg');
    UploadTask? uploadTask;

    final path = 'Image/${imageName}';
    final file = File(imagePath.path);
    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    var url = await snapshot.ref.getDownloadURL();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel(eamil: null, phone: null);
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.phone = phoneEController.text;
    userModel.fname= fname.text;
    userModel.image=url.toString();

    await firebaseFirestore
        .collection('usersell')
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created:)");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
  }
  imagePicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
      });
    }
  }
}