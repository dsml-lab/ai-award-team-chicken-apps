import 'package:flutter/material.dart';
import 'package:flutter_application/res/custom_colors.dart';
import 'package:flutter_application/utils/authentication.dart';
import 'package:flutter_application/widgets/google_sign_in_button.dart';

// サインインを行うタイトル画面
class SignInScreen extends StatefulWidget {
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
              image: AssetImage('images/title.png'), fit: BoxFit.fill),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Adventure",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: CustomColors.title,
                          fontSize: 55,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Hometown',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: CustomColors.title,
                          fontSize: 55,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 150),
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

// Text(
//     'Adventure\nHometown',
//     style: TextStyle(
//       fontFamily: 'Poppins',
//       fontSize: 55,
//       color: const Color(0xffff6200),
//       fontWeight: FontWeight.w800,
//       height: 1.0909090909090908,
//     ),
//     textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
//     textAlign: TextAlign.center,
//     softWrap: false,
//   )

// SingleChildScrollView(
//     primary: false,
//     scrollDirection: Axis.horizontal,
//     child: SizedBox(
//       width: 1269.0,
//       height: 846.0,
//       child: Stack(
//         children: <Widget>[
//           // Adobe XD layer: 'AdobeStock_293829213' (shape)
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: const AssetImage(''),
//                 fit: BoxFit.fill,
//               ),
//             ),
//             margin: EdgeInsets.fromLTRB(0.0, 0.0, -857.0, 0.0),
//           ),
//         ],
//       ),
//     ),
//   )

// Text(
//     'Adventure\nHometown',
//     style: TextStyle(
//       fontFamily: 'Poppins',
//       fontSize: 55,
//       color: const Color(0xffff6200),
//       fontWeight: FontWeight.w800,
//       height: 1.0909090909090908,
//     ),
//     textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
//     textAlign: TextAlign.center,
//     softWrap: false,
//   )