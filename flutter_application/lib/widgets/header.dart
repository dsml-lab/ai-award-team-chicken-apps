import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/res/custom_colors.dart';
import 'package:flutter_application/screens/sign_in_screen.dart';
import 'package:flutter_application/utils/authentication.dart';

// 認証が終わったとの画面
class AppBarHeder extends StatefulWidget with PreferredSizeWidget {
  const AppBarHeder({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _AppBarHeder createState() => _AppBarHeder();
}

class _AppBarHeder extends State<AppBarHeder> {
  late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: SizedBox(
        height: kToolbarHeight,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 5.0, right: 5.0, top: 15.0, bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: _user.photoURL != null
                    ? ClipOval(
                        child: Material(
                          color: CustomColors.firebaseGrey.withOpacity(0.3),
                          child: Image.network(
                            _user.photoURL!,
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Material(
                          color: CustomColors.firebaseGrey.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Icon(
                              Icons.person,
                              size: kToolbarHeight,
                              color: CustomColors.firebaseGrey,
                            ),
                          ),
                        ),
                      ),
              ),
              Text(
                'Adventure Hometown',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: CustomColors.header,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              FittedBox(
                fit: BoxFit.fitHeight,
                child: _isSigningOut
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : IconButton(
                        // 表示アイコン
                        icon: Icon(
                          Icons.logout,
                        ),
                        // サイズ
                        iconSize: kToolbarHeight,
                        //カラー
                        color: CustomColors.icons,
                        onPressed: () async {
                          setState(() {
                            _isSigningOut = true;
                          });
                          await Authentication.signOut(context: context);
                          setState(() {
                            _isSigningOut = false;
                          });
                          Navigator.of(context)
                              .pushReplacement(_routeToSignInScreen());
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
