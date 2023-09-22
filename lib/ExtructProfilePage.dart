import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExtructProfilePage extends StatefulWidget {
  final id;
  const ExtructProfilePage(this.id, {super.key});

  @override
  State<ExtructProfilePage> createState() => _ExtructProfilePageState();
}

class _ExtructProfilePageState extends State<ExtructProfilePage> {
  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              icon: Icon(Icons.arrow_forward_ios))
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUid)
              .collection('Cards')
              .doc(widget.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              return Center(
                child: ListView(children: [
                  if (data.containsKey('jsonFront'))
                    Column(
                      
                      children: (data['jsonFront'] as Map<String, dynamic>)
                          .entries
                          .map((e) => ListTile(
                                title: Text(e.key),
                                subtitle: e.value is List
                                    ? Column(
                                        
                                        children: (e.value as List)
                                            .map(
                                              (value) => Column(
                                                
                                                children: (value
                                                        as Map<String, dynamic>)
                                                    .entries
                                                    .map((e) => ListTile(
                                                          title: Text(e.key),
                                                          subtitle:
                                                              Text(e.value),
                                                          titleTextStyle: Theme
                                                                  .of(context)
                                                              .listTileTheme
                                                              .subtitleTextStyle,
                                                          subtitleTextStyle:
                                                              Theme.of(context)
                                                                  .listTileTheme
                                                                  .titleTextStyle,
                                                        ))
                                                    .toList(),
                                              ),
                                            )
                                            .toList())
                                    : Text(e.value),
                                titleTextStyle: Theme.of(context)
                                    .listTileTheme
                                    .subtitleTextStyle,
                                subtitleTextStyle: Theme.of(context)
                                    .listTileTheme
                                    .titleTextStyle,
                              ))
                          .toList(),
                    ),
                  if (data.containsKey('jsonBack'))
                    Column(
                      
                      children: (data['jsonBack'] as Map<String, dynamic>)
                          .entries
                          .map((e) => ListTile(
                                title: Text(e.key),
                                subtitle: e.value is List
                                    ? Column(
                                        
                                        children: (e.value as List)
                                            .map(
                                              (value) => value is Map<String,dynamic>?Column(
                                                
                                                children: (value
                                                        as Map<String, dynamic>)
                                                    .entries
                                                    .map((e) => ListTile(
                                                          title: Text(e.key),
                                                          subtitle:
                                                              Text(e.value),
                                                          titleTextStyle: Theme
                                                                  .of(context)
                                                              .listTileTheme
                                                              .subtitleTextStyle,
                                                          subtitleTextStyle:
                                                              Theme.of(context)
                                                                  .listTileTheme
                                                                  .titleTextStyle,
                                                        ))
                                                    .toList(),
                                              ):Text(value.toString()),
                                            )
                                            .toList())
                                    : Text(e.value),
                                titleTextStyle: Theme.of(context)
                                    .listTileTheme
                                    .subtitleTextStyle,
                                subtitleTextStyle: Theme.of(context)
                                    .listTileTheme
                                    .titleTextStyle,
                              ))
                          .toList(),
                    )
                ]),
              );
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
