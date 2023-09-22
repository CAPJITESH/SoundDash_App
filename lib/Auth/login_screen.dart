import 'package:SoundDash/Auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService auth = AuthService();

  final spiner = const SpinKitSpinningLines(
    color: Colors.purple,
    size: 150,
  );
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: loading
            ? const SpinKitSpinningLines(
                color: Colors.purple,
                size: 50,
              )
            : ElevatedButton(
                onPressed: () {
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
                child: const Text("Signin with Google")));
  }
}
