import 'package:flutter/material.dart';
import 'package:home_rent_app/helper/auth.dart';
import 'package:home_rent_app/screens/location_screen.dart';
import 'package:home_rent_app/widgets/checkbox.dart';


import '../theme.dart';
import 'demo.dart';
import 'main_screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool loading = false;
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  final formkey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();

// Google Sign In function
  GsignIn() async {
    await authMethods.signInWithGoogle().then((value) {
      if (value != null) {
        print("Done Google Sign In");
        Navigator.pushReplacementNamed(context,LocationScreen.id);
      } else {
        print("Null Value Received for google User");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Create Account',
                style: titleText,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Row(
                children: [
                  Text(
                    'Already a member?',
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
                              builder: (context) => LocationScreen()));
                    },
                    child: Text(
                      'Log In',
                      style: textButton.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                          controller: firstName,
                          decoration: InputDecoration(
                            labelText: "First Name",
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
                          controller: lastName,
                          decoration: InputDecoration(
                            labelText: "Last Name",
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
                          controller: phone,
                          decoration: InputDecoration(
                            labelText: "Phone",
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
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
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
            Padding(
              padding: kDefaultPadding,
              child: CheckBox('Agree to terms and conditions.'),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: kDefaultPadding,
              child: CheckBox('I have at least 18 years old.'),
            ),
            SizedBox(
              height: 20,
            ),

            //Sign up Button
            Padding(
                padding: kDefaultPadding,
                child: GestureDetector(
                  onTap: () async {
                    print("Email : $email.text");
                    await authMethods.EmailPassSignUp(email.text, password.text)
                        .then((result) {
                      if (result == null) {
                        print("Sign Up");
                        Navigator.pushReplacementNamed(context, LocationScreen.id);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            result,
                            style: TextStyle(fontSize: 16),
                          ),
                        ));
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: kPrimaryColor),
                    child: Text(
                      'Sign Up',
                      style: textButton.copyWith(color: kWhiteColor),
                    ),
                  ),
                )),

            SizedBox(
              height: 20,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Text(
                'Or log in with:',
                style: subTitle.copyWith(color: kBlackColor),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: kDefaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
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
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
