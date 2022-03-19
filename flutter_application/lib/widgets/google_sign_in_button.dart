import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/utils/authentication.dart';
import 'package:flutter_application/screens/user_info_screen.dart';
import 'package:flutter_application/res/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Googleのサインボタン
class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  String? _photoURL = '';

  _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 以下の「counter」がキー名。
    prefs.setString('photoURL', _photoURL!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(CustomColors.authButton),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[50]),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User? user =
                    await Authentication.signInWithGoogle(context: context);
                setState(() {
                  _isSigningIn = false;
                });
                if (user != null) {
                  User? user =
                      await Authentication.signInWithGoogle(context: context);
                  _photoURL = user?.photoURL!;
                  _setPrefItems();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => UserInfoScreen()));
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
