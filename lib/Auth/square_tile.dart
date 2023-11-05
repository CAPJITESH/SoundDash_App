import 'package:SoundDash/Auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SquareTile extends StatefulWidget {
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  State<SquareTile> createState() => _SquareTileState();
}

class _SquareTileState extends State<SquareTile> {
  final spiner = const SpinKitSpinningLines(
    color: Colors.purple,
    size: 300,
  );
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AuthService auth = AuthService();
    return InkWell(
      onTap: () {
        setState(() {
          loading = true;
        });
        bool res = auth.HandleGoogleSignIn() as bool;

        if (res) {
          setState(() {
            loading = false;
          });
        }
      },
      child: loading ? const SpinKitSpinningLines(
                color: Colors.black,
                size: 100,
              ):Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          widget.imagePath,
          height: 40,
        ),
      ),
    );
  }
}
