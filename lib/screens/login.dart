import 'package:flutter/material.dart';
import 'package:home_rent_app/helper/auth.dart';
import 'package:home_rent_app/screens/location_screen.dart';
import 'package:home_rent_app/screens/main_screen.dart';
import 'package:home_rent_app/screens/reset_password.dart';
import 'package:home_rent_app/screens/signup.dart';



import '../theme.dart';
import 'demo.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool loading = false;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();

  //Facebook Sign In function
  facebookSignIn() async{
    await authMethods.signInWithFacebook().then((value) {
      if (value != null) {
        print("Done Facebook Sign In");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LocationScreen()));
      } else {
        print("Null Value Received for Facebook User");
      }
    });
  }


// Google Sign In function
  GsignIn() async {
    await authMethods.signInWithGoogle().then((value) {
      if (value != null) {
        print("Done Google Sign In");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LocationScreen()));
      } else {
        print("Null Value Received for google User");
      }
    });
  }
  
  //Email Password SIgn in Function
  SignIn() async {
    print("Email : $email.text");
    await authMethods.EmailPassSignIn(email.text, password.text).then((result) {
      if (result == null) {
        print("Done Log In");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LocationScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            result,
            style: TextStyle(fontSize: 16),
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
              ),
              Text(
                'Welcome Back',
                style: titleText,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'New to this app?',
                    style: subTitle,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAccount(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                            controller: email,
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Enter Correct Email";
                            },
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: kTextFieldColor,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                            ))),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: password,
                        validator: (val) {
                          return val.isEmpty ? "Enter Password" : null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: kTextFieldColor,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen()));
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: kZambeziColor,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //Log in Button
              GestureDetector(
                onTap: () => SignIn(),
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: kPrimaryColor),
                  child: Text(
                    'Log In',
                    style: textButton.copyWith(color: kWhiteColor),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              Text(
                'Or log in with:',
                style: subTitle.copyWith(color: kBlackColor),
              ),
              SizedBox(
                height: 20,
              ),

              // Login Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () =>facebookSignIn(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: 20,
                            width: 20,
                            image: AssetImage('images/facebook.png'),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Facebook'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => GsignIn(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            height: 20,
                            width: 20,
                            image: AssetImage('images/google.png'),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Google'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
