import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/mode_dialog.dart';

// ignore: must_be_immutable
class ModeButton extends StatefulWidget {
  String title;
  String path;
  String explanation;
  ModeButton(this.title, this.path, this.explanation, {Key? key})
      : super(key: key);
  @override
  _ModeButton createState() => _ModeButton();
}

class _ModeButton extends State<ModeButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20.0,
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        highlightColor: Colors.blue,
        splashColor: const Color.fromRGBO(0, 0, 0, 0.259),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return ModeDialog(widget.title, widget.path, widget.explanation);
            },
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 28, color: Colors.grey[700]),
                ),
                const SizedBox(height: 5),
                Ink.image(
                  image: AssetImage("images/${widget.path}"),
                  height: 200,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
