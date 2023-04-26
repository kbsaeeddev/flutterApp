// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;
  RegExp regExp = RegExp("key: \\[\\d+\\]");
    FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  get key => null;
  //validation
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  // File? _pickedImage;
  String? url;
  // final GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  List<String> validChar = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  void validation() {
    //username validate
    if (userName.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("User name is empty")));
      return;
    }
    if (userName.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Username is too short")));
      return;
    }
    for (int i = 0; i < userName.text.length; i++) {
      if (validChar.contains(userName.text[i])) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // backgroundColor: ColorConstants.statusBarColor,
            content: const Text("User name is not valid")));
        return;
      }
    }
    //    if(RegExp(r'^[A-Za-z]+$').hasMatch(userName.text))
    //  {
    //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: ColorConstants.statusBarColor,
    //       content: const Text("User name is not valid")));
    //   return;
    //  }
    //  if(userName.text.contains(new RegExp(r'^[a-z]+$')))
    //    {
    //      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         backgroundColor: ColorConstants.statusBarColor,
    //         content: const Text("User name is not valid")));
    //     return;
    //    }
    //email validate

    if (email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is empty")));
      return;
    } else if (!email.text.contains("@") || !email.text.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is not valid")));
      return;
    }
    //phone
        if (phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Phone Number is empty")));
      return;
    }
    //password validate
    if (password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is empty")));
      return;
    }
    if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is too short")));
      return;
    }

    if (!letterReg.hasMatch(password.text) || !numReg.hasMatch(password.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is week")));
      return;
    }
    if (cPassword.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Confirm your password first")));
      return;
    }
    if (cPassword.text.trim() != password.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Match your password")));
      return;
    }
    print("success");
    sendData();
  }

  void sendData() async {
    try {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
      var date = DateTime.now().toString();
      var dateparse = DateTime.parse(date);
      var formattedDate =
          "${dateparse.day}-${dateparse.month}-${dateparse.year}";
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());
      print("Account done");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        "userId": auth.currentUser?.uid,
        "name": userName.text,
        "email": email.text,
        "phone": phone.text,
        "password": password.text,
        'joinedAt': formattedDate,
        'createdAt': Timestamp.now(),
        'image': "",
        'role': "user",
        'status': "approved",
        "coins": 0
      });
      await auth.signOut();
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) =>  LoginScreen()));
    //   Navigator.push(
    // context,
    // new MaterialPageRoute(
    //     builder: (BuildContext context) =>
    //     LoginScreen()));
      // Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // backgroundColor: ColorConstants.statusBarColor,
            content: const Text("The password provided is too weak.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // backgroundColor: ColorConstants.statusBarColor,
            content: const Text("Account already exist for that email")));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // backgroundColor: ColorConstants.statusBarColor,
            content: Text(e.code)));
        print('The account already exists for that email.');
      }
      await FirebaseAuth.instance.currentUser?.delete();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        title: Text('Sign Up'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        
      ),
        body: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: SizedBox(
                  //     width: 220,
                  //     child: Image.asset("assets/logo.png"),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Let\'s register your account in',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Enter your detail below and free signup now',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      controller: userName,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                                    const SizedBox(height: 18),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      controller: phone,
                                            keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: 'Phone',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      toolbarOptions: ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      controller: password,
                      obscureText: _obscurePasswordText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePasswordText = !_obscurePasswordText;
                            });
                          },
                          child: Icon(_obscurePasswordText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      toolbarOptions: ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      controller: cPassword,
                      obscureText: _obscureConfirmPasswordText,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureConfirmPasswordText =
                                  !_obscureConfirmPasswordText;
                            });
                          },
                          child: Icon(_obscureConfirmPasswordText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: validation,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) => false);
                        },
                        child: const Text(
                          'Login Now',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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