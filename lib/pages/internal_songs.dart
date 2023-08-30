import 'package:flutter/material.dart';

class InternalSongs extends StatefulWidget {
  const InternalSongs({super.key});

  @override
  State<InternalSongs> createState() => _InternalSongsState();
}

class _InternalSongsState extends State<InternalSongs> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Internal Songs Here"))
    );
  }
}