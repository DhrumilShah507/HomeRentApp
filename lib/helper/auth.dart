import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
class AuthMethods {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithFacebook() async {
    try{
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);}
    on Exception catch(error){
      print("Error FaceBook : $error");
    }catch(error){
      print(error);
    }
  }


  Future EmailPassSignIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message;
    } catch (error) {
      return error;
    }
  }

  Future EmailPassSignUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message;
    } catch (error) {
      return error;
    }
  }

  Future SignOut() async => await FirebaseAuth.instance.signOut();


  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
  }
}
