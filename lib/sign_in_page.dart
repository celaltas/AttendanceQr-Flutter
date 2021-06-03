import 'package:attendanceviaqr/sign_up_page.dart';
import 'package:flutter/material.dart';

import 'landing_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance via QR Code"),
        elevation: 8,
      ),
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlutterLogo(
                size: 144,
              ),
              SizedBox(
                height: 12,
              ),
              Text("Sign In",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 12,
              ),
              Form(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 40),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: "Email Adress",
                          labelText: "Email",
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Password",
                          labelText: "Password",
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                    ),
                  ],
                ),
              )),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 350, height: 50),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LandingPage()));
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                    elevation: 5,
                    shadowColor: Colors.blue.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text("or",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 6,
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 350, height: 50),
                child: ElevatedButton.icon(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Image.asset("images/google-logo.png"),
                  ),
                  onPressed: () {},
                  label: Text(
                    "Sign in with Google",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                    elevation: 5,
                    shadowColor: Colors.blue.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text("Create an account"))
            ],
          ),
        ),
      ),
    );
  }
}
