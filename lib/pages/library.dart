import 'package:flutter/material.dart';
import 'package:SoundDash/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().getHistoryStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No history data available.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((QueryDocumentSnapshot historyDoc) {
              Map<String, dynamic> data = historyDoc.data() as Map<String, dynamic>;

              return ListTile(
                leading: Image.network(data['image']),
                title: Text(data['title']),
                subtitle: Text(data['artist']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
