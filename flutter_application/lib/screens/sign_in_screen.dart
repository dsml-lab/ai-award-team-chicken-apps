import 'package:flutter/material.dart';
import 'package:flutter_application/res/custom_colors.dart';
import 'package:flutter_application/utils/authentication.dart';
import 'package:flutter_application/widgets/google_sign_in_button.dart';

// サインインを行うタイトル画面
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/title2.png'), fit: BoxFit.fill),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100, bottom: 5),
                        child: Text(
                          "みりょくどおり",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: CustomColors.title,
                            backgroundColor: Colors.yellow[50],
                            fontSize: 55,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      // Text(
                      //   'Hometown',
                      //   style: TextStyle(
                      //     fontFamily: 'Poppins',
                      //     color: CustomColors.title,
                      //     fontSize: 55,
                      //     fontWeight: FontWeight.w800,
                      //   ),
                      // ),
                      const SizedBox(height: 100),
                      Flexible(
                          flex: 1,
                          child: Image.asset('assets/pin.png', height: 150)),
                    ],
                  ),
                ),
                FutureBuilder(
                  // Firebaseの初期化
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      // ignore: prefer_const_constructors
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return GoogleSignInButton();
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.firebaseOrange),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
