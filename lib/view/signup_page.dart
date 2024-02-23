import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/utils/formHelper.dart';
import 'package:first_project/view/library_page.dart';
import 'package:first_project/view/login_page.dart';
import 'package:first_project/controllers/authentication_controller.dart';
import 'package:first_project/utils/uiHelper.dart';
import 'package:first_project/utils/validators.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void _handleEmailAndPasswordSignUp(email, password) async {
    if (formKey.currentState!.validate()) {
      try {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Library()));
      } catch (ex) {
        return UiHelper.CustomAlertBox(context, ex.toString());
      }
    }
  }

  void _handleGoogleSignIn() async {
    try {
      UserCredential? user = await Authentication().signInWithGoogle();
      if (user != null) {
        print("Google SignIn successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Library()));
      }
    } catch (e) {
      UiHelper.CustomAlertBox(context, "Google SignIn Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Sign Up',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          children: [
            Image.asset(
              'assets/images/img.png',
              height: 100,
            ),
            Container(
              width: 300,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      // height: 50,
                      margin: const EdgeInsets.only(top: 40),
                      child: TextFormField(
                          validator: Validators.emailValidator,
                          controller: emailController,
                          decoration: customDecoration.customInputDecoration(
                              "Email", Icons.email)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                          validator: Validators.passwordValidator,
                          obscureText: true,
                          controller: passwordController,
                          decoration: customDecoration.customInputDecoration(
                              "Password", Icons.password)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                          validator: Validators.phoneNumberValidator,
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          decoration: customDecoration.customInputDecoration(
                              "Phone Number", Icons.phone)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: UiHelper.CustomButton(() {
                        _handleEmailAndPasswordSignUp(emailController.text.toString(),
                            passwordController.text.toString());
                      }, "Submit"),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account?",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            ),
            Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Text(
                      "Or Sign In With",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _handleGoogleSignIn,
                          iconSize: 30,
                          padding: EdgeInsets.all(15.0),
                          icon: Icon(Icons.icecream),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ),),);
  }
}
